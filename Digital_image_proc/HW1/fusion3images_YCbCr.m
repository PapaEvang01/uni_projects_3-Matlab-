clc; close all; clear;

% Load and resize the images
img1 = imresize(imread('house1.png'), [235, 538]);
img2 = imresize(imread('house2.png'), [235, 538]);
img3 = imresize(imread('house3.png'), [235, 538]);

% Display original images
figure('Name','Original Images');
subplot(1,3,1); imshow(img1); title('Image 1');
subplot(1,3,2); imshow(img2); title('Image 2');
subplot(1,3,3); imshow(img3); title('Image 3');
waitforbuttonpress;

% Convert RGB to YCbCr
ycbcr1 = rgb2ycbcr(img1);
ycbcr2 = rgb2ycbcr(img2);
ycbcr3 = rgb2ycbcr(img3);

% Histogram equalization on the luminance (Y) channel
y1 = histeq(ycbcr1(:,:,1)); cb1 = ycbcr1(:,:,2); cr1 = ycbcr1(:,:,3);
y2 = histeq(ycbcr2(:,:,1)); cb2 = ycbcr2(:,:,2); cr2 = ycbcr2(:,:,3);
y3 = histeq(ycbcr3(:,:,1)); cb3 = ycbcr3(:,:,2); cr3 = ycbcr3(:,:,3);

% Convert equalized Y back to RGB for visualization
rgb1_eq = ycbcr2rgb(cat(3, y1, cb1, cr1));
rgb2_eq = ycbcr2rgb(cat(3, y2, cb2, cr2));
rgb3_eq = ycbcr2rgb(cat(3, y3, cb3, cr3));

% Show histogram equalization effect
figure('Name','Histogram Equalization on Y Channel');
subplot(3,2,1); imshow(img1); title('Original Image 1');
subplot(3,2,2); imshow(rgb1_eq); title('Equalized RGB 1');
subplot(3,2,3); imshow(img2); title('Original Image 2');
subplot(3,2,4); imshow(rgb2_eq); title('Equalized RGB 2');
subplot(3,2,5); imshow(img3); title('Original Image 3');
subplot(3,2,6); imshow(rgb3_eq); title('Equalized RGB 3');
waitforbuttonpress;

% Wavelet decomposition (Cr channels)
wave = 'db6';
[C1,P1] = wavedec2(cr1, 2, wave);
[C2,P2] = wavedec2(cr2, 2, wave);
[C3,P3] = wavedec2(cr3, 2, wave);

% Extract coefficients at level 2
A12 = appcoef2(C1, P1, wave, 2);
A22 = appcoef2(C2, P2, wave, 2);
A32 = appcoef2(C3, P3, wave, 2);

H12 = detcoef2('h', C1, P1, 2);
H22 = detcoef2('h', C2, P2, 2);
H32 = detcoef2('h', C3, P3, 2);

V12 = detcoef2('v', C1, P1, 2);
V22 = detcoef2('v', C2, P2, 2);
V32 = detcoef2('v', C3, P3, 2);

D12 = detcoef2('d', C1, P1, 2);
D22 = detcoef2('d', C2, P2, 2);
D32 = detcoef2('d', C3, P3, 2);

% Extract level 1 detail coefficients
H11 = detcoef2('h', C1, P1, 1);
H21 = detcoef2('h', C2, P2, 1);
H31 = detcoef2('h', C3, P3, 1);

V11 = detcoef2('v', C1, P1, 1);
V21 = detcoef2('v', C2, P2, 1);
V31 = detcoef2('v', C3, P3, 1);

D11 = detcoef2('d', C1, P1, 1);
D21 = detcoef2('d', C2, P2, 1);
D31 = detcoef2('d', C3, P3, 1);

% Max-absolute fusion rule (use helper function maxa)
A2 = maxa(maxa(A12, A22), A32);
H2 = maxa(maxa(H12, H22), H32);
V2 = maxa(maxa(V12, V22), V32);
D2 = maxa(maxa(D12, D22), D32);
H1 = maxa(maxa(H11, H21), H31);
V1 = maxa(maxa(V11, V21), V31);
D1 = maxa(maxa(D11, D21), D31);

% Reshape for reconstruction
A2 = reshape(A2, 1, []);
H2 = reshape(H2, 1, []);
V2 = reshape(V2, 1, []);
D2 = reshape(D2, 1, []);
H1 = reshape(H1, 1, []);
V1 = reshape(V1, 1, []);
D1 = reshape(D1, 1, []);

% Reconstruct Cr fused channel
C_fused = [A2 H2 V2 D2 H1 V1 D1];
cr_fused = waverec2(C_fused, P1, wave);

% Rebuild the fused YCbCr image
ycbcr_fused = cat(3, y2, cb2, cr_fused);  % use Y and Cb from img2
rgb_fused = ycbcr2rgb(ycbcr_fused);

% Display fused results
figure; imshow(ycbcr_fused); title('Fused Image in YCbCr');
waitforbuttonpress;
figure; imshow(rgb_fused); title('Final Fused Image in RGB');

% --- Helper function: Max Absolute Fusion ---
function c = maxa(a, b)
    a = double(a); b = double(b); 
    c = b;
    [M, N] = size(a);
    for i = 1:M
        for j = 1:N
            if abs(a(i,j)) >= abs(b(i,j))
                c(i,j) = a(i,j);
            end
        end
    end
end

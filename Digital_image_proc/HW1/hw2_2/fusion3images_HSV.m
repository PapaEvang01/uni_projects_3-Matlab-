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

% Convert RGB to HSV
hsv1 = rgb2hsv(img1);
hsv2 = rgb2hsv(img2);
hsv3 = rgb2hsv(img3);

% Histogram equalization on V channel
v1 = histeq(hsv1(:,:,3));
v2 = histeq(hsv2(:,:,3));
v3 = histeq(hsv3(:,:,3));

% Replace V channels with equalized versions
hsv1_eq = cat(3, hsv1(:,:,1), hsv1(:,:,2), v1);
hsv2_eq = cat(3, hsv2(:,:,1), hsv2(:,:,2), v2);
hsv3_eq = cat(3, hsv3(:,:,1), hsv3(:,:,2), v3);

% Convert back to RGB for comparison
rgb1_eq = hsv2rgb(hsv1_eq);
rgb2_eq = hsv2rgb(hsv2_eq);
rgb3_eq = hsv2rgb(hsv3_eq);

% Show histogram equalization effect
figure('Name','Histogram Equalization on V Channel');
subplot(3,2,1); imshow(img1); title('Original Image 1');
subplot(3,2,2); imshow(rgb1_eq); title('Equalized RGB 1');
subplot(3,2,3); imshow(img2); title('Original Image 2');
subplot(3,2,4); imshow(rgb2_eq); title('Equalized RGB 2');
subplot(3,2,5); imshow(img3); title('Original Image 3');
subplot(3,2,6); imshow(rgb3_eq); title('Equalized RGB 3');
waitforbuttonpress;

% Wavelet decomposition on S (Saturation) channel
wave = 'db6';
[C1,P1] = wavedec2(hsv1(:,:,2), 2, wave);
[C2,P2] = wavedec2(hsv2(:,:,2), 2, wave);
[C3,P3] = wavedec2(hsv3(:,:,2), 2, wave);

% Extract level-2 coefficients
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

% Level-1 detail coefficients
H11 = detcoef2('h', C1, P1, 1);
H21 = detcoef2('h', C2, P2, 1);
H31 = detcoef2('h', C3, P3, 1);

V11 = detcoef2('v', C1, P1, 1);
V21 = detcoef2('v', C2, P2, 1);
V31 = detcoef2('v', C3, P3, 1);

D11 = detcoef2('d', C1, P1, 1);
D21 = detcoef2('d', C2, P2, 1);
D31 = detcoef2('d', C3, P3, 1);

% Fusion using max-abs rule
A2 = maxa(maxa(A12, A22), A32);
H2 = maxa(maxa(H12, H22), H32);
V2 = maxa(maxa(V12, V22), V32);
D2 = maxa(maxa(D12, D22), D32);
H1 = maxa(maxa(H11, H21), H31);
V1 = maxa(maxa(V11, V21), V31);
D1 = maxa(maxa(D11, D21), D31);

% Reshape and reconstruct S (Saturation) channel
A2 = reshape(A2, 1, []);
H2 = reshape(H2, 1, []);
V2 = reshape(V2, 1, []);
D2 = reshape(D2, 1, []);
H1 = reshape(H1, 1, []);
V1 = reshape(V1, 1, []);
D1 = reshape(D1, 1, []);

C_fused = [A2 H2 V2 D2 H1 V1 D1];
s_fused = waverec2(C_fused, P1, wave);

% Build fused HSV image (H and V from image 2)
hsv_fused = cat(3, hsv2(:,:,1), s_fused, v2);
rgb_fused = hsv2rgb(hsv_fused);

% Display results
figure; imshow(hsv_fused); title('Fused HSV Image');
waitforbuttonpress;
figure; imshow(rgb_fused); title('Final Fused RGB Image');

% --- Helper Function ---
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

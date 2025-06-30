clc; clear; close all;

% --- Load and Resize Images ---
imgNames = {'tree1.png', 'tree2.png', 'tree3.png', 'tree4.png'};
imgs = cell(1,4);
for i = 1:4
    imgs{i} = imresize(imread(imgNames{i}), [235, 538]);
end

% --- Display Original Images ---
figure('Name','Original Images');
for i = 1:4
    subplot(2,2,i);
    imshow(imgs{i});
    title(['Image ', num2str(i)]);
end
waitforbuttonpress;

% --- Convert to HSV and Equalize Hue Channel ---
hsv_eq = cell(1,4);
for i = 1:4
    hsv_img = rgb2hsv(imgs{i});
    H_eq = histeq(hsv_img(:,:,1));
    hsv_eq{i} = cat(3, H_eq, hsv_img(:,:,2), hsv_img(:,:,3));
    
    % Optional visualization: original, RGB hist-eq, HSV-eq, back to RGB
    RGB_hist_eq = cat(3, histeq(imgs{i}(:,:,1)), ...
                         histeq(imgs{i}(:,:,2)), ...
                         histeq(imgs{i}(:,:,3)));
    RGB_HSV_eq = hsv2rgb(hsv_eq{i});
    
    figure('Name',['Histogram Equalization - Image ', num2str(i)]);
    subplot(2,2,1); imshow(imgs{i}); title('Original');
    subplot(2,2,2); imshow(RGB_hist_eq); title('RGB eq');
    subplot(2,2,3); imshow(hsv_eq{i}); title('HSV eq');
    subplot(2,2,4); imshow(RGB_HSV_eq); title('Back to RGB');
end
waitforbuttonpress;

% --- Wavelet Fusion of HSV Images ---
wave = 'db6';
level = 2;

fused12 = wfusimg(hsv_eq{1}, hsv_eq{2}, wave, level, 'max', 'max');
figure; imshow(fused12); title('Fused Image 1 + 2');

fused123 = wfusimg(hsv_eq{3}, fused12, wave, level, 'max', 'max');
figure; imshow(fused123); title('Fused Image 1 + 2 + 3');

fused1234 = wfusimg(hsv_eq{4}, fused123, wave, level, 'max', 'max');
figure; imshow(fused1234); title('Fused Image 1 + 2 + 3 + 4');
waitforbuttonpress;

% --- Convert Final Fused HSV to RGB ---
rgb_fused = hsv2rgb(fused1234);
figure; imshow(rgb_fused); title('Final Fused Image (RGB)');

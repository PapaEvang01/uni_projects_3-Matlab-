clc; clear; close all;

% --- Load and Resize Images ---
imgNames = {'tree1.png', 'tree2.png', 'tree3.png', 'tree4.png'};
imgs = cell(1,4);
for i = 1:4
    imgs{i} = imresize(imread(imgNames{i}), [235, 538]);
end

% --- Display Original Images ---
figure('Name', 'Original Images');
for i = 1:4
    subplot(2,2,i); imshow(imgs{i}); title(['Image ', num2str(i)]);
end
waitforbuttonpress;

% --- Convert to YCbCr and Histogram Equalize Luma Channel ---
ycbcr_eq = cell(1,4);
for i = 1:4
    ycbcr = rgb2ycbcr(imgs{i});
    y_eq = histeq(ycbcr(:,:,1));
    ycbcr_eq{i} = cat(3, y_eq, ycbcr(:,:,2), ycbcr(:,:,3));

    % Optional visualization
    rgb_eq = ycbcr2rgb(ycbcr_eq{i});
    figure('Name', ['Equalized Image ', num2str(i)]);
    subplot(1,2,1); imshow(imgs{i}); title('Original');
    subplot(1,2,2); imshow(rgb_eq); title('Equalized RGB');
end
waitforbuttonpress;

% --- Wavelet Fusion using wfusimg ---
wavetype = 'db6';
level = 2;

% Step 1: Fuse Image 1 & 2
fused12 = wfusimg(ycbcr_eq{1}, ycbcr_eq{2}, wavetype, level, 'max', 'max');
figure; imshow(uint8(fused12)); title('Fused 1 + 2');

% Step 2: Fuse above result with Image 3
fused123 = wfusimg(ycbcr_eq{3}, fused12, wavetype, level, 'max', 'max');
figure; imshow(uint8(fused123)); title('Fused 1 + 2 + 3');

% Step 3: Fuse above result with Image 4
fused1234 = wfusimg(ycbcr_eq{4}, fused123, wavetype, level, 'max', 'max');
figure; imshow(uint8(fused1234)); title('Fused 1 + 2 + 3 + 4');

waitforbuttonpress;

% --- Convert Final Fused Image to RGB ---
rgb_final = ycbcr2rgb(fused1234);
figure; imshow(rgb_final); title('Final Fused Image (RGB)');

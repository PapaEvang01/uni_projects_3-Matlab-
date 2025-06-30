% ========================================================
% Compare Binary Image Results: Custom Otsu vs Built-in
%
% This script performs a side-by-side comparison between
% two methods of image binarization using Otsu's threshold:
%   1. A custom implementation (from scratch)
%   2. MATLAB's built-in graythresh() + imbinarize()
%
% It includes:
%   - Visual comparison of binary images
%   - Quantitative evaluation using MSE and SSIM
%   - Histogram analysis with threshold overlays
%
% Images compared:
%   - Leaf.jpeg
%   - Tower.jpeg
%
% ========================================================
clc; clear; close all;

% Load original images and convert to grayscale
img1 = imread('Leaf.jpeg');
img2 = imread('tower.jpeg');

gray1 = rgb2gray(img1);
gray2 = rgb2gray(img2);

% Load precomputed Otsu results
custom_leaf = imread('Leaf_Otsu.png');
builtin_leaf = imread('Leaf_Otsu_builtin.png');

custom_tower = imread('Tower_Otsu.png');
builtin_tower = imread('Tower_Otsu_builtin.png');

% 1. VISUAL COMPARISON
figure('Name', 'Leaf - Otsu Comparison');
subplot(1, 2, 1); imshow(custom_leaf); title('Custom Otsu');
subplot(1, 2, 2); imshow(builtin_leaf); title('Built-in Otsu');

figure('Name', 'Tower - Otsu Comparison');
subplot(1, 2, 1); imshow(custom_tower); title('Custom Otsu');
subplot(1, 2, 2); imshow(builtin_tower); title('Built-in Otsu');

% 2. QUANTITATIVE COMPARISON
% Convert logical to uint8 before MSE and SSIM
custom_leaf = uint8(imread('Leaf_Otsu.png'));
builtin_leaf = uint8(imread('Leaf_Otsu_builtin.png'));

custom_tower = uint8(imread('Tower_Otsu.png'));
builtin_tower = uint8(imread('Tower_Otsu_builtin.png'));

% MSE
mse_leaf = immse(custom_leaf, builtin_leaf);
mse_tower = immse(custom_tower, builtin_tower);

% SSIM
ssim_leaf = ssim(custom_leaf, builtin_leaf);
ssim_tower = ssim(custom_tower, builtin_tower);

fprintf('\n--- Quantitative Comparison ---\n');
fprintf('Leaf  - MSE: %.4f | SSIM: %.4f\n', mse_leaf, ssim_leaf);
fprintf('Tower - MSE: %.4f | SSIM: %.4f\n', mse_tower, ssim_tower);

% 3. HISTOGRAM THRESHOLD COMPARISON
% Compute custom Otsu thresholds
custom_thresh1 = compute_custom_threshold(gray1);
custom_thresh2 = compute_custom_threshold(gray2);

% Compute built-in Otsu thresholds
builtin_thresh1 = graythresh(gray1) * 255;
builtin_thresh2 = graythresh(gray2) * 255;

% Plot histograms with both thresholds (Leaf)
figure('Name', 'Histogram - Leaf Image');
imhist(gray1);
hold on;
xline(custom_thresh1, 'r', 'LineWidth', 2, 'DisplayName', 'Custom');
xline(builtin_thresh1, 'g--', 'LineWidth', 2, 'DisplayName', 'Built-in');
legend(); title('Histogram & Thresholds - Leaf');
hold off;

% Plot histograms with both thresholds (Tower)
figure('Name', 'Histogram - Tower Image');
imhist(gray2);
hold on;
xline(custom_thresh2, 'r', 'LineWidth', 2, 'DisplayName', 'Custom');
xline(builtin_thresh2, 'g--', 'LineWidth', 2, 'DisplayName', 'Built-in');
legend(); title('Histogram & Thresholds - Tower');
hold off;

% --- Helper function: return only threshold ---
function best_thresh = compute_custom_threshold(gray)
    gray = double(gray);
    counts = imhist(uint8(gray));
    total = sum(counts);
    p = counts / total;

    max_sigma = 0;
    best_thresh = 0;

    for t = 1:255
        w0 = sum(p(1:t));
        w1 = sum(p(t+1:end));
        if w0 == 0 || w1 == 0, continue; end

        mu0 = sum((0:t-1)'.*p(1:t)) / w0;
        mu1 = sum((t:255)'.*p(t+1:end)) / w1;
        sigma_b = w0 * w1 * (mu0 - mu1)^2;

        if sigma_b > max_sigma
            max_sigma = sigma_b;
            best_thresh = t;
        end
    end
end

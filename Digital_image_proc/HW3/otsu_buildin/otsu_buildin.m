% =========================================================================
% Otsu Thresholding Using MATLAB Built-In Functions
%
% Description:
% This script uses MATLAB’s built-in graythresh() and imbinarize() to apply
% Otsu’s method for automatic image binarization on two RGB images.
%
% Steps:
% 1. Load two RGB images: 'Leaf.jpeg' and 'tower.jpeg'.
% 2. Convert them to grayscale.
% 3. Use graythresh() to find the optimal threshold using Otsu’s method.
% 4. Apply the threshold with imbinarize().
% 5. Display and save binary results as:
%    - 'Leaf_Otsu_builtin.png'
%    - 'Tower_Otsu_builtin.png'
%
% Course: Digital Image Processing
% =========================================================================

clc; close all; clear;

% Load images
img1 = imread('Leaf.jpeg');
img2 = imread('tower.jpeg');

% Convert to grayscale
gray1 = rgb2gray(img1);
gray2 = rgb2gray(img2);

% Apply Otsu's method using built-in functions
thresh1 = graythresh(gray1);           % Normalized threshold [0,1]
binary1 = imbinarize(gray1, thresh1);  % Apply threshold

thresh2 = graythresh(gray2);
binary2 = imbinarize(gray2, thresh2);

% Display and save results for Leaf
figure('Name', 'Leaf Image - Built-in Otsu');
subplot(1, 3, 1); imshow(img1); title('Original RGB');
subplot(1, 3, 2); imshow(gray1); title('Grayscale');
subplot(1, 3, 3); imshow(binary1); title('Binary (graythresh)');
imwrite(binary1, 'Leaf_Otsu_builtin.png');

% Display and save results for Tower
figure('Name', 'Tower Image - Built-in Otsu');
subplot(1, 3, 1); imshow(img2); title('Original RGB');
subplot(1, 3, 2); imshow(gray2); title('Grayscale');
subplot(1, 3, 3); imshow(binary2); title('Binary (graythresh)');
imwrite(binary2, 'Tower_Otsu_builtin.png');

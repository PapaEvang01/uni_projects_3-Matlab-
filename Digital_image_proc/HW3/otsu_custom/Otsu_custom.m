% =========================================================================
% Otsu's Thresholding – Custom Implementation & Binarization
% -------------------------------------------------------------------------
% This MATLAB script applies Otsu’s thresholding method *from scratch*
% to two grayscale images (converted from RGB):
%
%   - Leaf.jpeg
%   - tower.jpeg
%
% Steps:
%   1. Convert input images to grayscale.
%   2. Compute the optimal threshold using custom Otsu implementation.
%   3. Binarize the image using the computed threshold.
%   4. Display original, grayscale, and binary images.
%   5. Save the binary output as PNG files.
%
% Output:
%   - 'Leaf_Otsu.png' and 'Tower_Otsu.png' are saved in the working directory.
%
% This is part of a Digital Image Processing homework assignment (HW3).
% =========================================================================

clc; close all; clear;

% Load images
img1 = imread('Leaf.jpeg');
img2 = imread('tower.jpeg');

% Convert to grayscale
gray1 = rgb2gray(img1);
gray2 = rgb2gray(img2);

% Apply custom Otsu thresholding
binary1 = custom_otsu(gray1);
binary2 = custom_otsu(gray2);

% Display and save results for Leaf
figure('Name', 'Leaf Image - Custom Otsu');
subplot(1, 3, 1); imshow(img1); title('Original RGB');
subplot(1, 3, 2); imshow(gray1); title('Grayscale');
subplot(1, 3, 3); imshow(binary1); title('Binary (Custom Otsu)');
imwrite(binary1, 'Leaf_Otsu.png');

% Display and save results for Tower
figure('Name', 'Tower Image - Custom Otsu');
subplot(1, 3, 1); imshow(img2); title('Original RGB');
subplot(1, 3, 2); imshow(gray2); title('Grayscale');
subplot(1, 3, 3); imshow(binary2); title('Binary (Custom Otsu)');
imwrite(binary2, 'Tower_Otsu.png');

% --- Custom Otsu Function ---
function binary = custom_otsu(gray)
    % Convert to double
    gray = double(gray);

    % Histogram
    counts = imhist(uint8(gray));
    total = sum(counts);
    p = counts / total;

    max_sigma = 0;
    best_thresh = 0;

    for t = 1:255
        w0 = sum(p(1:t));
        w1 = sum(p(t+1:end));
        if w0 == 0 || w1 == 0
            continue;
        end
        mu0 = sum((0:t-1)'.*p(1:t)) / w0;
        mu1 = sum((t:255)'.*p(t+1:end)) / w1;
        sigma_b = w0 * w1 * (mu0 - mu1)^2;

        if sigma_b > max_sigma
            max_sigma = sigma_b;
            best_thresh = t;
        end
    end

    % Thresholding
    binary = gray > best_thresh;
end

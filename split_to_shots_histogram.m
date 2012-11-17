clc; % Clear the command window.
close all; % Close all figures (except those of imtool.)
imtool close all; % Close all imtool figures.
clear; % Erase all existing variables.
workspace; % Make sure the workspace panel is showing.
fontSize = 20;

% Read in standard MATLAB color demo image.
rgbImage = imread('peppers.png');
[rows columns numberOfColorBands] = size(rgbImage);
subplot(2, 2, 1);
imshow(rgbImage, []);
title('Original Color Image', 'Fontsize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

redPlane = rgbImage(:, :, 1);
greenPlane = rgbImage(:, :, 2);
bluePlane = rgbImage(:, :, 3);

% Let's get its histograms.
[pixelCountR grayLevelsR] = imhist(redPlane);
subplot(2, 2, 2);
bar(pixelCountR, 'r');
title('Histogram of red plane', 'Fontsize', fontSize);
xlim([0 grayLevelsR(end)]); % Scale x axis manually.

[pixelCountG grayLevelsG] = imhist(greenPlane);
subplot(2, 2, 3);
bar(pixelCountG, 'g');
title('Histogram of green plane', 'Fontsize', fontSize);
xlim([0 grayLevelsG(end)]); % Scale x axis manually.

[pixelCountB grayLevelsB] = imhist(bluePlane);
subplot(2, 2, 4);
bar(pixelCountB, 'b');
title('Histogram of blue plane', 'Fontsize', fontSize);
xlim([0 grayLevelsB(end)]); % Scale x axis manually.
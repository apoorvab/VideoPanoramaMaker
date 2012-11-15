function [WidthOrigin, HeightOrigin]=find_translation(image1, image2)
% ===============================================================================
% PURPOSE:          Find the 2D translation between two images
% CREATED:          Jay Patel
%
% image1:           Height x Width x RGB
% image2:           Height x Width x RGB
% =============================================================================== 


% Note that in this code, X axis is along the height of the image
% and Y axis is along the width of the image.
disp(sprintf('SIFT image:'))
[img1, desc1, loc1] = sift(image1);
disp(sprintf('SIFT image:'))
[img2, desc2, loc2] = sift(image2);

%match is N x 5 array where each row contains
% [im1X im1Y im2X im2Y dist]
match=sift_matcher(desc1, loc1, desc2, loc2);
X1 = [match(:,1:2) ones(size(match,1),1)];
X2 = [match(:,3:4) ones(size(match,1),1)];




% Perform RANSAC
disp(sprintf('Performing RANSAC..'))
NUM_ITERATIONS = 100;
DIST_THRESHOLD = 0.6;
INLIER_THRESHOLD = 0;
[H_Best] = myRANSAC(X1, X2, NUM_ITERATIONS, DIST_THRESHOLD, INLIER_THRESHOLD);

% Find translation
disp(sprintf('Found Translation!'))
WidthOrigin = -(H_Best(2,3));
HeightOrigin = -(H_Best(1,3));


end
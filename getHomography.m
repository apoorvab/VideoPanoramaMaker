function [H H_err] = getHomography(im1, im2)

    % Constants:
    NUM_ITERATIONS = 100;
    DIST_THRESHOLD = 0.6;
    INLIER_THRESHOLD = 0;

    % Obtain Feature Points:
    [dummy desc1 loc1] = sift(im1);
    [dummy desc2 loc2] = sift(im2);
    dummy = [];

    % Match Feature Points:
    match = sift_matcher(desc1, loc1, desc2, loc2);
    
    % Extract Points & Normalize:
    x_1 = [match(:,1:2) ones(size(match,1),1)];
    x_2 = [match(:,3:4) ones(size(match,1),1)];
    
    % Perform RANSAC:
    [H H_err] = RANSAC(x_1, x_2, NUM_ITERATIONS, DIST_THRESHOLD, INLIER_THRESHOLD);
    
end
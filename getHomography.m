function [H H_err] = getHomography(im1, im2)

    % Constants:
    NUM_ITERATIONS = 100;
    DIST_THRESHOLD = 0.6;
    INLIER_THRESHOLD = 0;
    
    % Match Feature Points:
    [x_1 x_2] = matchPoints(im1, im2);
    
    % Perform RANSAC:
    [H H_err] = RANSAC(x_1, x_2, NUM_ITERATIONS, DIST_THRESHOLD, INLIER_THRESHOLD);
    
end
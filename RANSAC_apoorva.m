function [H error] = RANSAC_apoorva(x1, x2, min_pts, distance_thresh)
%RANSAC 

    % Calculate Number of Iterations:
    num_iter = log(1-prob)/log(1-want^min_pts);

    % Initialize Holding Variables:
    best_inliers = [];
    best_error = inf;
   
    % Iterate Models:
    for iter = 0:num_iter
        
        % Select Sample Inliers:
        sample_pts_idx = round(rand(min_pts, 1)*(length(x1) - 1) + 1);
        
        % Check Validity:
        sample_combinations = combnk(sample_pts_idx, 3);
        degen = 0;        
        for i = 1:length(sample_combinations)
            points_idx = sample_combinations(i, :)';
            points_mtx = x1(points_idx, :);
            degen = degen + (rank(points_mtx) ~= 3);
        end
        
        if (degen > 0)
            to_disp = ['Iteration ' num2str(iter) ' is degenerate.'];
            disp(to_disp)
            continue;
        end
        
        % Approximate Homography:
        sample_H = diag(3);
        sample_H(1, 3) = mean(x2(sample_pts_idx, 1) - x1(sample_pts_idx, 1));
        sample_H(2, 3) = mean(x2(sample_pts_idx, 2) - x1(sample_pts_idx, 2));
        
        % Create Vector of Other Idxs:
        all_idx = 1:length(x1);
        all_idx(sample_pts_idx) = [];
        
        % Obtain Inliers:
        selected_x1 = x1(all_idx, :);
        sample_x1 = (sample_H*x2(all_idx, :)')';
        sample_x1 = sample_x1./[sample_x1(:, 3) sample_x1(:, 3) sample_x1(:, 3)];
        sample_norm = sqrt(sum((selected_x1-sample_x1)'.^2))';
        sample_select = (sample_norm < distance_thresh);
        
        % Calculate Error:
        inlier_selected = selected_x1(sample_select, :);
        inlier_sample = sample_x1(sample_select, :);
        sample_error = sqrt(sum((inlier_selected-inlier_sample)').^2);
        sample_error = sum(sample_error)/length(sample_error);
        
        % Update If Better:
        if (length(inlier_sample) >= length(best_inliers) && best_error > sample_error)
            best_error = sample_error;
            best_inliers = [sample_pts_idx; all_idx(sample_select)'];
        end

        % Display Data:
        % to_disp = ['Iteration ' num2str(iter) ': ' num2str(length(x1) ...
        %     - length(inlier_sample) + min_pts) ' Outliers ' ...
        %     num2str(sample_error) ' Error'];
        %
        % disp(to_disp)
        
    end
        
    % Calculate Final Homography:
    H = Homography(x1(best_inliers, :), x2(best_inliers, :));
    error = best_error;
end


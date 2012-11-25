function [H_err blurr block] = obtainQualityMeasures(frames)

    num_frames = size(frames, 4);

    % Obtain H_err:
    H_err = zeros(1, num_frames-1);
    
    for i = 1:num_frames-1
        
        [~ H_err(i)] = getHomography(frames(:, :, :, i), frames(:, :, :, i+1));

    end
    
    % Pre-allocate:
    blurr = zeros(1, num_frames);
    block = zeros(1, num_frames);
    
    for i = 1:num_frames
        
        % Convert to Grayscale:
        grayscale_frame = rgb2gray(frames(:, : , :, i));
        
        % Obtain blurriness:
        blurr(i) = calcBlurriness(grayscale_frame);

        % Obtain blockness:
        block(i) = calcBlockness(grayscale_frame);
        
    end

end
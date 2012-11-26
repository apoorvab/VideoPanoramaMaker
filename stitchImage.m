function [stitched_img] = stitchImage(translations, frames, blurr, block)

    FRAME_SIZE_X = size(frames, 2);
    FRAME_SIZE_Y = size(frames, 1);
    NUM_FRAMES = size(frames, 4);
    GAMMA = 0.45;
    SIGMASQ = (0.5).^2;

    % Compute Panorama Size:
    panorama_size_x = sum(translations(:, 1)) + FRAME_SIZE_X;
    panorama_size_y = sum(translations(:, 2)) + FRAME_SIZE_Y;

    % Get Matrix of aligned images
    [Layered_FinalImg_Luma, rgb_final, mask_final, p_offset] = create_layered_images(frames, translations);    
    
    % Calculate Distance Matrix:
    row_weight = [1:ceil(FRAME_SIZE_X/2) floor(FRAME_SIZE_X/2):-1:1];
    distance_weights = ones(FRAME_SIZE_Y, 1) * row_weight;
    origin_x = p_offset(1);
    origin_y = p_offset(2);
    
    % Compute w Matrix;
    w = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);
    
    for i = 1:NUM_FRAMES
       w(origin_y:origin_y+FRAME_SIZE_y, origin_x:origin_x+FRAME_SIZE_X, i) = distance_weights;
       origin_x = origin_x + translations(i, 1);
       origin_y = origin_y + translations(i, 2);
    end
    
    % Compute w' Matrix:
    r_med = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);
    g_med = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);
    b_med = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);
    
    % Calculate Median:
    for x = 1:panorama_size_x
        for y = 1:panorama_size_y
            % Grab Core Sample:
            core_r = squeeze(rgb_final(y, x, 1, :));
            core_g = squeeze(rgb_final(y, x, 2, :));
            core_b = squeeze(rgb_final(y, x, 3, :));
            
            % Calculate Median:
            r_med(y, x) = median(core_r(squeeze(mask_final(y, x, :))));
            g_med(y, x) = median(core_g(squeeze(mask_final(y, x, :))));
            b_med(y, x) = median(core_b(squeeze(mask_final(y, x, :))));
        end
    end
    
    w_prime_r = w.*exp(-((squeeze(rgb_final(:, :, 1, :)) - r_med).^2)/SIGMASQ);
    w_prime_g = w.*exp(-((squeeze(rgb_final(:, :, 2, :)) - g_med).^2)/SIGMASQ);
    w_prime_b = w.*exp(-((squeeze(rgb_final(:, :, 3, :)) - b_med).^2)/SIGMASQ);

    clear r_med; clear g_med; clear b_med;
    
    % Calculate w'' Matrix:
    w_prime_prime_r = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);
    w_prime_prime_g = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);
    w_prime_prime_b = zeros(panorama_size_y, panorama_size_x, NUM_FRAMES);

    % Calculate Visual Quality per Frame:
    vqm_per_frame = exp(-(GAMMA*block + (1-GAMMA)*blurr));
    
    for i = 1:NUM_FRAMES
        w_prime_prime_r(:, :, i) = w_prime_r(:, :, i) * vqm_per_frame(i);
        w_prime_prime_g(:, :, i) = w_prime_g(:, :, i) * vqm_per_frame(i);
        w_prime_prime_b(:, :, i) = w_prime_b(:, :, i) * vqm_per_frame(i);
    end    
    
    clear w_prime_r; clear w_prime_g; clear w_prime_b;
    
    % Calculate Final RGB Values:
    r_final = sum((w_prime_prime_r .* squeeze(rgb_final(:, :, 1, :))), 3)/sum(w_prime_prime_r, 3);
    g_final = sum((w_prime_prime_g .* squeeze(rgb_final(:, :, 1, :))), 3)/sum(w_prime_prime_g, 3);
    b_final = sum((w_prime_prime_b .* squeeze(rgb_final(:, :, 1, :))), 3)/sum(w_prime_prime_b, 3);
    
    % Stitch Image Together:
    stitched_img = zeros(panorama_size_y, panorama_size_x, 3);
    stitched_img(:, :, 1) = r_final;
    stitched_img(:, :, 2) = g_final;
    stitched_img(:, :, 3) = b_final;
    
end
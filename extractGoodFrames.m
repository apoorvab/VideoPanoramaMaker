function [panorama_idx_range, Ev] = extractGoodFrames(images, H_err, blurr, block, translations)

    % Constants:
    DELTA = 300;
    GAMMA = 0.45;
    ALPHA_v = 1;
    ALPHA_m = 1;
    TOTAL_FRAMES = length(block);
    FRAME_SIZE = [size(images,2) size(images,1)];
    BETA = 2;
    

    
    
    Evv_vec = (GAMMA .* block) + ((1 - GAMMA) .* blurr);
    Evm_vec = H_err;
    
    Ev_calc_array = [ ALPHA_v.*Evv_vec(1:end-1)   ALPHA_m.*Evm_vec   ALPHA_v.*Evv_vec(2:end) ];
    size(Ev_calc_array)
    
    
    
    panorama_idx_range = [];  
    frame_numbers = [];    
    for i=2:TOTAL_FRAMES-1
        frame_numbers = [frame_numbers i];
    end
    
    attempts = 0;
    while ((length(frame_numbers) > 5) & attempts < 10)
        attempts = attempts + 1;

        % Make sure this value is greater than 1 and less than (TOTAL_FRAMES - 1)
        ReferenceFrame = randsample(frame_numbers,1);
        disp(sprintf('Try Reference Frame: %d',ReferenceFrame))

        % Calculate Ev for (ReferenceFrame) and (ReferenceFrame + 1)
        Ev = sum(Ev_calc_array(ReferenceFrame,:));
        left = ReferenceFrame - 1;
        right = ReferenceFrame + 1;

        while (Ev < DELTA)

            % Make sure exceeded limits are excluded
            if (left == 0)
                Ev_left_marginal = NaN;
            else
                Ev_left_marginal = sum(Ev_calc_array(left,1:2));
            end
            if (right == TOTAL_FRAMES)
                Ev_right_marginal = NaN;
            else
                Ev_right_marginal = sum(Ev_calc_array(right,2:3));
            end

            % Find min Error between left and right
            [Val, Idx] = nanmin([Ev_left_marginal Ev_right_marginal]);

            if (isnan(Val))
                break;
            end

            % Update Ev
            if(Idx == 1)
                Ev = Ev + Ev_left_marginal;
                left = left - 1;
            else
                Ev = Ev + Ev_right_marginal;
                right = right + 1;
            end

            % Check whether left and right limits are exceeded
            if(left < 1)
                left = 0;
            end
            if(right > TOTAL_FRAMES)
                right = TOTAL_FRAMES;
            end

        end

        % Update candidate panoramas
        cand_panorama_idx_range = [(left+1) (right-1)];

        translations = [0 0;translations];
        cand_translations = translations((cand_panorama_idx_range(1)):(cand_panorama_idx_range(2)) , : );
        cand_translations(1,:) = [0 0];

        % Find area of the candidate panorama
        [Area] = getPanoramaArea(cand_translations, FRAME_SIZE);

        % Check if Area is sufficient
        if( Area > (BETA*FRAME_SIZE(1)*FRAME_SIZE(2)) )
            % Update panoramas
            panorama_idx_range = [panorama_idx_range; cand_panorama_idx_range]; 

            % Update avalible frames
            left_indices = find(frame_numbers < (left+1));
            right_indices = find(frame_numbers > (right-1));
            temp = frame_numbers([left_indices right_indices]);
            frame_numbers = [];
            frame_numbers = temp;
            temp = [];    
            
            % Display information            
            disp(sprintf('Panorama Found, Frame Range: %d - %d',cand_panorama_idx_range(1),cand_panorama_idx_range(2)))
            disp(sprintf('Ev: %f',Ev))
            disp(sprintf('Area: %f',Area))            
        end
    
    
    end
    


end
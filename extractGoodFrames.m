function [frame_idx] = extractGoodFrames(range, H_err, blurr, block)

    % Constants:
    delta_thresh = 100;

    % All Indices
    idx = [range(1):range(2)];
    
    left = idx(length(idx)/2);
    right = idx(length(idx)/2);
    
    while (left > 1 && right < length(idx))
        
        % Grab Candidates
        
        % Calculate E_v:
        E_v_1 = calcVisualQuality(H_err(left - 1:right), blurr(left - 1:right), block(left - 1: right));
        E_v_2 = calcVisualQuality(H_err(left:min(right + 1, length(H_err))), blurr(left:right + 1), block(left: right + 1));
        
        % Reject Candidate:
        if E_v_1 > delta_thresh && E_v_2 > delta_thresh
            frame_idx = left:right;
            break;
        else
            if E_v_1 < E_v_2
                left = left - 1;
            else
                right = right + 1;
            end
        end
    end

end
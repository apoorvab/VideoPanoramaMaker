function [translations] = findTranslations(frames)

    NUM_FRAMES = size(frames, 4);
    
    translations = zeros(NUM_FRAMES-1, 2);

    % Each Frame:
    for i = 1:NUM_FRAMES - 1
       
        % Obtain Homography:
        [H ~] = getHomography(frames(:, :, :, i), frames(:, :, :, i+1));
        
        % Store Translations:
        translations(i, :) = [-H(2,3) -H(1,3)];
        
    end

end
%
% One Shot Demos:
%
clc
clear



% DELICATE ARCHES NATIONAL PARK
if(0)
    % Merge Overlap: 50%
    load oneShotDemos\DelicateArches\DelicateArches.mat
    DELTA = 100;
    BETA = 2.5;
end

% WEST LAKE HONGZHOU
if(0)
    % Merge Overlap: 50%
    load oneShotDemos\WestLakeHangzhou\WestLake.mat
    DELTA = 175;    
    BETA = 3;
end

% VANCOUVER BEACH
if(1)
    % Merge Overlap: 50%
    load oneShotDemos\VancouverBeach\VancouverBeach.mat
    DELTA = 250;    
    BETA = 2.2;
end


% Extract Frames:
FRAME_SIZE = [size(images,2) size(images,1)];
[good_frames_idx] = extractGoodFrames((H_err'), blurr', block', translations, FRAME_SIZE, DELTA, BETA)

% Stich Panoramas:
for num_pans=1:size(good_frames_idx,1)

    % Composite and Blend Images
    [panorama_img] = stitchImage(translations(good_frames_idx(num_pans,1)+1:good_frames_idx(num_pans,2),:), images(:,:,:,good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)), ... 
        blurr(good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)), block(good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)));

    % Show Panorama
    figure(num_pans)
    imshow(uint8(panorama_img))


end





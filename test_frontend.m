clc


MAX_NUM_IMAGES = 400;
TEST_DIR = 'Frontend_Test_Case1';

cd(TEST_DIR);
for i=1:MAX_NUM_IMAGES
    file = sprintf('%d.jpg', i);
    if exist(file)
        im = imread(file);
        images(:,:,:,i) = im;  
    else
        break;
    end
end
cd ..


shot_range = [1 size(images,4)]

% Obtain Quality Measures:
shot_frames = images;
[H_all, H_err, blurr, block, translations] = obtainQualityMeasures(shot_frames);



% Extract Frames:
[good_frames_idx Ev] = extractGoodFrames(images, H_err', blurr', block', translations)




for num_pans=1:size(good_frames_idx,1)

% Composite and Blend Images
[panorama_img] = stitchImage(translations(good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)-1,:), images(:,:,:,good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)), ... 
    blurr(good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)), block(good_frames_idx(num_pans,1):good_frames_idx(num_pans,2)));

figure(num_pans)
imshow(uint8(panorama_img))


end
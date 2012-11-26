clc
clear




MAX_NUM_IMAGES = 100;
TEST_DIR = 'Backend_Test_Case2';

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

% Obtain Quality Measures
[H_err, blurr, block] = obtainQualityMeasures(images);

%{
% Find Translations
translations = findTranslations(images)

% Composite and Blend Images
panorama_img = stitchImage(translations, images, blurr, block)

imshow(panorama_img)

%}


function [finalImg, Translations] = create_panorama(dir)


images = load_images(dir);
    
NUM_IMAGES = size(images, 4);

% ============================================================================
% SIFT, RANSAC and extract translations

for i=1:NUM_IMAGES-1
    disp(sprintf('=========================================='))    
    disp(sprintf('Loading Images %d and %d', i, i+1))
    im1 = images(:,:,:,i);
    im2 = images(:,:,:,i+1);
    
    disp(sprintf('Finding Homography of Images %d and %d \n', i, i+1))
    [W, H] = find_translation(im1, im2);
    Translations(i,1) = floor(W);
    Translations(i,2) = floor(H);    
end


disp(sprintf('=========================================='))
Translations

% ============================================================================
% Align, blend and stich

if(1) % Original Demo Code!
    oldW = 0;
    oldH = 0;

    for i=1:NUM_IMAGES-1

        im1 = images(:,:,:,i);
        im2 = images(:,:,:,i+1);    

        Tx = floor(Translations(i, 1));
        Ty = floor(Translations(i, 2));

        if (i == 1)
            finalImg = stich(im1, im2, Tx, Ty);
        else
            finalImg = stich(finalImg, im2, oldW + Tx, oldH + Ty);
        end

        oldW = oldW  + Tx;
        oldH = oldH + Ty;

    end
end

if(0) % Our Code!
    
    [ finalImg ] = composite_and_blend( images, Translations );
    
end


disp('Done!');


end
function [ FinalImg ] = composite_and_blend( images, Translations )
% ===============================================================================
% PURPOSE:          To composite and blend a set of images given the alignments
% CREATED:          
%
% images:           Height x Width x RGB x NUM_IMAGES
% Translations:     EachTranslation x (x,y)
% ===============================================================================


im_size_x = size(images, 2);
im_size_y = size(images, 1);
NUM_IMAGES = size(images, 4);

FinalImg_size_x = sum(Translations(:,1))+im_size_x;
FinalImg_size_y = sum(Translations(:,2))+im_size_y;




% USING STRUCTS =======================================================================================
    panorama(FinalImg_size_y, FinalImg_size_x) = struct('list', []);

    function updatePanorama(frame_id, size_x, size_y, rel_x, rel_y)
    % UPDATEPANORAMA
    % This function takes the frame_id, the size of the frame, and the
    % distance of the frame origin relative to the global origin of the
    % panorama. It then updates a globally defined matrix of structs, panorama,
    % with added data regarding each pixel in the frame that is being added.

    panorama(rel_y+size_y, rel_x+size_x) = struct('list', []);
        
        for x = rel_x+1:rel_x+size_x
            for y = rel_y+1:rel_y+size_y

                panorama(y, x).list = [panorama(y, x).list; [frame_id y-rel_y x-rel_x]];

            end 
        end

    end
% USING STRUCTS =======================================================================================




% Get Matrix of aligned images
[ Layered_FinalImg_Luma, Layered_FinalImg_RGB, Layered_FinalImg_Mask ] = create_layered_images( images, Translations );





end


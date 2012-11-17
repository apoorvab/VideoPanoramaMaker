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
[ Layered_FinalImg_Luma, Layered_FinalImg_RGB, Layered_FinalImg_Mask, Panorama_Offset ] = create_layered_images( images, Translations );

% Create w Matrix:
row_weight = [1:ceil(im_size_x/2) floor(im_size_x/2):-1:1];
distance_weights = ones(im_size_y, 1) * row_weight;
cur_origin_x = Panorama_Offset(1);
cur_origin_y = Panorama_Offset(2);

w = zeros(FinalImg_size_x, FinalImg_size_y, NUM_IMAGES);

for img_num = 1:NUM_IMAGES
    w(cur_origin_x:cur_origin_x+im_size_x, cur_origin_y:cur_origin_y+im_size_y, img_num) = distance_weights;
    cur_origin_x = cur_origin_x + Translations(img_num, 1);
    cur_origin_y = cur_origin_y + Translations(img_num, 2);
end

% Create w' Matrix:
w_prime = zeros(size(w));
med_mat = zeros(FinalImg_size_x, FinalImg_size_y);

for i=1:FinalImg_size_x
    for j=1:FinalImg_size_y
        core_sample = Layered_FinalImg_Luma(Layered_FinalImg_Luma(i, j, :));
        med_mat(i, j) = median(core_sample(Layered_FinalImg_Mask(i, j, :)));
    end
end

sigmasq = 1.^2;

for img_num = 1:NUM_IMAGES
    to_exp = -(Layered_FinalImg_Luma(:, :, img_num) - med_mat).^2/sigma_sq;
    to_exp(~Layered_FinalImg_Mask(:, :, img_num)) = 0;
    w_prime(:, :, img_num) = w(:, :, img_num).*exp(to_exp);
end

% Create w'' Matrix:
w_prime_prime = zeros(size(w));
gamma = 0.45;
vq_measure = exp(-(gamma*q_bk + (1 - gamma)*q_br));

for img_num = 1:NUM_IMAGES
   w_prime_prime(:, :, img_num) = w_prime(:, :, img_num).*vq_measure(img_num); 
end

end


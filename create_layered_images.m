function [ Layered_FinalImg_Luma, Layered_FinalImg_RGB, Layered_FinalImg_Mask, Panorama_Offset] = create_layered_images( images, Translations )
% ===============================================================================
% PURPOSE:                  Creates a Matrix of the aligned images in layers
% CREATED:                  Jay Patel
%
% images:                   Height x Width x RGB x NUM_IMAGES
% Translations:             EachTranslation x (x,y)
% Layered_FinalImg_Luma:    Height x Width x NUM_IMAGES , Each element contains Luma
% Layered_FinalImg_RGB:     Height x Width x RGB x NUM_IMAGES
% Layered_FinalImg_Mask:    Height x Width x NUM_IMAGES , Each element contains:
%                                   1 - Valid Pixel     0 - Invalid Pixel
%
% NOTE:                     Invalid pixels have a value of 0 (black)
% ===============================================================================


im_size_x = size(images, 2);
im_size_y = size(images, 1);
NUM_IMAGES = size(images, 4);


% Find the origin offset of image1 with respect to the Final Panorama ========================================
Offset_im1_y = 0;
Total_Offset_y = 0;
Offset_im1_x = 0;
Total_Offset_x = 0;

for i=2:NUM_IMAGES
    % Offset in y direction
    Total_Offset_y = Translations(i-1,2)+Total_Offset_y;
    if( Total_Offset_y < Offset_im1_y)
        Offset_im1_y = Total_Offset_y;           
    end
    
    % Offset in x direction
    Total_Offset_x = Translations(i-1,1)+Total_Offset_x;
    if( Total_Offset_x < Offset_im1_x)
        Offset_im1_x = Total_Offset_x;           
    end      
end



% Create the layered images ===================================================================================
Origin_x = abs(Offset_im1_x);
Origin_y = abs(Offset_im1_y);
Panorama_Offset = [Origin_x Origin_y];

for i=1:NUM_IMAGES
    
    Luma = rgb2gray(images(:,:,:,i));
    
    if (i == 1)
        Layered_FinalImg_Luma(   abs(Offset_im1_y)+1:(abs(Offset_im1_y)+im_size_y),   abs(Offset_im1_x)+1:(abs(Offset_im1_x)+im_size_x),   i) = Luma;
        Layered_FinalImg_RGB(   abs(Offset_im1_y)+1:(abs(Offset_im1_y)+im_size_y),   abs(Offset_im1_x)+1:(abs(Offset_im1_x)+im_size_x),   :,   i) = images(:,:,:,i);
        Layered_FinalImg_Mask(   abs(Offset_im1_y)+1:(abs(Offset_im1_y)+im_size_y),   abs(Offset_im1_x)+1:(abs(Offset_im1_x)+im_size_x),   :,   i) = ones(im_size_y,im_size_x);
    else
        Origin_x = Translations(i-1,1) + Origin_x;
        Origin_y = Translations(i-1,2) + Origin_y;
        Layered_FinalImg_Luma(   Origin_y+1:(Origin_y+im_size_y),   Origin_x+1:(Origin_x+im_size_x),   i) = Luma;  
        Layered_FinalImg_RGB(   Origin_y+1:(Origin_y+im_size_y),   Origin_x+1:(Origin_x+im_size_x),   :,   i) = images(:,:,:,i);  
        Layered_FinalImg_Mask(   Origin_y+1:(Origin_y+im_size_y),   Origin_x+1:(Origin_x+im_size_x),   :,   i) = ones(im_size_y,im_size_x);
    end    
    
end

Layered_FinalImg_Mask = logical(Layered_FinalImg_Mask)

end


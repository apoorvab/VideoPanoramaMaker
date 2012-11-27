function [ Layered_FinalImg_Luma, Layered_FinalImg_RGB, Layered_FinalImg_Mask, im1_origin] = create_layered_images( images, Translations )
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
% NOTE:                     First Translation must be [0 0]
% ===============================================================================


NUM_IMAGES = size(images, 4);
FRAME_SIZE = [size(images, 2) size(images, 1)];


% Get Panorama Size and image 1 origin
[ im1_origin, panorama_size ] = getOriginAndDim( Translations, FRAME_SIZE );

% Running origin of images
Origin_x = im1_origin(1);
Origin_y = im1_origin(2);

% Initialize size of Matrices
Layered_FinalImg_Luma = NaN(panorama_size(2), panorama_size(1), NUM_IMAGES);
Layered_FinalImg_RGB = NaN(panorama_size(2), panorama_size(1), 3, NUM_IMAGES);
Layered_FinalImg_Mask = zeros(panorama_size(2), panorama_size(1), NUM_IMAGES);


for i=1:NUM_IMAGES
    
    Luma = rgb2gray(images(:,:,:,i));

	Origin_x = Translations(i,1) + Origin_x;
	Origin_y = Translations(i,2) + Origin_y;
	Layered_FinalImg_Luma(   Origin_y:(Origin_y+FRAME_SIZE(2)-1),   Origin_x:(Origin_x+FRAME_SIZE(1)-1),   i) = Luma;  
	Layered_FinalImg_RGB(   Origin_y:(Origin_y+FRAME_SIZE(2)-1),   Origin_x:(Origin_x+FRAME_SIZE(1)-1),   :,   i) = images(:,:,:,i);  
	Layered_FinalImg_Mask(   Origin_y:(Origin_y+FRAME_SIZE(2)-1),   Origin_x:(Origin_x+FRAME_SIZE(1)-1),   i) = ones(FRAME_SIZE(2),FRAME_SIZE(1));
     
end


Layered_FinalImg_Mask = logical(Layered_FinalImg_Mask);


end


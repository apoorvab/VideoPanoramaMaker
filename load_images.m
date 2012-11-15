function images = load_images(str)
% str:          string of the foldername containing images
% images:       all images
%                - height x width x rgb x num_images
% 
% TASKS: - remove MAX_NUM_IMAGES to make code robust
%


MAX_NUM_IMAGES = 100;

cd(str);

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


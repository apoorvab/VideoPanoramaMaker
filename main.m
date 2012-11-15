clc
clear


% Top Level



dir = 'images2';

[finalImg, Translations] = create_panorama(dir);

imshow(finalImg);





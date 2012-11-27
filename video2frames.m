function video2frames( )

% PARAMETERS =====================================================================
videoFile = 'H:\EECS442_Final\VideoPanoramaMaker\plane.mp4'; 
picFormat = 'JPG';
destfoldername = 'Frontend_Test_Case2'
mkdir(destfoldername)

frameLimit = 600; % This can be set a larger value with enough memory.

SAMPLE_FREQ = 5;



% ================================================================================


videoObject = VideoReader(videoFile);
numFrames = get(videoObject, 'numberOfFrames');
fileName = get(videoObject, 'Name');



indexFrame = [150 1];

indexFrame(1, 2) = min(numFrames, indexFrame(1, 1) + frameLimit)
frameAll = read(videoObject, indexFrame);
 

sample = 1;
for i = indexFrame(1, 1):SAMPLE_FREQ:indexFrame(1, 2)   
        
	imgFrame = frameAll(:,:,:,i);
               
	saveFormat = strcat('%s\\%d.%s');
	picName = sprintf(saveFormat,destfoldername,floor(sample),picFormat); 
        
	imwrite(imgFrame, picName);
	disp(picName); 
    
    sample = sample+1;

end   




end


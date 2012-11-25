function video2pic( videoFile, outputPath, picFormat )

%% Initialization
if nargin < 1
    videoFile = 'H:\Downloads\west_lake.avi'; %input('Input full video path:', 's');
    %outputPath = input('Input video output path[Default is under the video path]:', 's');
    
    %if isempty(outputPath)
    outputPath = videoFile(1, 1:find(videoFile=='\', 1, 'last')-1);
    %end
    
    %picFormat = input('Input output pic format[JPG by default]:');
    %if isempty(picFormat)
    picFormat = 'JPG';
    %end
end

%% Main part
videoObject = VideoReader(videoFile);
numFrames = get(videoObject, 'numberOfFrames');
fileName = get(videoObject, 'Name');

% bytesPerFrame = bitsPerPix*H*W/8;
outputPath = fullfile(outputPath, fileName(1, 1:find(fileName=='.', 1, 'last')-1));
numOrder = max(4, size(int2str(numFrames), 2));
mkdir(outputPath);

indexFrame = [1 1];
frameLimit = 100; % This can be set a larger value with enough memory.

first_frame = 0;
threshold = 10;

max_val = 0 ;
while indexFrame(1, 1) <= numFrames

    indexFrame(1, 2) = min(numFrames, indexFrame(1, 1) + frameLimit);
    frameAll = read(videoObject, indexFrame);
    
    for i = indexFrame(1, 1):1:indexFrame(1, 2)    %save frames to pic        
        imgFrame = frameAll(:,:,:,i - indexFrame(1, 1) + 1);
        
        N = size(imgFrame,1)*size(imgFrame, 2);
        B = 5;
        ul = 2^B - 1;
        
        redPlane = imgFrame(:, :, 1);
        greenPlane = imgFrame(:, :, 2);
        bluePlane = imgFrame(:, :, 3);
        [hist_R grayR] = imhist(redPlane);
        [hist_G grayG] = imhist(greenPlane);
        [hist_B grayB] = imhist(bluePlane);
        sum = 0;
        
        for r_index = 1:ul
            for g_index = 1:ul
                for b_index = 1:ul                    
                    if first_frame ~= 0                    
                      sum = sum + abs((hist_R(r_index)+hist_G(g_index)+hist_B(b_index)) -  (prev_hist_R(r_index)+prev_hist_G(g_index)+prev_hist_B(b_index)));                      
                    end                   
                end
            end
        end
        
        if first_frame ~= 0           
           CHD = 1/N * sum;  
           if CHD > max_val
               max_val = CHD;
           end
           if CHD > threshold           
               saveFormat = strcat('%s\\%s_%0', int2str(numOrder), 'd.%s');
               picName = sprintf(saveFormat, outputPath, fileName, i, picFormat);
               imwrite(imgFrame, picName);
               disp(picName); % This output can be turned off.            
           end
        end
              
        
        first_frame  = 1;
        prev_hist_R = hist_R;
        prev_hist_G = hist_G;
        prev_hist_B = hist_B;        
        
    end
    indexFrame(1, 1) = indexFrame(1, 2) + 1;
end
max_val
end


function scene_list = split_to_shots_edge(videoFile)


NumTimes = 1;   % Number of times the stream processing loop should run
videoFile = 'Z:\442\project\VideoPanoramaMaker\ndtv.avi';
outputPath = videoFile(1, 1:find(videoFile=='\', 1, 'last')-1);
fileName = videoFile(find(videoFile=='\', 1, 'last')+1 : end);
picFormat = 'JPG';
outputPath = fullfile(outputPath, fileName(1, 1:find(fileName=='.', 1, 'last')-1));
numOrder = 4;
mkdir(outputPath);

hmfr = vision.VideoFileReader( ...
    'Filename', videoFile , ...
    'PlayCount',  NumTimes);

% Get the dimensions of each frame.
Info = info(hmfr);
rows = Info.VideoSize(2);  % Height in pixels
cols = Info.VideoSize(1);  % Width in pixels
blk_size = 32;  % Block size

% Create ROI rectangle indices for each block in image.
blk_rows = (1:blk_size:rows-blk_size+1);
blk_cols = (1:blk_size:cols-blk_size+1);
[X, Y] = meshgrid(blk_rows, blk_cols);
block_roi = [X(:)'; Y(:)'];
block_roi(3:4, :) = blk_size;
block_roi = block_roi([2 1 4 3], :)';

hedge = vision.EdgeDetector( ...
    'EdgeThinning' ,true, ...
    'ThresholdScaleFactor', 3);

hmean = vision.Mean;
hmean.ROIProcessing = true;

htextinserter = vision.TextInserter( ...
    'Text', 'Frame %3d  Shot %d', ...
    'Location',  [15 100], ...
    'Color', [1 0 0], ...
    'FontSize', 14);


hVideo1 = vision.VideoPlayer;
hVideo1.Name  = 'Original Video';
% Video window position
hVideo1.Position(1) = round(0.4*hVideo1.Position(1));
hVideo1.Position(2) = round(1.5*(hVideo1.Position(2)));
hVideo1.Position([3 4]) = [400 200]; % video window size

hVideo2 = vision.VideoPlayer;
hVideo2.Name  = 'Sequence of start frames of the video shot.';
% Video window position
hVideo2.Position(1) = hVideo1.Position(1) + 410;
hVideo2.Position(2) = round(1.5* hVideo2.Position(2));
hVideo2.Position([3 4]) = [600 200];  % video window size

% Initialize variables.
mean_blks_prev = zeros([size(blk_rows,2)*size(blk_cols,2), 1], 'single');
scene_out      = zeros([rows, 3*cols, 3], 'single');
count          = 1;
frameCount     = 1;
shotCount      = 1;
threshold      = 0.08;
scene_list = [];
startFrame = 1;
frameRate = Info.VideoFrameRate
threshold_num_changed_blocks = 1;
prevFrame = 0;
startImg = 0;
while count <= NumTimes
    I = step(hmfr);              % Read input video
    
    % Calculate the edge-detected image for one video component.
    I_edge = step(hedge, I(:,:,3));
    
    % Compute mean of every block of the edge image.
    mean_blks = step(hmean, single(I_edge), block_roi);
    
    % Compare the absolute difference of means between two consecutive
    % frames against a threshold to detect a scene change.
    edge_diff = abs(mean_blks - mean_blks_prev);
    edge_diff_b = edge_diff > threshold;
    num_changed_blocks = sum(edge_diff_b(:));
    
    % It is a scene change if there is more than one changed block.
    scene_chg = num_changed_blocks > threshold_num_changed_blocks;
    
    % Display the sequence of identified scene changes along with the edges
    % information. Only the start frames of the scene changes are
    % displayed.
    I_out = cat(2, I, repmat(I_edge, [1,1,3]));
    
    % Display the number of frames and the number of scene changes detected
    
    I_out = step(htextinserter, I_out, int32([frameCount shotCount]));
    
    % Generate sequence of scene changes detected
    if scene_chg
        % Shift old shots to left and add new video shot
        %scene_out(:, 1:2*cols, :) = scene_out(:, cols+1:end, :);
        %scene_out(:, 2*cols+1:end, :) = I;
        %step(hVideo2, scene_out); % Display the sequence of scene changes
        
        if frameCount - startFrame > frameRate
            
            saveFormat = strcat('%s\\%s_%0', int2str(numOrder), 'd_start.%s');
            picName = sprintf(saveFormat, outputPath, fileName, shotCount , picFormat);
            imwrite(startImg, picName);
            
            saveFormat = strcat('%s\\%s_%0', int2str(numOrder), 'd_end.%s');
            picName = sprintf(saveFormat, outputPath, fileName , shotCount, picFormat);
            imwrite(prevFrame, picName);
            
            scene_list(shotCount, 1) = startFrame;
            scene_list(shotCount, 2) = frameCount - 1;
            shotCount = shotCount+1;
            
            startFrame = frameCount;             
            startImg = I;
        end      
        
    end
    
    if startImg == 0
        startImg = I;
    end
    
    prevFrame = I;
    
    %step(hVideo1, I_out);         % Display the Original Video.
    mean_blks_prev = mean_blks;      % Save block mean matrix
    
    if isDone(hmfr)
        count = count+1;
    end
    
    frameCount = frameCount + 1;
end
scene_list;
end

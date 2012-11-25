function [frames] = getVideo(filename, N)
% GETVIDEO
% filename: complete path to video file
% N: integer value to downsample video

    % Load Video:
    video_obj = VideoReader(filename);
    
    % Read Frames:
    video = read(video_obj);
    
    % Downsample By N:
    frames = video(:, :, :, 1:N:end);

end
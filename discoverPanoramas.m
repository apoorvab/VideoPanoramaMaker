function discoverPanoramas(filename, opt_flow_enabled, display_enabled)

    % Read Video:
    video_frames = getVideo(filename);
    
    % Extract List of Scenes:
    shot_list = extractScenes(video_frames);

    for shot_num = size(shot_list, 2)
       
        % Obtain Quality Measures:
        shot_range = shot_list(shot_num, :);
        shot_frames = video_frames(:, :, :, shot_range(1):shot_range(2));
        [H_err, blurr, block] = obtainQualityMeasures(shot_frames);
                
        % Extract Frames:
        good_frames_idx = extractGoodFrames(shot_range, H_err, blurr, block);
        
        % Align Frames to Image:
        img_translations = findTranslations(shot_frames(:, :, good_frames_idx));
        
        % Stich Image to Panorama:
        stitched_img = stitchImage(img_translations, shot_frames(:, :, :, good_frames_idx), ...
                                   blurr(good_frames_idx), block(good_frames_idx));
        
        % Apply Optical Flow:
        if (opt_flow_enabled)
           
           
        end
        
        % Save Panorama Image:
        imwrite(stitched_img, ['panorama_' num2str(shot_num) '_' filename]);
                   
        % Display Image:
        if (display_enabled)
            figure(shot_num)
            imshow(stitched_img)
            title(['Panorama #' num2str(shot_num) ' in ' filename]);
        end
        
    end
    
end
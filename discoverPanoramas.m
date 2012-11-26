function discoverPanoramas(filename, opt_flow_enabled, display_enabled)

    % Read Video:
    video_frames = getVideo(filename);
    
    % Extract List of Scenes:
    scene_list = extractScenes(video_frames);

    for scene_num = size(scene_list, 2)
       
        % Obtain Quality Measures:
        scene_range = scene_list(scene_num, :);
        scene_frames = video_frames(:, :, :, scene_range(1):scene_range(2));
        [H_err, blurr, block] = obtainQualityMeasures(scene_frames);
                
        % Extract Frames:
        good_frames_idx = extractGoodFrames(scene_range, H_err, blurr, block);
        
        % Align Frames to Image:
        img_translations = findTranslations(scene_frames(:, :, good_frames_idx));
        
        % Stich Image to Panorama:
        stitched_img = stitchImage(img_translations, blurr(good_frames_idx - scene_range(1) + 1), ...
                                              block(good_frames_idx - scene_range(1) + 1));
        
        % Apply Optical Flow:
        if (opt_flow_enabled)
           
           
        end
        
        % Save Panorama Image:
        imwrite(stitched_img, ['panorama_' num2str(scene_num) '_' filename]);
                   
        % Display Image:
        if (display_enabled)
            figure(scene_num)
            imshow(stitched_img)
            title(['Panorama #' num2str(scene_num) ' in ' filename]);
        end
        
    end
    
end
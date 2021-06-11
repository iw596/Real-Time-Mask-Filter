% Function to apply dynamic masking algorithm to a set of rt-MRI frames.
% Currently dynamic mask is applied around the tongue and chin reason to
% preserve detail but will generalise to an arbitary ROI.
% Function takes the following input arguments:
% orig_rt_frames: 3d matrix of rt-MRI frames with no filter applied
% masked_frames : A 3d matrix of rt-MRI frames which have had a mask
% applied
% Function outputs the following arguments:
% masked_frames: A 3d matrix of masked rt-MRI frames
% Author: Isaac Watson
% Created: 12/11/2020
% Last Edited: 12/11/2020


function [dynamic_masked_frames,difference_map,mask_over_time,ROI_struct,noise_threshold] = dynamicMaskFiltering(masked_frames,orig_frames,mask)
    mean_matrix = masked_frames;
    roi_starting_row = 50;
    roi_ending_row = 110;
    roi_starting_col = 15;
    roi_ending_col = 85;
    % Create a region of interest struct
    ROI_struct = struct('Starting_Row', roi_starting_row, "Starting_Col",roi_starting_col,"Ending_Row",roi_ending_row,"Ending_Col",roi_ending_col);
    
    % Create a matrix showing how the mask evolves over time
    mask_over_time = zeros(size(orig_frames));
   

    tic();

    % Sample noise
    noise = mean(orig_frames(120:140,20:40,220:320),'all');
    noise_threshold = noise*1.25;
    for k = 1:size(mean_matrix,3)
        for i = roi_starting_row:roi_ending_row
            for j = roi_starting_col:roi_ending_col
                if (mask(i,j) ~=1)
                    if (mean(orig_frames(i-1:1:i+1,j-1:1:j+1,k),'all') > noise_threshold)
                        mean_matrix(i,j,k) = orig_frames(i,j,k);
                        mask_over_time(i,j,k) = 1;
                    else
                        mean_matrix(i,j,k) = 0;
                        mask_over_time(i,j,k) = 0;
                    end
                else
                    mask_over_time(i,j,k) = 1;
                end
            end
        end
    end
    toc();
    
    figure;
    subplot(3,3,1), imagesc(orig_frames(:,:,1))
    subplot(3,3,2), imagesc(masked_frames(:,:,1))
    subplot(3,3,3), imagesc(mean_matrix(:,:,1))

    subplot(3,3,4), imagesc(orig_frames(:,:,400))
    subplot(3,3,5), imagesc(masked_frames(:,:,400))
    subplot(3,3,6), imagesc(mean_matrix(:,:,400))

    subplot(3,3,7), imagesc(orig_frames(:,:,850))
    subplot(3,3,8), imagesc(masked_frames(:,:,850))
    subplot(3,3,9), imagesc(mean_matrix(:,:,850))
    
    dynamic_masked_frames = mean_matrix;
    difference_map = abs(dynamic_masked_frames - orig_frames);
    

end


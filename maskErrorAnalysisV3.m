function [dynamic_mask_ssim,static_mask_ssim,dynamic_mask_mean_difference,static_mask_mean_difference] = maskErrorAnalysisV3(original_frames_ROI,static_masked_frames_ROI,dynamic_masked_frames_ROI,mask_over_time,size_static_mask)
    % First lets compute SSIM and mean difference for static mask and
    % dynamic mask referenced against original frames.
    static_mask_ssim = zeros([1,size(original_frames_ROI,2)]);
    dynamic_mask_ssim = zeros([1,size(original_frames_ROI,2)]);
    static_mask_mean_difference = zeros([1,size(original_frames_ROI,2)]);
    dynamic_mask_mean_difference = zeros([1,size(original_frames_ROI,2)]);
  
    for i = 1:size(original_frames_ROI,3)
        % Work out SSIM for each frame
        static_mask_ssim(i) = ssim(original_frames_ROI(:,:,i),static_masked_frames_ROI(:,:,i));
        dynamic_mask_ssim(i) = ssim(original_frames_ROI(:,:,i),dynamic_masked_frames_ROI(:,:,i));
        % Work out absolute mean difference
        static_mask_mean_difference(i) = mean(abs(static_masked_frames_ROI(:,:,i) - original_frames_ROI(:,:,i)),'all');
        dynamic_mask_mean_difference(i) = mean(abs(dynamic_masked_frames_ROI(:,:,i) - original_frames_ROI(:,:,i)),'all');
        % Calculate size of dynamic mask size
        current_mask_size = squeeze(mask_over_time(:,:,i));
        mask_size(i) = sum(current_mask_size(:) == 1);
    end
    
    % Plot the SSIM values
    figure, plot(static_mask_ssim); hold on;
    plot(dynamic_mask_ssim); grid minor; xlabel('Frame Number'); 
    ylabel('SSIM Value')
    title("Structural Similarity Index Metric");  
    legend('Static Mask Filter','Dynamic Mask Filter')
    
    % Plot the normalised SSIM values
    figure, plot(static_mask_ssim./size_static_mask); hold on;
    plot(dynamic_mask_ssim./mask_size); grid minor;
    xlabel('Frame Number'); 
    ylabel('Normalized SSIM')
    title("Normalised Structural Similarity Index Metric"); 
    legend('Static Mask Filter','Dynamic Mask Filter','Location','southeast')
    
    % Plot the mean difference
    figure, plot(static_mask_mean_difference); hold on;
    plot(dynamic_mask_mean_difference); grid minor;
    title("Mean Difference"); 
    xlabel('Frame Number'); 
    ylabel('Mean Difference');
    legend('Static Mask Filter','Dynamic Mask Filter')
    
    % Plot the normalised mean difference
    figure, plot(static_mask_mean_difference./size_static_mask); hold on;
    plot(dynamic_mask_mean_difference./mask_size); grid minor;
    title("Normalised Mean Difference"); 
    xlabel('Frame Number'); 
    ylabel('Normalised Mean Difference');
    legend('Static Mask Filter','Dynamic Mask Filter')
    
    
    
    

end
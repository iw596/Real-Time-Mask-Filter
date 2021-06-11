% Function to create videos from the processed real-time MRI videos. 

 % To do: create GUI to allow user to pick where to save video


function createSplitScreenVideo(video_name,original_frames,dynamic_masked_frames,...
                                 dynamic_difference_map,ROI)
   
% Lets store the videos in filestore for now
filepath = ''; % ENTER FILEPATH HERE
% Add the video name onto the end of the filepath
fullpath = join([filepath,video_name],'');
% Want to plot original frames, dynamic masked frames in ROI and difference
% map in ROI. So first lets extract the ROI
original_frames_ROI = original_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
dynamic_masked_frames_ROI = dynamic_masked_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
dynamic_difference_map_ROI = dynamic_difference_map(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);

% Time to make some videos
figure;
% Need to create video object first, call char to convert string to
% character array
vid_obj = VideoWriter(char(fullpath));
vid_obj.FrameRate=1./(5.1/361);
open(vid_obj);
% Loop through each frames
for i = 1:size(original_frames,3)
    subplot(1,2,1); imagesc(original_frames_ROI(:,:,i));axis square; axis off; title("Original");
    subplot(1,2,2); imagesc(dynamic_masked_frames_ROI(:,:,i));axis square; axis off; title("Filtered Frames");
    % Uncomment if you want Difference Map to also be recorded
    %subplot(1,3,3); imagesc(dynamic_difference_map_ROI(:,:,i));axis square; axis off; title("Difference Map");
    frame = getframe(gcf);
    writeVideo(vid_obj,frame);
end
vid_obj.close();


end


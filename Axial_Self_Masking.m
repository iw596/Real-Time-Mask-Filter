% Mask based filtering using the average of a subset of frames as a mask

% Load the data
data = load('Axial_Tongue_Out.mat');
% Extract frames
frames = data.frames;
% Normalise data
frames_processed = mat2gray(frames);
% Average 100 frames post saturation
averaged_frames = mean(frames_processed(:,:,200:300),3);
% Generate binary mask
mask = imfill(bwareaopen(im2bw(averaged_frames,0.09),10),'holes'); % Experiment with values here
% Apply mask to frames
frames_static_mask = frames_processed.*mask;
% Extract anatomy from background
frames_static_mask = frames_static_mask(144./2:288-144./2,144./2:288-144./2,:);
processed_original_frames = frames_processed(144./2:288-144./2,144./2:288-144./2,:);
mask = mask(144./2:288-144./2,144./2:288-144./2);
% Apply dynamic mask
[dynamic_masked_frames,difference_map,mask_over_time,ROI,noise_threshold] = dynamicMaskFiltering(frames_static_mask,processed_original_frames,mask); 
video_name = "Axial_Tongue_Out";
% Lets store the videos in filestore for now
% Add the video name onto the end of the filepath
% Want to plot original frames, dynamic masked frames in ROI and difference
% map in ROI. So first lets extract the ROI
original_frames_ROI = processed_original_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
dynamic_masked_frames_ROI = dynamic_masked_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);

% Time to make some videos
video_screen = figure;
% Need to create video object first, call char to convert string to
% character array
vid_obj = VideoWriter(char(video_name));
vid_obj.FrameRate=1./(5.1/361);
open(vid_obj);
% Loop through each frames
for i = 1:size(original_frames_ROI,3)
    subplot(1,2,1); imagesc(original_frames_ROI(:,:,i));axis square; axis off; title("Original");
    subplot(1,2,2); imagesc(dynamic_masked_frames_ROI(:,:,i));axis square; axis off; title("Filtered Frames");
    frame = getframe(gcf);
    writeVideo(vid_obj,frame);
end
vid_obj.close();


                             
filtered_frames_ROI = dynamic_masked_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
original_frames_ROI = processed_original_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);

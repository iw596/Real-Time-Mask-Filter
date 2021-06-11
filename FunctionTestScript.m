% Script to test dynamic mask filtering algorithm, runs the algorithm does
% some error evaluation and creates a split screen video
% Author: Isaac Watson
% Created: 12/11/2020
% Last Edited: 21/05/2020


% Load high-res dicoms
[high_res_static,high_res_static_info] = StackLoader("Sagittal");
% Load real-time MRI frames change to be whatever data file you want
rt_data = load("Tongue_Out.mat");
rt_frames = rt_data.frames;
frame_location = rt_data.twix.hdr.MeasYaps.sSliceArray.asSlice{1}.sPosition;
% 0.02 is a good threshold for T2 and 0.04 is good for T1,
threshold = 0.02;
% Should break this up into static mask then dynamic mask

[static_masked_frames,processed_original_frames,mask] = controlPointMaskingFilter(rt_frames,frame_location,high_res_static,high_res_static_info,threshold);
[dynamic_masked_frames,difference_map,mask_over_time,ROI,noise_threshold] = dynamicMaskFiltering(static_masked_frames,processed_original_frames,mask);                                      

% Create a split screen video
video_name = "Tongue_Out_Video";
createSplitScreenVideo(video_name,processed_original_frames,dynamic_masked_frames,...
                                 difference_map,ROI);
                             
% Extract ROI from original frames and filtered frames
original_frames_ROI = processed_original_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
static_masked_frames_ROI = static_masked_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
dynamic_masked_frames_ROI = dynamic_masked_frames(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
mask_over_time_ROI = mask_over_time(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col,:);
static_mask_ROI = mask(ROI.Starting_Row:ROI.Ending_Row,ROI.Starting_Col:ROI.Ending_Col);
size_static_mask = sum(static_mask_ROI(:));
maskErrorAnalysisV3(original_frames_ROI,static_masked_frames_ROI,dynamic_masked_frames_ROI,mask_over_time,size_static_mask);

% Function to perform pre-processing on rt-MRI frames and high resolution
% static dicoms. The head in rt-frames will be extracted from background
% and intesnity normalised to be between 0 and 1. The dicoms will be
% downsized to the same resolution as the extract rt frames and wil also
% have their intensity normalised.
% Function takes the following inputs
% frames: rt frames to be processed
% high_res_static: High resolution dicom images
% Function outputs the following
% processed_rt_frames: rt_frames after processing
% processed_high_res_static: High resolution images after processing
% Author: Isaac Watson
% Created: 04/11/2020
% Last Edited: 04/11/2020
% To do: Make more generic for other planes

function [processed_rt_frames, processed_high_res_static] = highToLowResPreProcessing(frames,high_res_static)
    % First normalise the rt-frame intensity;
    processed_rt_frames = mat2gray(frames);
    % Extract head from background
    processed_rt_frames = processed_rt_frames(144./2:288-144./2,144./2:288-144./2,:);
    % Resize  high-res to have same resolution as rt-frames
    downsized_high_res_static = imresize(high_res_static,size(processed_rt_frames(:,:,1)));
    % Normalise high res frames
    processed_high_res_static = mat2gray(downsized_high_res_static);
end
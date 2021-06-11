% Function to peform mask based filtering on a real-time MRI video. 
%Function takes the following input arguments:
% frames: 3d matrix of rt-MRI frames
% frame_location:location where the frames was acquired
% high_res_static: A 3d matrix of high-resolution MRI images
% high_res_static_info: Metadata associated with high-resolution MRI images
% resolution: resolution that the frames will be scaled too
% increase_thickness: Boolean that determine if thickness of mask will be
%                     increased
% smoothing: Boolean that determines if smoothing will be applied to mask
%
% Function outputs the following arguments:
% dyanamic_masked_frames: A 3d matrix of rt-MRI frames which have had the
% dynamic mask algorithm applied.
% static_masked_frames: A 3d matrix of rt-MRI frames which have had the
% static mask algorithm applied.
% registered_frames: A 3d matrix of registered but not masked rt-MRI frames
% Author: Isaac Watson
% Created: 30/09/2020
% Last Edited: 02/10/2020
% To do: Make more generic for other planes


function [static_masked_frames,processed_orginal_frames,mask] = controlPointMaskingFilter(frames,frame_location,high_res_static,high_res_static_info,threshold)
    
    [processed_rt_frames, processed_high_res_static] = highToLowResPreProcessing(frames,high_res_static);
    processed_orginal_frames =  processed_rt_frames;
    % After pre-processing we can then find the closest high-res slice
    [closest_processed_high_res_slice,index] = sliceSelection(frame_location.dSag,processed_high_res_static,high_res_static_info);
    % Can now perform static registration and masking, need to decide a
    % threshold
    [static_masked_frames,mask] = staticRegistrationMasking(processed_rt_frames,closest_processed_high_res_slice,threshold);
 
end


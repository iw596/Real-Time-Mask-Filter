% Function to perform static mask based filtering on a real-time MRI video. First stage is registration
% this is then followed by the application of a static binary mask;.
% Function takes the following input arguments:
% rt_frames: 3d matrix of rt-MRI frames
% static_slice : A static slice to be used as a mask
% resolution: resolution that the frames will be scaled too
% Function outputs the following arguments:
% masked_frames: A 3d matrix of masked rt-MRI frames
% Author: Isaac Watson
% Created: 04/11/2020
% Last Edited: 04/11/2020
% To do: Make more generic for other planes

function [filtered_frames,mask] = staticRegistrationMasking(rt_frames,static_slice,threshold)
    % First need to perform some control point registration
    % Manual part of the image registration
    [mp,fp] = cpselect(static_slice,rt_frames(:,:,1),'Wait',true);
    t = fitgeotrans(mp,fp,'similarity');
    Rfixed = imref2d(size(rt_frames(:,:,1)));
    registered = imwarp(static_slice,t,'OutputView',Rfixed);
    figure,imshowpair(rt_frames(:,:,1),registered,'diff');
    mask = generateBinaryMask(registered,0.02,0,0);
    figure, imagesc(mask.*rt_frames(:,:,1)); title("control Point");
    figure, imagesc(abs(mask.*rt_frames(:,:,1) - rt_frames(:,:,1))); title("control Point");
    
    % Next do some fine tuning 
    % Set up optimizer for sagittal
    [optimizer,metric] = imregconfig('multimodal');
    optimizer.InitialRadius = optimizer.InitialRadius/350;
    moving  = registered;
    fixed = rt_frames(:,:,1);
    
    optimizer.MaximumIterations = 1000;  %Register each frame
    tformSimilarity_1 = imregtform(moving,fixed,'translation',optimizer,metric);
    registered_image = imregister(moving,fixed,'translation',optimizer,metric,...
        'InitialTransformation',tformSimilarity_1);
    
  
    registered_image = registered_image;
    % Next we can creare the binary mask, threshold depends on whether t1
    % or t2
    mask = generateBinaryMask(registered_image,threshold,0,0);

    %figure, imagesc(mask.*rt_frames(:,:,1));
    %figure, imagesc(abs(mask.*rt_frames(:,:,1) - rt_frames(:,:,1)));
    filtered_frames = rt_frames.*mask;
    figure,
    subplot(1,2,1); imagesc(rt_frames(:,:,1)); axis square; axis off; title("Original frame");
    subplot(1,2,2); imagesc(mask.*rt_frames(:,:,1));axis square; axis off;title("Masked frame");
    
end


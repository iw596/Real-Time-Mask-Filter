% This script is used to test "Slow-motion" videos. This is done by
% interpolating between frames. 
% Author: Isaac Watson
% Created: 31/03/2020
% Last Edited: 01/04/2020
ccc;

%Load in rt-data
rt_data = load("Saggital_Speech.mat");
image_store = rt_data.frames;

%Interpolate between frames
rows = size(image_store,1);
cols = size(image_store,2);
num_frames  = size(image_store,3);
%Frame times
orig_frames = 1:2:(num_frames.*2);

%Interpolatated frame times
inter_frames_times = 2:2:(num_frames.*2);

%Initalise interpolated frames
interpolated_frames = zeros(rows,cols,num_frames);

%Initalise the extended image store
slow_motion_frames = zeros(rows,cols,num_frames.*2);

% Asssign non-interpolated frames
slow_motion_frames(:,:,orig_frames) = image_store;


for i = 1:rows
    for j = 1:cols
        pixels_ij = squeeze(image_store(i,j,:));
        interpolated_pixels_ij = interp1(orig_frames,pixels_ij,inter_frames_times,'spline');
        interpolated_frames(i,j,:)  = reshape(interpolated_pixels_ij,1,1,length(inter_frames_times));
    end        
end

%Assign interpolated frames
slow_motion_frames(:,:,inter_frames_times) = interpolated_frames;

%Now need to create video
figure, set(0,'defaultfigurecolor',[1 1 1])
v = VideoWriter('Slow_Motion_Video');
v.FrameRate=1./(5.1/361);
v.Quality = 100;
open(v);
for i=1:size(slow_motion_frames,3)
 if i <= size(image_store,3)
    subplot(1,2,1);imagesc(image_store(144./2:288-144./2,144./2:288-144./2,i));  axis square; axis off
 else
     subplot(1,2,1);imagesc(image_store(144./2:288-144./2,144./2:288-144./2,end));  axis square; axis off
 end
 
    
 subplot(1,2,2);imagesc(slow_motion_frames(144./2:288-144./2,144./2:288-144./2,i));  axis square; axis off
 %imagesc(im_store(:,:,i)); colormap(gray)
 frame = getframe(gcf);
 writeVideo(v,frame);
end
close(v);

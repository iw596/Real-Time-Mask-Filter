%Matlab function to load a stack of 2d slices and return 3d matrix and
%dicom info
% Author: Isaac Watson
% Created: 14/01/2020
% Last Edited: 06/04/2020

function [dicoms,dicom_info] = StackLoader(plane)
    %Open filebrowser
    d = uigetdir(pwd,strcat(strcat('Select a folder containg: ', plane), " slices"));
    %Select only MRI slice files
    files = dir(fullfile(d, '*MR*.*'));
    for i=1:size(files,1)
        file_name = strcat(files(i,1).folder,"\",files(i,1).name);
        dicoms(:,:,i) = dicomread(file_name);
        dicom_info(i)  = dicominfo(file_name);
    end
end

    
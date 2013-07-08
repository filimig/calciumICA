%%%%%%%%%
% Driver script for analysing Ca-II data
%
% 
% Written by;
% Fillippo Moriarty
% Rajat Thomas
%
% Netherlands Institute for Neuroscience
% 08-July-2013
%
% WARNING: All the following analises depend on the FastICA toolbox by Aapo
% Hyvärinen et al. 
% http://research.ics.aalto.fi/ica/fastica/
%%%%%%%%%

% First of all, a bit of housekeeping..
clear all
clc

% Then add to Matlab path the directory containing the functions that are
% going to be used for the analyses
addpath('include')

% Set some parameters
numOfIC=10;
lastEig=20;
waveletLevels=5;

% Load data.
fname='retinotopy_frames.mat';
ffrr=loadData(fname);
% Since the data where shipped as a cellArray of images, I am going to
% reshape them as a 4D stack of images
data=reshapeData(ffrr);
clear ffrr
% Save the data in NIFTI-compressed format, so that they can be used by FSL
% or other tools
save_avw(data(:,:,1,1),'mouseV1','f',[1 1 1 1])

% Load mask...
maskName='calcium_ICA-mask.nii.gz';
mask=LoadMask(maskName);

% Select dataset belonging to mask.
maskedData=maskData(data,mask);

% Perform ICA on the original data.
[IC,eig_TC]=makeICA(maskedData,mask,numOfIC,lastEig);
save('RawDataIC','IC','eig_TC')

% save the IC as a NIFTI volume (might be used to view the data vith
% FSLView or similar viewers
M=reshapeData(IC);
B=reshape(M,[size(IC{1},1) size(IC{1},2) 1 size(IC,2)]);
save_avw(B,'rawDataIC','f',[1 1 1 1]);
% Again, some housekeeping as memory is never enough...
clear M
clear B

% Calculate Wavelet transforms on each data
decomposedData=WaveletDecompose(maskedData,waveletLevels);

decomposedData_IC=cell(1,waveletLevels);
decomposedData_eig_TC=cell(1,waveletLevels);

% Perform ICA on each Wavelet decomposition 
for i=1:waveletLevels
    sprintf('Performing ICA on Wavelet level # %d',waveletLevels);
    [decomposedData_IC{1,i},decomposedData_eig_TC{1,i}]=makeICA(decomposedData(:,:,i),mask,numOfIC,lastEig);
end
save('DecomposedDataIC','decomposedData_IC','decomposedData_eig_TC','decomposedData','-v7.3')

%Save IC on decomposed data as NIFTI volumes
for i=1:waveletLevels
    M=reshapeData(decomposedData_IC{1,i});
    B=reshape(M,[size(decomposedData_IC{1,i}{1},1) size(decomposedData_IC{1,i}{2},2) 1 size(decomposedData_IC{1,i},2)]);
    save_avw(B,strcat('decompsedDataIC_level_',num2str(i)),'f',[1 1 1 1]);
    clear M
    clear B
end

% Plots (these script yet have to be transformed in functions.
plotRawDataAnalysis;
plotWaveletDataAnalysis;

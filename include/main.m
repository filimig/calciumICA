clear all
clc
% First of all load the data
addpath('include')
fname='retinotopy_frames.mat';
maskName='calcium_ICA-mask.nii.gz';
numOfIC=10;
lastEig=20;
waveletLevels=5;

ffrr=loadData(fname);
% Since the data where shipped as a cellArray of images, I am going to
% reshape them as a 4D stack of images
data=reshapeData(ffrr);
clear ffrr
save_avw(data(:,:,1,1),'mouseV1','f',[1 1 1 1])

% Load the binary mask and intersect the data with it
mask=LoadMask(maskName);
maskedData=maskData(data,mask);

% compute ICA on RAW data
[IC,eig_TC]=makeICA(maskedData,mask,numOfIC,lastEig);
save('RawDataIC','IC','eig_TC')

% save the IC as a NIFTI volume
M=reshapeData(IC);
B=reshape(M,[size(IC{1},1) size(IC{1},2) 1 size(IC,2)]);
save_avw(B,'rawDataIC','f',[1 1 1 1]);
clear M
clear B

% Now do the magic wavelet
decomposedData=WaveletDecompose(maskedData,waveletLevels);

decomposedData_IC=cell(1,waveletLevels);
decomposedData_eig_TC=cell(1,waveletLevels);

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

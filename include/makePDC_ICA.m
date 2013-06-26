clear all
close all
clc

load('spontaneous_frames1.mat')
M=zeros(312,300,1860);

for i=1:1860
   M(:,:,i)=ffrr{i};
end
clear ffrr
clear i
% Load the binary mask corresponding to the ROI
[img,dims,scales,bpp,endian] = read_avw('calcium_ICA-mask.nii.gz');
clear dims
clear scales
clear bpp
clear endian
% Store the indices of the pixels included in the mask
IDX=find(img>0);
% Try to compute ICA with FastICA
Mat_dim=size(M);
Mat_2D=reshape(M,[Mat_dim(1)*Mat_dim(2) Mat_dim(3)]);
% Saves only the datapoints in the mask
M=Mat_2D(IDX,:);

clear Mat_2D
clear Mat_dim
% Compute FastICA
[icasig] = fastica(M','g','gauss','a2',1,'numOfIC', 5);

% Plot the ICs on the mask
Mask=img;
for i=1:size(icasig,1)
    img(IDX)=icasig(i,:)';
    IC{i}=img;
    img=Mask;
end

% Try to compute ICA with MELODIC

B=reshape(M,[312 300 1 1860]);
save_avw(B,'calcium_ICA','f',[1 1 1 1]);

B=ones(312,300,1);
save_avw(B,'bgimage_calciumICA','s',[1 1 1 0]);

%command to run ICA using melodic
melodic -i calcium_ICA.nii.gz --tr=1.0 --report --bgimage=bgimage_calciumICA.nii.gz --mmthresh=0.5 --numICs=20 

%%

setenv('FSLDIR','/usr/local/fsl');  % FSL folder
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');  

ICs = read_avw('forPDC_ICA.ica/melodic_IC.nii.gz');
ICr = reshape(ICs,[128 128 20]);
% 
ICr(ICr > 15) = 15;
ICr((ICr < 2) & (ICr > -2)) = 0;
ICr(ICr < -15) = -15;

for i=1:20
    subplot(4,5,i)
    imagesc(ICr(:,:,i)); colorbar; axis square
end

imagesc(ICr(:,:,1)); colorbar; axis square

%%
Fs = 12.3978;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1860;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
%x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
%y = x + 2*randn(size(t));     % Sinusoids plus noise
y = squeeze(M(188,150,:));

plot(t,y)
title('Original Signal')
xlabel('time (secs)')
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

figure
% Plot single-sided amplitude spectrum.
loglog(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
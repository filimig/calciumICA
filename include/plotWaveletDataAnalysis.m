clear all
clc

load resultsSpontaneous/DecomposedDataIC.mat
%% Plot the powerspectrum of the 5 partitions obtained by the Wavelet transform
% The sampling frequency is approximately 12Hz
Fs=12;
figure;
%for i=1:size(decomposedData,3)
for i=1:1
    [psdestx,Fxx] = periodogram(decomposedData(:,:,i));
    plot(Fxx,10*log10(psdestx)); grid on;
    xlabel('Hz'); ylabel('Power/Frequency (dB/Hz)');
    title('Periodogram Power Spectral Density Estimate');
    max(psdx'-psdestx)
end
%%
figure('Name','Wavelet partitioned data - ICs and eigen time courses','NumberTitle','off')
suptitle('Wavelet partitioned data - ICs and eigen time courses.')
for i=1:size(IC,2)
    disp(i)
    subplot(2,10,i)
    imagesc(flipud(IC{1,i}))
    axis image
    set(gca,'Title',text('String',strcat('IC ',num2str(i)),'Color','r'))
    set(gca,'ytick',[],'xtick',[])
    subplot(2,10,i+size(IC,2))
    plot(eig_TC(i,:))
    view(-90,90)
    if i==1
        xlabel('Time')
    end
    set(gca,'Title',text('String',strcat('EigTC ',num2str(i)),'Color','r'))
    set(gca,'ytick',[])
end
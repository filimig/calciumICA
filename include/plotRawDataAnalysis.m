%% plot spontaneous activity
clear all
clc
load 000_resultsSpontaneous/RawDataIC.mat
%%
figure('Name','Spontaneous - Raw data - ICs and eigen time courses','NumberTitle','off')
suptitle('Spontaneous - Raw data - ICs and eigen time courses.')
for i=1:size(IC,2)
    disp(i)
    subplot(2,10,i)
    imagesc(flipud(IC{1,i}))
    axis image
    set(gca,'Title',text('String',strcat('IC ',num2str(i)),'Color','r'))
    set(gca,'ytick',[],'xtick',[])
    view(-90,90)
    subplot(2,10,i+size(IC,2))
    plot(eig_TC(i,:))
    view(-90,90)
    if i==1
        xlabel('Time')
    end
    set(gca,'Title',text('String',strcat('EigTC ',num2str(i)),'Color','r'))
    set(gca,'ytick',[])
end

%% plot retinotopy 
clear all
clc
load 001_resultsRetinotopy/RawDataIC.mat
%%
figure('Name','Raw data - ICs and eigen time courses','NumberTitle','off')
suptitle('Retinotopy - Raw data - ICs and eigen time courses.')
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
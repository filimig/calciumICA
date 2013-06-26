%%

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
% find the pixels included in the mask and then reshape them in a
% Pixels*Time 2D matrix
Mat_dim=size(M);
Mat_2D=reshape(M,[Mat_dim(1)*Mat_dim(2) Mat_dim(3)]);
% Saves only the datapoints in the mask
M=Mat_2D(IDX,:);

% regression of EigTC on the original data
% 
% rsq=zeros(size(M,1));
% for i=1:size(eig_TC,1)
%     x=eig_TC(i,:);
%     for j=1:size(M,1)
%         y=M(j,:);
%         p=polyfit(x,y,1);
%         M_fit=polyval(p,x);
%         M_res=y-M_fit;
%         SSresid = sum(M_res.^2);
%         SStotal = (length(y)-1) * var(y);
%         
%         rsq(j)=1 - SSresid/SStotal;
%     end
% end


cm=corr(eig_TC',M');

disp('Map the explained variance back to the anatomy')
Mask=img;
corrMap=cell(size(cm,1),1);
for i=1:size(cm,1)
    img(IDX)=cm(i,:)';
    corrMap{i}=img;
    img=Mask;
end

for l=1:size(corrMap,1)
    meanVar(l)=mean(mean(abs(corrMap{l})))
end
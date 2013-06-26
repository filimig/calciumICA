function [IC,eig_TC]=makeICA(data,mask,numOfIC,lastEig)
% TODO:
% Implement a way to recaclulate the ICA when it aborts with less
% components than required by the function arguments. 
    t=size(data,2);
    disp('FastICA computation')
    [icasig,A,W] = fastica(data', 'lastEig', lastEig, 'numOfIC', numOfIC);

    % Plot the ICs on the mask
    disp('Map the ICs back to the anatomy')
    IDX=find(mask>0);
    Mask=mask;
    IC=cell(1,size(icasig,1));
    for i=1:size(icasig,1)
        mask(IDX)=icasig(i,:)';
        IC{1,i}=mask;
        mask=Mask;
    end
%    eig_TC=W;
    % Compute the Eig_TC associated with each component
    disp('computing eigen time courses')
    eig_TC=zeros(size(icasig,1),t);
    for l=1:numOfIC
        for j=1:t
           eig_TC(l,j)=corr(icasig(l,:)',data(:,j)); 
        end
    end

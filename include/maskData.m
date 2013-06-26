function maskedData=maskData(data,mask)
    % Store the indices of the pixels included in the mask
    IDX=find(mask>0);
    % Try to compute ICA with FastICA
    Mat_dim=size(data);
    Mat_2D=reshape(data,[Mat_dim(1)*Mat_dim(2) Mat_dim(3)]);
    % Saves only the datapoints in the mask
    maskedData=Mat_2D(IDX,:);
end
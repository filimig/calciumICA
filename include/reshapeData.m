function reshapedData=reshapeData(data)
    disp('reshaping data')
    n=size(data{1},1);
    m=size(data{1},2);
    t=size(data,2);
    M=zeros(n,m,t);
    for i=1:t
       M(:,:,i)=data{i};
    end
    reshapedData=M;
end
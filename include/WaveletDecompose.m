function [outArray] = WaveletDecompose(data,Levels)

     if numel(size(data)) ~= 2
        error('Please i/p 2D array to WaveletDecompose');
    end

    [x,t]=size(data);

    nt = zeros(1,2^nextpow2(t));

    outArray = zeros(x,length(nt),Levels);

    for i=1:x
            nt(1:t)=data(i,:);
            [swa,swd] = swt(nt,Levels,'db1');

            outArray(i,:,:) = swa';
    end

end

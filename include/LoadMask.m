function mask=LoadMask(maskName)
    disp('loading the binary mask')
    [img,dims,scales,bpp,endian] = read_avw(maskName);
    mask=img;
end
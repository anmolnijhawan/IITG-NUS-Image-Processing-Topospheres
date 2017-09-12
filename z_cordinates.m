fname = 'C5-Hyperstack.tif';
info = imfinfo(fname);
imageStack = [];
numberOfImages = length(info);
imageStack=zeros(4660,4672,13);
for k = 6:13%1:numberOfImages
    currentImage = imread(fname, k, 'Info', info);
    imageStack(:,:,k) = currentImage;
end

z_axis_store=zeros(25,25,2);
L=zeros(128,128,13);
for k=1%:25
    for j=1%:25
        for i=1:13
            im1=imcrop(imageStack(:,:,i),[a(1) a(2) 128 128]);%[3367 1690 127 127 x_cor_centre y_cor_centre radius<64 radius<64]); 
            F=fft2(im1,128,128);
            S=fftshift(F);
            L(:,:,i)=log(abs(S)+1);
        end

        sum1=zeros(13,1);
        for i=1:13
            im1=L(:,:,i);    
            im2=imcrop(L(:,:,i),[31 31 67 67]);
            im2=padarray(im2,[30 30]);
            im3=im1-im2;
            im4=imcrop(L(:,:,i),[31 31 67 67]);
            im4=padarray(im4,[30 30]);
            im5=imcrop(L(:,:,i),[62 62 5 5]);
            im5=padarray(im5,[61,61]);
            im5=im4-im5;
            im2=L(:,:,i)-im2;
            sum1(i,1)=sum(sum(im2));
            sum2(i,1)=sum(sum(im5));
        end
       ratio=sum1./sum2;

       ratio_tmp=ratio;
       sort_ratio=sort(ratio_tmp,'descend');
       ratio_tmp=(ratio_tmp>sort_ratio(5))>0;
       z_axis=find(ratio_tmp);
       z_axis_store(k,j,:)=[z_axis(1) z_axis(4)];


    end
end


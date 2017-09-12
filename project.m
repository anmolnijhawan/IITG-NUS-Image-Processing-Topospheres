fname = 'C5-Hyperstack.tif';
info = imfinfo(fname);
imageStack = [];
numberOfImages = length(info);
imageStack=zeros(4660,4672,13);
for k = 6:13%1:numberOfImages
    currentImage = imread(fname, k, 'Info', info);
    imageStack(:,:,k) = currentImage;
end

L=zeros(151,151,3);
images=zeros(512,512,13);
image=uint8(imageStack(:,:,6));
[centers, radii, metric] = imfindcircles(imageStack(:,:,6),[30 70]);
imshow(imageStack(:,:,6))
im=viscircles(centers, radii,'EdgeColor','b');
im=imageStack(:,:,6);
figure;
imshow(image);

for i=1:13
fdr = strcat('channel 5 Brightfield/tile_x006_y006_z00',num2str(i),'.tif');
if exist(fdr,'file')
images(:,:,i)=imread(fdr);
end
end
im1=uint8(images(:,:,5));
imshow(im1);
for i=1:13
im1=imcrop(images(:,:,i),[122 145 150 150]);
%im1=(uint8(im1));
%imshow(im1);
F=fft2(im1);
S=fftshift(F);
L(:,:,i)=log(abs(S)+1);
end
sum1=zeros(13,1);
sum111=sum(L(:,:,12));
for i=1:13
im1=L(:,:,i);    
im2=imcrop(L(:,:,i),[21 21 87 87]);
im2=padarray(im2,[20 20]);
im3=im1-im2;
im4=imcrop(L(:,:,i),[26 26 77 77]);
im4=padarray(im4,[25 25]);
im5=imcrop(L(:,:,i),[60 60 9 9]);
im5=padarray(im5,[59,59]);
im5=im4-im5;
im2=L(:,:,i)-im2;
sum1(i,1)=sum(sum(im2));
sum2(i,1)=sum(sum(im5));
end
ratio=sum1./sum2;

imshow(uint8(imageStack(:,:,6)));

L=zeros(128,128,13);
for i=1:13
im1=imcrop(imageStack(:,:,i),[1045 2386 105 105]);
%im2=(uint8(im1));
%imshow(im2);
%im1=adapthisteq(im1);
F=fft2(im1,128,128);
S=fftshift(F);
L(:,:,i)=log(abs(S));
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


L=zeros(128,128,13);
for i=1:13
im1=imcrop(imageStack(:,:,i),[650 3708 112 131]);
%im2=(uint8(im1));
%imshow(im2);
%im1=adapthisteq(im1);
F=fft2(im1,128,128);
S=fftshift(F);
L(:,:,i)=log(abs(S));
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


L=zeros(128,128,13);
for i=1:13
im1=imcrop(imageStack(:,:,i),[1340 2432 116 118]);
%im2=(uint8(im1));
%imshow(im2);
F=fft2(im1,128,128);
S=fftshift(F);
L(:,:,i)=log(abs(S));
end
sum1=zeros(13,1);
for i=1:13
im1=L(:,:,i);    
im2=imcrop(L(:,:,i),[21 21 87 87]);
im2=padarray(im2,[20 20]);
im3=im1-im2;
im4=imcrop(L(:,:,i),[26 26 77 77]);
im4=padarray(im4,[25 25]);
im5=imcrop(L(:,:,i),[60 60 9 9]);
im5=padarray(im5,[59,59]);
im5=im4-im5;
im2=L(:,:,i)-im2;
sum1(i,1)=sum(sum(im2));
sum2(i,1)=sum(sum(im5));
end
ratio=sum1./sum2;


L=zeros(128,128,13);
for i=1:13
im1=imcrop(imageStack(:,:,i),[3630 1907 119 110]);
%im2=(uint8(im1));
%imshow(im2);
F=fft2(im1,128,128);
S=fftshift(F);
L(:,:,i)=log((abs(S)+1));

end

sum1=zeros(13,1);
for i=1:13
im1=L(:,:,i);    
im2=imcrop(L(:,:,i),[21 21 87 87]);
im2=padarray(im2,[20 20]);
im3=im1-im2;
im4=imcrop(L(:,:,i),[26 26 77 77]);
im4=padarray(im4,[25 25]);
im5=imcrop(L(:,:,i),[60 60 9 9]);
im5=padarray(im5,[59,59]);
im5=im4-im5;
im2=L(:,:,i)-im2;
sum1(i,1)=sum(sum(im2));
sum2(i,1)=sum(sum(im5));
end
ratio=sum1./(sum2);

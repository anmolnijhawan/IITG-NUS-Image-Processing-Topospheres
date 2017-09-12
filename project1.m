focus=zeros(13,1);
for i=1:13
im1=imcrop(imageStack(:,:,i),[4448 944 128 128]);
%im2=(uint8(im1));
%imshow(im2);
focus(i,1)=fmeasure(im1,'CONT');
end
focus1=zeros(13,1);
for i=1:13
im1=imcrop(imageStack(:,:,i),[1045 2386 105 105]);
%im2=(uint8(im1));
%imshow(im2);
focus1(i,1)=fmeasure(im1,'CONT');
end

for i=1:13
im1=imcrop(imageStack(:,:,i),[650 3708 112 131]);
im2=(uint8(im1));
imshow(im2);
focus1(i,1)=fmeasure(im1,'CONT');
end

im1=imread('forensic_eyes_1 (2).jpg');
im2=imread('forensic_eyes_1 (3).jpg');
F1=fft2(im1,256,256);
S1=fftshift(F);
L1(:,:,i)=log((abs(S)+1));
F2=fft2(im1,256,256);
S2=fftshift(F);
L2(:,:,i)=log((abs(S)+1));



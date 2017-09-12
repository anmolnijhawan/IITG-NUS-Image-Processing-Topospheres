im1=imread('channel 5 Brightfield/tile_x007_y008_z005.tif');
im2=imread('channel 5 Brightfield/tile_x007_y009_z005.tif');
im1=uint8(im1);
imshow(im1);
figure;
im2=uint8(im2);
imshow(im2);
im3=imcrop(im1,[1 448 512 63]);
im3=uint8(im3);
figure;
imshow(im3);
im4=imcrop(im2,[1 1 512 63]);
im4=uint8(im4);
figure;
imshow(im4);
%local binary pattern
points1=detectSURFFeatures(im3);
points2=detectSURFFeatures(im4);
[f1,vpts1] = extractFeatures(im3,points1);
[f2,vpts2] = extractFeatures(im4,points2);
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
figure; showMatchedFeatures(im3,im4,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');


im1=imread('channel 5 Brightfield/tile_x009_y007_z005.tif');
im2=imread('channel 5 Brightfield/tile_x009_y008_z005.tif');
im1=uint8(im1);
figure;
imshow(im1);
im2=uint8(im2);
figure;
imshow(im2);
im3=imcrop(im1,[1 448 512 63]);
im3=uint8(im3);
figure;
imshow(im3);
im4=imcrop(im2,[1 1 512 63]);
im4=uint8(im4);
figure;
imshow(im4);

%local binary pattern
points1=detectSURFFeatures(im3);
points2=detectSURFFeatures(im4);
[f1,vpts1] = extractFeatures(im3,points1);
[f2,vpts2] = extractFeatures(im4,points2);
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
figure; showMatchedFeatures(im3,im4,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');


figure;
plot(sum1113);
figure;
plot(sum1114);

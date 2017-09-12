fname = '/home/adnan/c5.tif';
info = imfinfo(fname);
%imageStack = [];
numberOfImages = length(info);
imageStack=zeros(4660,4672,13);
for k = 1:13
    currentImage = imread(fname, k, 'Info', info);
    imageStack(:,:,k) = currentImage;
end

im=imcrop(imageStack(:,:,9),[1300 1300 300 300]);
imshow(uint8(im));
[centres,radii]= imfindcircles(edge(im,'Canny'),[50,80],'Method','TwoStage','Sensitivity',0.9,'EdgeThreshold',0.1);
viscircles(centres,radii,'EdgeColor','b');
no_of_cir=size(centres);
no_of_cir=no_of_cir(1);
[X,Y]=meshgrid(centres(:,1),centres(:,2));
     delta_X=X-X';
    delta_Y=Y-Y';
    dist=hypot(delta_X,delta_Y);
   dist=dist+(eye(no_of_cir)*10000);
    [xi,yi]=find(dist==min(dist(:)));
    cir_1=centres(xi(1),:);
    cir_2=centres(xi(2),:);
    cir_dif=cir_2-cir_1;
    tan_theta=abs(cir_dif(2)/cir_dif(1));
    tan_theta=atan(tan_theta);
    theta=radtodeg(tan_theta);
    if theta>75
        theta=90-theta;
    end
    
im11=imrotate(imageStack(:,:,9),theta);
imshow(uint8(im11));
siz=size(im11);
imageStack1=zeros(siz(1),siz(2),13);

for i=1:13 
   im11=imrotate(imageStack(:,:,i),theta); 
   imageStack1(:,:,i)=im11;
end
clear imageStack;
imshow(uint8(imageStack1(:,:,9)));

[centres,radii]= imfindcircles(edge(im11,'Canny'),[50,80],'Method','TwoStage','Sensitivity',0.9,'EdgeThreshold',0.1);
viscircles(centres,radii,'EdgeColor','b');

new_im=zeros(25,25,5);
siz=size(centres);
new_cen=zeros(siz(1),2);
new_radii=zeros(siz(1),1);
j=1;
for i=1:siz(1)
    new_cor=centres(i,:);
    new_cor1=new_cor-[64 64];
     im1=imcrop(im11,[new_cor1(1) new_cor1(2) 128 128]);   
    %im1=imcrop(imageStack(:,:,9),[new_cor1(1) new_cor1(2) 128 128]);
        %variance=var(im1(:));
        if(new_cor1(1)>650 && new_cor1(2)>650) %variance>2000 && 
            new_cen(j,:)=new_cor;
            new_radii(j)=radii(i);
            j=j+1;
        im1=uint8(im1);
        %figure;
        imshow(im1);
        end
    
end
%viscircles(new_cen,new_radii,'EdgeColor','b');



a=indexed(22,15,1)-64;
b=indexed(22,15,2)-64;
image=imcrop(imageStack1(:,:,7),[a b 128 128]);
imshow(uint8(image));

for i=1:13
            im1=imcrop(imageStack1(:,:,i),[a b 128 128]);%[3367 1690 127 127 x_cor_centre y_cor_centre radius<64 radius<64]); 
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
       ratio_tmp=(ratio_tmp>sort_ratio(6))>0;
       z_axis=find(ratio_tmp);
      
       
   

new_cen_1= unique(new_cen,'rows');
new_cen_2= new_cen_1(2:end,1:2);
clear new_cen_1;    
size_cen=size(new_cen_2,1);

%indexing
indexed=zeros(25,25,5);
distance= hypot(new_cen_2(:,1) ,new_cen_2(:,2));
[dist2 ,index]= sort(distance);
indexed(1,1,1:2)= [new_cen_2(index(1),1) , new_cen_2(index(1),2)];
new_cen_2(index(1),1)=999999999;  new_cen_2(index(1),2)=999999999;

%diagonal indexing
for i=2:25
    j=i;
    assumed_cen= [indexed(i-1,j-1,1)+150, indexed(i-1,j-1,2)+150];
           error_dist= [new_cen_2(:,1)-assumed_cen(1) , new_cen_2(:,2)-assumed_cen(2)];
        error_dist2= hypot(error_dist(:,1), error_dist(:,2));
        [dist_3 , index2] = sort(error_dist2);
        
         indexed(i,j,1)= new_cen_2(index2(1),1); 
        indexed(i,j,2)= new_cen_2(index2(1),2);
        
        new_cen_2(index2(1),1)=999999999;  new_cen_2(index2(1),2)=999999999;
    

end

%=============================================================
%lower triangle
%==============================================================
for k=1:24
for i=2:25
    j=i-k;
    
    temp_new_cen_2=new_cen_2;
        if j>1
       for q=1:size_cen
            if temp_new_cen_2(q,1)>indexed(i,j+1,1)
                temp_new_cen_2(q,1)=999999999999;
            end
       end   
        
       for q=1:size_cen
            if temp_new_cen_2(q,1)>indexed(i-1,j,1)+20
                temp_new_cen_2(q,1)=999999999999;
            end
            if temp_new_cen_2(q,1)<indexed(i-1,j,1)-20
                temp_new_cen_2(q,1)=999999999999;
            end
                                   
       end
       
              
            
            assumed_cen= [indexed(i-1,j-1,1)+150, indexed(i-1,j-1,2)+150];
           error_dist= [temp_new_cen_2(:,1)-assumed_cen(1) , temp_new_cen_2(:,2)-assumed_cen(2)];
        error_dist2= hypot(error_dist(:,1), error_dist(:,2));
        [dist_3 , index2] = sort(error_dist2);
        prob_cen=[new_cen_2(index2(1),1), new_cen_2(index2(1),2) ; new_cen_2(index2(2),1), new_cen_2(index2(2),2); new_cen_2(index2(3),1), new_cen_2(index2(3),2); new_cen_2(index2(4),1), new_cen_2(index2(4),2);new_cen_2(index2(5),1), new_cen_2(index2(5),2)];   
       
        dist_error_1= hypot( prob_cen(:,1)-indexed(i-1,j,1) , prob_cen(:,2)-indexed(i-1,j,2));
        dist_error_2= hypot( prob_cen(:,1)-indexed(i,j+1,1) , prob_cen(:,2)-indexed(i,j+1,2));
        sum_dist_error= dist_error_1 + dist_error_2;
        
        [temp_error5 , index3]= sort(sum_dist_error);
        
        %again check before storing
        if abs(new_cen_2(index2(index3(1)),1)-indexed(i-1,j,1))<30 & abs(new_cen_2(index2(index3(1)),2)-indexed(i,j+1,2))<30
        indexed(i,j,1)= new_cen_2(index2(index3(1)),1); 
        indexed(i,j,2)= new_cen_2(index2(index3(1)),2);   
               
       new_cen_2(index2(index3(1)),1)=999999999999;  new_cen_2(index2(index3(1)),2)=999999999999;
        
       else
       indexed(i,j,1)= indexed(i-1,j,1); 
        indexed(i,j,2)= indexed(i,j+1,2);
        end
        end
        
        if j==1
        
        assumed_cen= [indexed(i-1,j,1), indexed(i-1,j,2)+150];
        for q=1:size_cen
            if temp_new_cen_2(q,1)>indexed(i,j+1,1)
                temp_new_cen_2(q,1)=999999999999;
            end
        end
      for q=1:size_cen
            if temp_new_cen_2(q,1)>indexed(i-1,j,1)+20
                temp_new_cen_2(q,1)=999999999999;
            end
            if temp_new_cen_2(q,1)<indexed(i-1,j,1)-20
                temp_new_cen_2(q,1)=999999999999;
            end
                                   
       end
        
        
        
        error_dist= [temp_new_cen_2(:,1)-assumed_cen(1) , temp_new_cen_2(:,2)-assumed_cen(2)];
        error_dist2= hypot(error_dist(:,1), error_dist(:,2));
        [dist_3 , index2] = sort(error_dist2);
        prob_cen=[new_cen_2(index2(1),1), new_cen_2(index2(1),2) ; new_cen_2(index2(2),1), new_cen_2(index2(2),2); new_cen_2(index2(3),1), new_cen_2(index2(3),2)];   
        dist_error_1= hypot( prob_cen(:,1)-indexed(i-1,j,1) , prob_cen(:,2)-indexed(i-1,j,2));
        dist_error_2= hypot( prob_cen(:,1)-indexed(i,j+1,1) , prob_cen(:,2)-indexed(i,j+1,2)); 
        sum_dist_error= dist_error_1 + dist_error_2;
        
        [temp_error5 , index3]= sort(sum_dist_error);
        
                %again check before storing
        if abs(new_cen_2(index2(index3(1)),1)-indexed(i-1,j,1))<30 & abs(new_cen_2(index2(index3(1)),2)-indexed(i,j+1,2))<30
        indexed(i,j,1)= new_cen_2(index2(index3(1)),1); 
        indexed(i,j,2)= new_cen_2(index2(index3(1)),2);   
               
       new_cen_2(index2(index3(1)),1)=999999999999;  new_cen_2(index2(index3(1)),2)=999999999999;
        
       else
       indexed(i,j,1)= indexed(i-1,j,1); 
        indexed(i,j,2)= indexed(i,j+1,2);
        end
        
         
        end
end
end    
    

%============================================================
%upper traingle
%============================================================

for k=1:24
for i=1:25
    j=i+k;
    
    temp_new_cen_2=new_cen_2;
        if i>1 &j<=25
       for q=1:size_cen
            if temp_new_cen_2(q,1)<indexed(i,j-1,1)
                temp_new_cen_2(q,1)=999999999999;
            end
       end   
        
       for q=1:size_cen
            if temp_new_cen_2(q,1)>indexed(i+1,j,1)+20
                temp_new_cen_2(q,1)=999999999999;
            end
            if temp_new_cen_2(q,1)<indexed(i+1,j,1)-20
                temp_new_cen_2(q,1)=999999999999;
            end
                                   
       end
       
              
            
            assumed_cen= [indexed(i-1,j-1,1)+150, indexed(i-1,j-1,2)+150];
           error_dist= [temp_new_cen_2(:,1)-assumed_cen(1) , temp_new_cen_2(:,2)-assumed_cen(2)];
        error_dist2= hypot(error_dist(:,1), error_dist(:,2));
        [dist_3 , index2] = sort(error_dist2);
        prob_cen=[new_cen_2(index2(1),1), new_cen_2(index2(1),2) ; new_cen_2(index2(2),1), new_cen_2(index2(2),2); new_cen_2(index2(3),1), new_cen_2(index2(3),2); new_cen_2(index2(4),1), new_cen_2(index2(4),2);new_cen_2(index2(5),1), new_cen_2(index2(5),2)];   
       
        dist_error_1= hypot( prob_cen(:,1)-indexed(i,j-1,1) , prob_cen(:,2)-indexed(i,j-1,2));
        dist_error_2= hypot( prob_cen(:,1)-indexed(i+1,j,1) , prob_cen(:,2)-indexed(i+1,j,2));
        sum_dist_error= dist_error_1 + dist_error_2;
        
        [temp_error5 , index3]= sort(sum_dist_error);
        
        %again check before storing
        if abs(new_cen_2(index2(index3(1)),2)-indexed(i,j-1,2))<30 & abs(new_cen_2(index2(index3(1)),1)-indexed(i+1,j,1))<30
        indexed(i,j,1)= new_cen_2(index2(index3(1)),1); 
        indexed(i,j,2)= new_cen_2(index2(index3(1)),2);   
               
       new_cen_2(index2(index3(1)),1)=999999999999;  new_cen_2(index2(index3(1)),2)=999999999999;
        
       else
       indexed(i,j,1)= indexed(i+1,j,1); 
        indexed(i,j,2)= indexed(i,j-1,2);
        end
        end
        
        if i==1 &j<=25
        
        assumed_cen= [indexed(i+1,j,1), indexed(i+1,j,2)-150];
        for q=1:size_cen
            if temp_new_cen_2(q,1)<indexed(i,j-1,1)
                temp_new_cen_2(q,1)=999999999999;
            end
        end
      for q=1:size_cen
            if temp_new_cen_2(q,1)>indexed(i+1,j,1)+20
                temp_new_cen_2(q,1)=999999999999;
            end
            if temp_new_cen_2(q,1)<indexed(i+1,j,1)-20
                temp_new_cen_2(q,1)=999999999999;
            end
                                   
       end
        
        
        
        error_dist= [temp_new_cen_2(:,1)-assumed_cen(1) , temp_new_cen_2(:,2)-assumed_cen(2)];
        error_dist2= hypot(error_dist(:,1), error_dist(:,2));
        [dist_3 , index2] = sort(error_dist2);
        prob_cen=[new_cen_2(index2(1),1), new_cen_2(index2(1),2) ; new_cen_2(index2(2),1), new_cen_2(index2(2),2); new_cen_2(index2(3),1), new_cen_2(index2(3),2)];   
        dist_error_1= hypot( prob_cen(:,1)-indexed(i,j-1,1) , prob_cen(:,2)-indexed(i,j-1,2));
        dist_error_2= hypot( prob_cen(:,1)-indexed(i+1,j,1) , prob_cen(:,2)-indexed(i+1,j,2)); 
        sum_dist_error= dist_error_1 + dist_error_2;
        
        [temp_error5 , index3]= sort(sum_dist_error);
        
                %again check before storing
        if abs(new_cen_2(index2(index3(1)),2)-indexed(i,j-1,2))<30 & abs(new_cen_2(index2(index3(1)),1)-indexed(i+1,j,1))<30
        indexed(i,j,1)= new_cen_2(index2(index3(1)),1); 
        indexed(i,j,2)= new_cen_2(index2(index3(1)),2);   
               
       new_cen_2(index2(index3(1)),1)=999999999999;  new_cen_2(index2(index3(1)),2)=999999999999;
        
       else
       indexed(i,j,1)= indexed(i+1,j,1); 
        indexed(i,j,2)= indexed(i,j-1,2);
        end
        
         
        end
end
end    


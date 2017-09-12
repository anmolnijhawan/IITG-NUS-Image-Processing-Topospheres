image=uint8(imageStack(:,:,13));
image=uint8(c);
figure;
imshow(image);
max=0;
image=edge(image,'canny');
image=uint8(image);
for i=9%5:9
    [centers, radii] = imfindcircles(imageStack(:,:,i),[45,65]);%,'ObjectPolarity','dark','Sensitivity',1,'EdgeThreshold',0.3);
    tmp=size(centers);
    tmp=tmp(1);
    if tmp>max
    cir_cen=centers;
    cir_rad=radii;
    z_axis=i;
    max=tmp;
    end
end
no_of_cir=size(cir_cen);
no_of_cir=no_of_cir(1);
radii=radii(1:626);
%viscircles(cen,radii,'EdgeColor','b');
new_cord_1=zeros(25,2);
new_cord_2=zeros(25,2);

if no_of_cir>0
    cir_cen_tmp=cir_cen;
    [X,Y]=meshgrid(cir_cen_tmp(:,1),cir_cen_tmp(:,2));
    delta_X=X-X';
    delta_Y=Y-Y';
    dist=hypot(delta_X,delta_Y);
    dist=dist+(eye(no_of_cir)*10000);
    [xi,yi]=find(dist==min(dist(:)));
    cir_1=cir_cen(xi(1),:);
    cir_2=cir_cen(xi(2),:);
    cir_dif=cir_2-cir_1;
    cir_dif=cir_dif/norm(cir_dif);
    orth_vec=null(cir_dif(:).');
    for i=1:25
       if i<15 
           tmp=(cir_dif*150*i)+cir_1;
       else
            tmp=(cir_dif*150*i)+cir_1+20; 
       end
       if (tmp(1)>50 && tmp(1)<4640 && tmp(2)>50 && tmp(2)<4640)
           new_cord_1(i,:)=tmp;
       end
    end
    
    for i=1:25
        if i<15
            tmp=(-cir_dif*150*i)+cir_1;
        else
            tmp=(-cir_dif*150*i)+cir_1+20;   
        end
       if (tmp(1)>50 && tmp(1)<4640 && tmp(2)>50 && tmp(2)<4640)
           new_cord_2(i,:)=tmp;
       end
    end
    
end

for i=1:25
    if(new_cord_1(i,1)>0)
        if(i<5)
           new_cord=new_cord_1(i,:)-[64 64]; 
        elseif (i>5 && i<9)
           new_cord=new_cord_1(i,:)-[54 54]; 
        else
            new_cord=new_cord_1(i,:)-[45 45];
        end
        
        if(new_cord(1)>20 && (new_cord(1)+128)<4690 && new_cord(2)>20 && (new_cord(2)+128)<4690)
        im1=imcrop(imageStack(:,:,z_axis),[new_cord(1) new_cord(2) 128 128]);
        variance=var(im1(:));
        if(variance>2000)
        im1=uint8(im1);
        figure;
        imshow(im1);
        end
        end
    end
end


for i=1:25
    if(new_cord_2(i,1)>0)
        if(i<5)
           new_cord=new_cord_2(i,:)-[64 64]; 
        elseif (i>10 && i<15)
           new_cord=new_cord_2(i,:)-[54 54]; 
        else
            new_cord=new_cord_2(i,:)-[45 45];
        end
        
        if(new_cord(1)>20 && (new_cord(1)+128)<4690 && new_cord(2)>20 && (new_cord(2)+128)<4690)
        im1=imcrop(imageStack(:,:,z_axis),[new_cord(1) new_cord(2) 128 128]);
        variance=var(im1(:));
        if(variance>2000)
        im1=uint8(im1);
        figure;
        imshow(im1);
        end
        end
    end
end
c=double(c);
new_im=zeros(4660,4672,3);
siz=size(centres1);
new_cen=zeros(siz(1),2);
for i=1:siz(1)
    new_cor=centres1(i,:);
    new_cor1=new_cor-[64 64];
        im1=imcrop(c,[new_cor1(1) new_cor1(2) 128 128]);
        variance=var(im1(:));
        if(variance>2000)
            new_cen(i,:)=new_cor;
            new_cor(2)=round(new_cor(2));
            new_cor(1)=round(new_cor(1));
        new_im(new_cor(1),new_cor(2),1)=255; 
        new_im(new_cor(1),new_cor(2),2)=new_cor(1);
        new_im(new_cor(1),new_cor(2),3)=new_cor(2);
        new_im(new_cor(1),new_cor(2),4)=radii(i);

        %im1=uint8(im1);
        %figure;
        %imshow(im1);
        end
    
end
new_cen_x=unique(new_cen(:,1));
new_cen_y=unique(new_cen(:,2));
new_cen_x=new_cen_x(2:size(new_cen_x));
new_cen_y=new_cen_y(2:size(new_cen_y));
cen=[new_cen_x new_cen_y];

[X,Y]=meshgrid(cir_cen_tmp(:,1),cir_cen_tmp(:,2));
    delta_X=X-X';
    delta_Y=Y-Y';
    dist=hypot(delta_X,delta_Y);
    dist=dist+(eye(no_of_cir)*10000);
    [xi,yi]=find(dist==min(dist(:)));
    cir_1=cir_cen(xi(1),:);
    cir_2=cir_cen(xi(2),:);
    cir_dif=cir_2-cir_1;
    


new_co1=2035-64;
new_co2=1106-64;
im1=imcrop(c,[new_co1 new_co2 128 128]);
 im1=double(im1);
 im2=uint8(im1);
        variance=var(im1(:));
        imshow(im2);


        
%load imgs
[img_zero,map1]=imread('x-ray-skull-from-right-side_0.jpg');
[img_one,map2]=imread('x-ray-skull-from-right-side_1.bmp');
colormap(map1);
colormap(map2);
img_zero=double(img_zero);
img_one=double(img_one);

%imshow loaded imgs
figure(1);
subplot(1,2,1), imshow(uint8(img_zero));
title('obraz oryginalny');
subplot(1,2,2), imshow(uint8(img_one));
title('obraz uszkodzony');

%RGB of the input images
img_zero_R=img_zero(:,:,1);
img_zero_G=img_zero(:,:,2);
img_zero_B=img_zero(:,:,3);
img_one_R=img_one(:,:,1);
img_one_G=img_one(:,:,2);
img_one_B=img_one(:,:,3);

%colour to grey
img_zero_grey=img_zero; %grey image initialisation
img_one_grey=img_one; %grey image initialisation

img_zero_grey(:,:,1)=(img_zero_R+img_zero_G+img_zero_B)/3; %RGB2grey
img_zero_grey(:,:,2)=img_zero_grey(:,:,1);
img_zero_grey(:,:,3)=img_zero_grey(:,:,1);
img_one_grey(:,:,1)=(img_one_R+img_one_G+img_one_B)/3; %RGB2grey
img_one_grey(:,:,2)=img_one_grey(:,:,1);
img_one_grey(:,:,3)=img_one_grey(:,:,1);
%imshow GREYSCALE
figure(2);
subplot(1,2,1), imshow(uint8(img_zero_grey));
title('obraz oryginalny GREYSCALE');
subplot(1,2,2), imshow(uint8(img_one_grey));
title('obraz uszkodzony GREYSCALE');

%GREYSCALE histograms
zero_hist=zeros(1,256);
one_hist=zeros(1,256);
[w,k,n]=size(img_one_grey);
    %calculation loop
for i=1:w
    for j=1:k
        if(img_zero_grey(i,j)>=0) && (img_zero_grey(i,j)<256)
            zero_hist(floor(img_zero_grey(i,j)+1))=zero_hist(floor(img_zero_grey(i,j)+1))+1;
        end
        if(img_one_grey(i,j)>=0) && (img_one_grey(i,j)<256)
            one_hist(round(img_one_grey(i,j)))=round(one_hist(round(img_one_grey(i,j)))+1);
        end
    end
end

%show GREYSCALE histograms
figure(3)
subplot(1,2,1), plot(zero_hist);
title('obraz oryginalny GREYSCALE - histogram');
subplot(1,2,2), plot(one_hist);
title('obraz uszkodzony GREYSCALE - histogram');

%cumulative histogram of img one
cumulative_one=zeros(1,256);
cumulative_one(1)=one_hist(1);
for k=2:256
    cumulative_one(k)=cumulative_one(k-1)+one_hist(k);
end

%histogram equalization of img one
one_eq=img_one_grey;
[row,col,deep]=size(one_eq);
for m=1:row
    for n=1:col
        for b=1:deep
        if img_one_grey(m,n,b)<0
            one_eq=0;
        elseif img_one_grey(m,n,b)>255
            one_eq=255;
        else
            one_eq(m,n,b)=round((round(255*cumulative_one(round(img_one_grey(m,n,b)))))/cumulative_one(256));
            
        end  
        end
    end
end

%histogram normalization & contrast+brightness RGB
L1=min(img_one(:));
L2=max(img_one(:));
Lmax=255;

[w,k,n]=size(img_one);
for i=1:w
    for j=1:k
        for l=1:n
            one_norm(i,j,l)=((Lmax*(double(img_one(i,j,l))-L1)/(L2-L1)));
            if(one_norm(i,j,l) <0)
               one_norm(i,j,l)=0;
            end
            if (one_norm(i,j,l)>255)
               one_norm(i,j,l)=255;
              
            end
        end
    end
end
    %c+b
c=Lmax/(L2-L1);
b=-(L1*Lmax)/(L2-L1);

one_conbri=img_one;
for i=1:w
    for j=1:k
        for l=1:n
            one_conbri(i,j,l)=c*(double(img_one(i,j,l)))+b;
             if one_conbri(i,j,l)<0
                 one_conbri(i,j,l)=0;
             end
             if one_conbri(i,j,l)>255
                one_conbri(i,j,l)=255;
             end
        end
    end
end

%histogram normalization & contrast+brightness GREY
L1=min(img_one_grey(:));
L2=max(img_one_grey(:));
Lmax=255;

[w,k,n]=size(img_one_grey);
for i=1:w
    for j=1:k
        one_norm_grey(i,j,1)=((Lmax*(double(img_one_grey(i,j))-L1)/(L2-L1)));
        if(one_norm_grey(i,j) <0)
           one_norm_grey(i,j)=0;
        end
        if (one_norm_grey(i,j)>255)
           one_norm_grey(i,j)=255;     
        end
    end
end
one_norm_grey(:,:,2)=one_norm_grey(:,:,1);
one_norm_grey(:,:,3)=one_norm_grey(:,:,1);

    %c+b
c=Lmax/(L2-L1);
b=-(L1*Lmax)/(L2-L1);

one_conbri_grey=img_one_grey;
for i=1:w
    for j=1:k
       one_conbri_grey(i,j,1)=c*(double(img_one_grey(i,j,1)))+b;
        if one_conbri_grey(i,j) <0
           one_conbri_grey(i,j)=0;
        end
        if one_conbri_grey(i,j)>255
           one_conbri_grey(i,j)=255;
        end
    end
end
one_conbri_grey(:,:,2)=one_conbri_grey(:,:,1);
one_conbri_grey(:,:,3)=one_conbri_grey(:,:,1);

%imshow EQUALIZATION
figure(4);
imshow(uint8(one_eq));
title('wyrównany');
%NORMALIZATION, CONTRAST&BRIGHTNESS RGB + GREY 
figure(5);
subplot(2,3,1), imshow(uint8(img_one));
title('obraz wejsciowy RGB');
subplot(2,3,2), imshow(uint8(one_norm));
title('znormalizowany RGB');
subplot(2,3,3), imshow(uint8(one_conbri));
title('contrast&brightness RGB');
subplot(2,3,4), imshow(uint8(img_one_grey));
title('obraz wejsciowy GREY');
subplot(2,3,5), imshow(uint8(one_norm_grey));
title('znormalizowany GREY');
subplot(2,3,6), imshow(uint8(one_conbri_grey));
title('contrast&brightness GREY');

difeqgrey=img_one_grey;
difnormgrey=img_one_grey;
dif4cbrey=img_one_grey;
difeq=img_one;
difnorm=img_one;
dif4cb=img_one;
for i=1:w
    for j=1:k
        for p=1:n
            %grey
           difeqgrey(i,j,p)= abs(img_zero_grey(i,j,p)-one_eq(i,j,p)); 
           difnormgrey(i,j,p)= abs(img_zero_grey(i,j,p)-one_norm_grey(i,j,p));
           dif4cbrey(i,j,p)= abs(img_zero_grey(i,j,p)-one_conbri_grey(i,j,p));
           %rgb
           difeq(i,j,p)= abs(img_zero(i,j,p)-one_eq(i,j,p)); 
           difnorm(i,j,p)= abs(img_zero(i,j,p)-one_norm(i,j,p));
           dif4cb(i,j,p)= abs(img_zero(i,j,p)-one_conbri(i,j,p));
       end
    end
end

%normalize grey differences
L1=min(difeqgrey(:));
L2=max(difeqgrey(:));
Lmax=255;

[w,k,n]=size(difeqgrey);
for i=1:w
    for j=1:k
        difeqgrey(i,j,1)=((Lmax*(double(difeqgrey(i,j))-L1)/(L2-L1)));
        if(difeqgrey(i,j) <0)
           difeqgrey(i,j)=0;
        end
        if (difeqgrey(i,j)>255)
           difeqgrey(i,j)=255;     
        end
    end
end
difeqgrey(:,:,2)=difeqgrey(:,:,1);
difeqgrey(:,:,3)=difeqgrey(:,:,1);

L1=min(difnormgrey(:));
L2=max(difnormgrey(:));
Lmax=255;

[w,k,n]=size(difnormgrey);
for i=1:w
    for j=1:k
        difnormgrey(i,j,1)=((Lmax*(double(difnormgrey(i,j))-L1)/(L2-L1)));
        if(difnormgrey(i,j) <0)
           difnormgrey(i,j)=0;
        end
        if (difnormgrey(i,j)>255)
           difnormgrey(i,j)=255;     
        end
    end
end
difnormgrey(:,:,2)=difnormgrey(:,:,1);
difnormgrey(:,:,3)=difnormgrey(:,:,1);

L1=min(dif4cbrey(:));
L2=max(dif4cbrey(:));
Lmax=255;

[w,k,n]=size(dif4cbrey);
for i=1:w
    for j=1:k
        dif4cbrey(i,j,1)=((Lmax*(double(dif4cbrey(i,j))-L1)/(L2-L1)));
        if(dif4cbrey(i,j) <0)
           dif4cbrey(i,j)=0;
        end
        if (dif4cbrey(i,j)>255)
           dif4cbrey(i,j)=255;     
        end
    end
end
dif4cbrey(:,:,2)=dif4cbrey(:,:,1);
dif4cbrey(:,:,3)=dif4cbrey(:,:,1);

%normalize rgb differences

L1=min(difeq(:));
L2=max(difeq(:));
Lmax=255;

[w,k,n]=size(difeq);
for i=1:w
    for j=1:k
        for l=1:n
            difeq(i,j,l)=((Lmax*(double(difeq(i,j,l))-L1)/(L2-L1)));
            if(difeq(i,j,l) <0)
               difeq(i,j,l)=0;
            end
            if (difeq(i,j,l)>255)
               difeq(i,j,l)=255;
              
            end
        end
    end
end

L1=min(difnorm(:));
L2=max(difnorm(:));
Lmax=255;

[w,k,n]=size(difnorm);
for i=1:w
    for j=1:k
        for l=1:n
            difnorm(i,j,l)=((Lmax*(double(difnorm(i,j,l))-L1)/(L2-L1)));
            if(difnorm(i,j,l) <0)
               difnorm(i,j,l)=0;
            end
            if (difnorm(i,j,l)>255)
               difnorm(i,j,l)=255;
              
            end
        end
    end
end

L1=min(dif4cb(:));
L2=max(dif4cb(:));
Lmax=255;

[w,k,n]=size(dif4cb);
for i=1:w
    for j=1:k
        for l=1:n
            dif4cb(i,j,l)=((Lmax*(double(dif4cb(i,j,l))-L1)/(L2-L1)));
            if(dif4cb(i,j,l) <0)
               dif4cb(i,j,l)=0;
            end
            if (dif4cb(i,j,l)>255)
               dif4cb(i,j,l)=255;
              
            end
        end
    end
end

%show differences
figure(6);
subplot(1,3,1), imshow(uint8(difeqgrey));
title('ROZNICA GREY-WYROWNANIE(znormalizowana)');
subplot(1,3,2), imshow(uint8(difnormgrey));
title('ROZNICA GREY-NORMALIZACJA(znormalizowana)');
subplot(1,3,3), imshow(uint8(dif4cbrey));
title('ROZNICA GREY-CONTRAST&BRIGHTNESS(znormalizowana)');
figure(7);
subplot(1,3,1), imshow(uint8(difeq));
title('ROZNICA RGB-WYROWNANIE(znormalizowana)');
subplot(1,3,2), imshow(uint8(difnorm));
title('ROZNICA RGB-NORMALIZACJA(znormalizowana)');
subplot(1,3,3), imshow(uint8(dif4cb));
title('ROZNICA RGB-CONTRAST&BRIGHTNESS(znormalizowana)');

%lena mask on xray img

[xray,map]=imread('x-ray-skull-from-right-side_0.jpg');
colormap(map);
xray=double(xray); %double precision
[row, col, deep]=size(xray); %image size

[logo, map]=imread('logo.bmp');
colormap(map);
logo=double(logo);
[row2, col2, deep2]=size(logo);

[lena, map]=imread('lena.bmp');
colormap(map);
lena=double(lena);
[row3, col3, deep3]=size(lena);

%create mask with lena texture
for i=1:row2
    for j=1:col2
        for k=1:deep2
            if logo(i,j,k)~=0
                lena(i,j,k)=0;
            end
        end
    end
end

for i=1:row
    for j=1:col
        for k=1:deep
            if lena(i,j,k)~=0
                xray(i,j,k)=0.25*lena(i,j,k)+round(1-0.25)*xray(i,j,k);
            end
        end
    end
end

figure(8);
imshow(uint8(xray));
title("maska z Leny na obrazie (25% opacity)");

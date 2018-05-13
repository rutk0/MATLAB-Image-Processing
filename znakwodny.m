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

imshow(uint8(xray));

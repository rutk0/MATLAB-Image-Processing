%load image
[img, map1]=imread('hand.jpg');
colormap(map1);
img=double(img);
img_negacja=255-img;

%R wymiar maski( macierz kwadratora RxR )
R=5;
odstep=floor(R/2);

%erozja(I)
[w, k, n]=size(img);
img_erozja=img;

 %kanaly
 for c=1:n
     %wiersze
    for wiersz=odstep+1:w-odstep
        %kolumny
        for kolumna=odstep+1:k-odstep
            fragment=img(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
            wektor=fragment(:);
            img_erozja(wiersz,kolumna,c)=min(wektor);
        end
    end
 end

%dylatacja(~I)
[w,k,n]=size(img_negacja);
img_dylatacja_neg=img_negacja;

 %kanaly
 for c=1:n
     %wiersze
    for wiersz=odstep+1:w-odstep
        %kolumny
        for kolumna=odstep+1:k-odstep
            fragment=img_negacja(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
            wektor=fragment(:);
            img_dylatacja_neg(wiersz,kolumna,c)=max(wektor);
        end
    end
 end

%roznica erozji i negacji dylatacji z negacji obrazu
roznica_ero_neg=img_erozja-(255-img_dylatacja_neg);

%otwarcie (erozja->dylatacja) - erozja juz zrobiona dzialamy na nia
%dylatacja
[w,k,n]=size(img);
img_otw=img;

 %kanaly
 for c=1:n
     %wiersze
    for wiersz=odstep+1:w-odstep
        %kolumny
        for kolumna=odstep+1:k-odstep
            fragment=img_erozja(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
            wektor=fragment(:);
            img_otw(wiersz,kolumna,c)=max(wektor);
        end
    end
 end

 %otwarcie otwarcia - na otwarcie dzialamy kolejno erozja i dylatacja
 [w,k,n]=size(img_otw);
 otw_ero=img_otw;
 %erozja
 %kanaly
  for c=1:n
     %wiersze
    for wiersz=odstep+1:w-odstep
        %kolumny
        for kolumna=odstep+1:k-odstep
            fragment=img_otw(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
            wektor=fragment(:);
            otw_ero(wiersz,kolumna,c)=min(wektor);
        end
    end
  end
 
 %dylatacja
 [w,k,n]=size(otw_ero);
 otw_otw=otw_ero;
 %kanaly
 for c=1:n
     %wiersze
    for wiersz=odstep+1:w-odstep
        %kolumny
        for kolumna=odstep+1:k-odstep
            fragment=otw_ero(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
            wektor=fragment(:);
            otw_otw(wiersz,kolumna,c)=max(wektor);
        end
    end
 end

roznica_otwotw_otw=otw_otw-img_otw;


%porown. wart px dla E, O, Z, D

    %erozja
    %img_erozja
    %otwarcie
    %img_otw
    %zamkniecie
        %dylatacja
         [w,k,n]=size(img);
         dyla_zamk=img;
         %kanaly
         for c=1:n
             %wiersze
            for wiersz=odstep+1:w-odstep
                %kolumny
                for kolumna=odstep+1:k-odstep
                    fragment=img(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                    wektor=fragment(:);
                    dyla_zamk(wiersz,kolumna,c)=max(wektor);
                end
            end
         end
         %erozja
        [w, k, n]=size(dyla_zamk);
        zamk_finish=img;

         %kanaly
         for c=1:n
             %wiersze
            for wiersz=odstep+1:w-odstep
                %kolumny
                for kolumna=odstep+1:k-odstep
                    fragment=dyla_zamk(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                    wektor=fragment(:);
                    zamk_finish(wiersz,kolumna,c)=min(wektor);
                end
            end
         end
         
 %dylatacja
         [w,k,n]=size(img);
         img_dylatacja=img;

         %kanaly
             for c=1:n
                 %wiersze
                for wiersz=odstep+1:w-odstep
                    %kolumny
                    for kolumna=odstep+1:k-odstep
                        fragment=img(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                        wektor=fragment(:);
                        img_dylatacja(wiersz,kolumna,c)=max(wektor);
                    end
                end
             end
         
figure(1);
subplot(1,3,1);
imshow(uint8(255-img_dylatacja_neg));
title('negacja dylatacji z negacji obrazu');
subplot(1,3,2);
imshow(uint8(img_erozja));
title('erozja');
subplot(1,3,3);
imshow(uint8(roznica_ero_neg));
title('roznica erozji i neg z dylat. z neg. obrazu');

figure(2);
subplot(1,2,1);
imshow(uint8(img_otw));
title('otwarcie');
subplot(1,2,2);
imshow(uint8(roznica_otwotw_otw));
title('roznica otwarcie otwarcia z otwarciem');

figure(3);
subplot(1,4,1);
imshow(uint8(img_erozja));
title(sum(sum(img_erozja)));
subplot(1,4,2);
imshow(uint8(img_otw));
title(sum(sum(img_otw)));
subplot(1,4,3);
imshow(uint8(zamk_finish));
title(sum(sum(zamk_finish)));
subplot(1,4,4);
imshow(uint8(img_dylatacja));
title(sum(sum(img_dylatacja)));




% otwarcie zamkniecia
    %erozja zamkniecia
    ero_zamk=zamk_finish;
    %kanaly
         for c=1:n
             %wiersze
            for wiersz=odstep+1:w-odstep
                %kolumny
                for kolumna=odstep+1:k-odstep
                    fragment=zamk_finish(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                    wektor=fragment(:);
                    ero_zamk(wiersz,kolumna,c)=min(wektor);
                end
            end
         end
      %dylatacja erozji zamkniecia
      dyla_ero_zamk=ero_zamk;
       %kanaly
         for c=1:n
             %wiersze
            for wiersz=odstep+1:w-odstep
                %kolumny
                for kolumna=odstep+1:k-odstep
                    fragment=ero_zamk(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                    wektor=fragment(:);
                    dyla_ero_zamk(wiersz,kolumna,c)=max(wektor);
                end
            end
         end
         
 % zamkniecie otwarcia zamkniecia

        %dylatacja
        
         dyla_otw=dyla_ero_zamk;
         %kanaly
         for c=1:n
             %wiersze
            for wiersz=odstep+1:w-odstep
                %kolumny
                for kolumna=odstep+1:k-odstep
                    fragment=dyla_ero_zamk(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                    wektor=fragment(:);
                    dyla_otw(wiersz,kolumna,c)=max(wektor);
                end
            end
         end
        %erozja
        ero_otw=dyla_otw;

         %kanaly
         for c=1:n
             %wiersze
            for wiersz=odstep+1:w-odstep
                %kolumny
                for kolumna=odstep+1:k-odstep
                    fragment=dyla_otw(wiersz-odstep:wiersz+odstep, kolumna-odstep:kolumna+odstep,c);
                    wektor=fragment(:);
                    ero_otw(wiersz,kolumna,c)=min(wektor);
                end
            end
         end
         
         
         %min src i z(o(z(src)))
         otw_wlasc=img;
        for c=1:n
             %wiersze
            for wiersz=1:w
                %kolumny
                for kolumna=1:k
                    otw_wlasc(wiersz, kolumna, c)=min(img(wiersz,kolumna,c),ero_otw(wiersz,kolumna,c)); 
                end
            end
         end 
 
figure(4);
imshow(uint8(otw_wlasc));
title('otwarcie wlasciwe');
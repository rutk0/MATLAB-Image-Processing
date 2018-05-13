%load img
[obraz, map1]=imread('hand.jpg');
colormap(map1);
obraz=double(obraz);
[w,k,n]=size(obraz);

%obliczanie filtru dolnoprzepustowego
maska_dolnoprzepustowy=[1,2,1; 
                        2,4,2; 
                        1,2,1];
suma_maski=sum(sum(maska_dolnoprzepustowy));
obraz_dolnoprzepustowy=zeros(w,k,n);

    %R wymiar maski( macierz kwadratora RxR )
    R=3;
    N=floor(R/2);
    
 %kanaly
 for c=1:n
     %wiersze
    for wiersz=N+1:w-N
        %kolumny
        for kolumna=N+1:k-N
            fragment=obraz(wiersz-N:wiersz+N, kolumna-N:kolumna+N,c);
            fragment=fragment.*maska_dolnoprzepustowy;
            fragment=fragment/suma_maski;
            obraz_dolnoprzepustowy(wiersz,kolumna,c)=sum(sum(fragment));
        end
    end
 end

%krawedziowanie z u¿yciem filtru górnoprzepustowego
maska_gornoprzepustowy=[-1,-1,-1; 
                        -1,8,-1; 
                        -1,-1,-1];
obraz_gornoprzepustowy=zeros(w,k,n);

    %R wymiar maski( macierz kwadratora RxR )
    R=3;
    N=floor(R/2);
    
%kanaly
for c=1:n
    %wiersze
    for wiersz=N+1:w-N
        %kolumny
        for kolumna=N+1:k-N
            fragment=obraz(wiersz-N:wiersz+N, kolumna-N:kolumna+N,c);
            fragment=fragment.*maska_gornoprzepustowy;
            obraz_gornoprzepustowy(wiersz,kolumna,c)=sum(sum(fragment));
        end
    end
end
    %normalizacja
obraz_gornoprzepustowy=abs(obraz_gornoprzepustowy);
Lmax=255;
[w,k,n]=size(obraz_gornoprzepustowy);
for l=1:n
    L1=min(min(obraz_gornoprzepustowy(:,:,n)));
    L2=max(max(obraz_gornoprzepustowy(:,:,n)));
    for i=1:w
        for j=1:k
            obraz_gornoprzepustowy_znormalizowany(i,j,l)=((Lmax*(double(obraz_gornoprzepustowy(i,j,l))-L1)/(L2-L1)));
        end
    end
end

%filtr medianowy
obraz_medianowy=zeros(w,k,n);

    %R wymiar maski
    R=10;
    N=floor(R/2);
    
%kanaly
for c=1:n
    %wiersze
    for wiersz=N+1:w-N
        %kolumny
        for kolumna=N+1:k-N
            fragment=obraz(wiersz-1:wiersz+1, kolumna-1:kolumna+1, c);
            wektor=[];
            for l=1:n
                wektor=[wektor, fragment(l,:)];
            end
            posortowany_wektor=sort(wektor);
            obraz_medianowy(wiersz,kolumna,c)=posortowany_wektor(ceil(max(size(posortowany_wektor))/2));
        end
    end
end
figure(1);
subplot(1,3,1)
imshow(uint8(obraz));title('obraz wejsciowy');
subplot(1,3,2)
imshow(uint8(obraz_dolnoprzepustowy));title('filtr dolnoprzepustowy');
subplot(1,3,3)
imshow(uint8(obraz_medianowy));title('filtr medianowy');
figure(2);
imshow(uint8(255-obraz_gornoprzepustowy_znormalizowany));title('krawêdziowanie');


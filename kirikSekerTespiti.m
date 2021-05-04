 clc, close all,clear all;

rgbGoruntu = imread("sekerler.bmp");
figure, imshow(rgbGoruntu)

griGoruntu = rgb2gray(rgbGoruntu); %Görüntüyü gri görüntüye dönüþtürdük
figure, imshow(griGoruntu)

se = strel('disk', 16);
arkaPlan = imclose(griGoruntu, se); %Closing(kapatma) iþlemi uygulayarak arkaplaný elde ettik
figure, imshow(arkaPlan)

farkGoruntu = imsubtract(arkaPlan, griGoruntu); %arkaPlan ile griGoruntu yu çýkartarak nesneleri elde ettik
figure, imshow(farkGoruntu)

imgSekerlerSB = imbinarize(farkGoruntu); %Çýkarmadan geriye kalan görüntüyü binary görünüye dönüþtürdük
figure, imshow(imgSekerlerSB)

imgSekerlerSB = imfill(imgSekerlerSB, 'holes'); % Nesneler içerisindeki boþluklarý kapattýk
figure,imshow(imgSekerlerSB)

[etiketler, nesneSayisi] = bwlabel(imgSekerlerSB, 4);
nesneVerileri = regionprops(etiketler, 'Eccentricity', 'Area', 'BoundingBox');

alanDegerleri = [nesneVerileri.Area];
tuhafliklar = [nesneVerileri.Eccentricity];

minAlan = mean(alanDegerleri) - 0.25*std(alanDegerleri);

bozukAlanIndexleri = find(alanDegerleri < minAlan & tuhafliklar > 0.5);
bozukVeriler = nesneVerileri(bozukAlanIndexleri);

figure;
imshow(rgbGoruntu);
hold on

for i = 1:length(bozukAlanIndexleri)
    rect = rectangle('position', bozukVeriler(i).BoundingBox, 'LineWidth', 2);
    set(rect, 'EdgeColor', [0 0 1]);
end

hold off

clc;
clear all;
close all;


%% Extrae los circulos solidos 
%puede utilizarse para funcion
alfabeto = imread('Alfabeto.jpg');
Im_base = imread('imagen_10.jpg');
Im_gray= rgb2gray(Im_base);
Im_base = uint8(Im_base);
%%figure,imshow(Im_gray);

Im_bw = im2bw(Im_gray,0.4);
%figure,imshow(Im_bw);
Contornos_im = edge(Im_bw,'sobel');
figure,imshow(alfabeto);
%limpia_bordes = imclearborder(Contornos_im);
%figure,imshow(Im_bw);

llena_hollos = imfill(Contornos_im,'holes');
circulo_solido = bwareaopen(llena_hollos,1200);
%figure,imshow(circulo_solido);

circulo_solido =im2double(circulo_solido);
circulo_solido =im2uint8(circulo_solido);

%% Operacion logica extraccion de las señas
%%notBW = not(circulo_solido);
Im_signs = bitand(Im_gray,circulo_solido);
%figure,imshow(Im_signs);

% ImS_bw = im2bw(Im_signs,0.7);%%probale con 0.7
% figure,imshow(ImS_bw);
% Im_skel = bwmorph(Im_bw,'skel',Inf);
% imshow(Im_skel);

Im_bw = im2uint8(Im_bw);
Im_letras = Im_bw - circulo_solido;



%% Separa las regiones para buscar los momentos hu
label = bwlabel(circulo_solido);
%stats = regionprops(label,'all');


for numerodeObjetos = 1:max(max(label))
    [row, col] = find(label==numerodeObjetos);
    len=max(row) -min(row)+2;
    breath = max(col)- min(col);
    target=uint8(zeros([len breath]));
    sy = min(col)-1;
    sx = min(row)-1;
    for i = 1:size(row,1)
        x = row(i,1)-sx;
        y = col(i,1)-sy;
        target(x,y) = Im_signs(row(i,1),col(i,1));
    end
    
    %mytitle= strcat('Objeto numero:', num2str(numerodeObjetos));
    %%figure,imshow(target);title(mytitle);
    
    
    %recopila los momentos de hu de cada zona circular de la imagen, esta
    %corresponde a una letra del alfabeto
    hu_momentos(numerodeObjetos,:) = invmoments(target);
  
    
end

load('image10.mat');
% palabra = hum(:,8);
% palabra =char(palabra);
% palabra =string(palabra);
% disp(palabra);
% 
% NET.addAssembly('System.Speech');
% obj = System.Speech.Synthesis.SpeechSynthesizer;
% obj.Volume = 100;
% Speak(obj, palabra);


%figure,imshow(circulo_solido);
title('Imagen con Círculos')
L = bwlabel(circulo_solido,8);
stats = regionprops(L,'all');

% circulo_solido = im2logical(circulo_solido);
% stats = regionprops(circulo_solido,'Perimeter','Area','Centroid','BoundingBox');

figure,imshow(Im_base);
hold on;

for k=1:length(stats)
    thisboundingBox =stats(k).BoundingBox;
    rectangle('Position',[thisboundingBox(1)...
        ,thisboundingBox(2),thisboundingBox(3)...
        ,thisboundingBox(4)],'EdgeColor','r','LineWidth',2 );
    
    text(stats(k).Centroid(1),stats(k).Centroid(2),'Text','Colo','r','FontSize',18);
    
    
end




%% Crear el array de letras 
%%convirtiendo a funcion codigo de texto
%%text = fileread('Letras.txt');
%%text = strrep(text,'l','I');
%text=upper(text);
%text= text(find(~isspace(text))),

% 
% for k = 1:length(text)
%  [Lets] = str(k);
%   
% end




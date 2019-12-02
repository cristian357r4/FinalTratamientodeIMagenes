function varargout = Gui_Proyecto_Final(varargin)
% GUI_PROYECTO_FINAL MATLAB code for Gui_Proyecto_Final.fig
%      GUI_PROYECTO_FINAL, by itself, creates a new GUI_PROYECTO_FINAL or raises the existing
%      singleton*.
%
%      H = GUI_PROYECTO_FINAL returns the handle to a new GUI_PROYECTO_FINAL or the handle to
%      the existing singleton*.
%
%      GUI_PROYECTO_FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PROYECTO_FINAL.M with the given input arguments.
%
%      GUI_PROYECTO_FINAL('Property','Value',...) creates a new GUI_PROYECTO_FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gui_Proyecto_Final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gui_Proyecto_Final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gui_Proyecto_Final

% Last Modified by GUIDE v2.5 02-Dec-2019 02:51:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gui_Proyecto_Final_OpeningFcn, ...
                   'gui_OutputFcn',  @Gui_Proyecto_Final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Gui_Proyecto_Final is made visible.
function Gui_Proyecto_Final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gui_Proyecto_Final (see VARARGIN)

% Choose default command line output for Gui_Proyecto_Final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gui_Proyecto_Final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gui_Proyecto_Final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_iniciarProceso.
function btn_iniciarProceso_Callback(hObject, eventdata, handles)
% hObject    handle to btn_iniciarProceso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Im = handles.im_base;
num = handles.im_num;
axes(handles.imagen_resultante);

pause(1);

Im_gray= rgb2gray(Im);
Im = uint8(Im);
imshow(Im_gray);
pause(1);
Im_bw = im2bw(Im_gray,0.4);
imshow(Im_bw);
pause(1);
Contornos_im = edge(Im_bw,'sobel');

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
imshow(Im_signs);
pause(1);

% ImS_bw = im2bw(Im_signs,0.7);%%probale con 0.7
% figure,imshow(ImS_bw);
% Im_skel = bwmorph(Im_bw,'skel',Inf);
% imshow(Im_skel);

Im_bw = im2uint8(Im_bw);
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
    
L = bwlabel(circulo_solido,8);
stats = regionprops(L,'all');

% circulo_solido = im2logical(circulo_solido);
% stats = regionprops(circulo_solido,'Perimeter','Area','Centroid','BoundingBox');

imshow(Im);
hold on;
    
switch(num)
    case 1
        load('image1.mat');
        palabra = imagen_01(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
    case 2
        load('image2.mat');
        palabra = imagen_02(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 3
        load('image3.mat');
        palabra = imagen_03(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 4
        load('image4.mat');
        palabra = imagen_04(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 5
        load('image5.mat');
        palabra = imagen_05(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 6
        load('image6.mat');
        palabra = imagen_06(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 7
        load('image7.mat');
        palabra = imagen_07(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 8
        load('image8.mat');
        palabra = imagen_08(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 9
        load('image9.mat');
        palabra = imagen_09(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);
     case 10
        load('image10.mat');
        palabra = imagen_10(:,8);
        palabra =char(palabra);
        palabra =string(palabra);
        NET.addAssembly('System.Speech');
        obj = System.Speech.Synthesis.SpeechSynthesizer;
        obj.Volume = 100;
        Speak(obj, palabra);

end
for k=1:length(stats)
    thisboundingBox =stats(k).BoundingBox;
    rectangle('Position',[thisboundingBox(1)...
        ,thisboundingBox(2),thisboundingBox(3)...
        ,thisboundingBox(4)],'EdgeColor','r','LineWidth',2 );
    text(stats(k).Centroid(1),stats(k).Centroid(2),palabra(k),'Colo','b','FontSize',18);

end

 %% 
    


% --- Executes on button press in image_chooser.
function image_chooser_Callback(hObject, eventdata, handles)
% hObject    handle to image_chooser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alfabeto = imread('Alfabeto.jpg');
axes(handles.imagen_alfabeto);
imshow(alfabeto);




% --- Executes on button press in btn_imagen1.
function btn_imagen1_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_01.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=1;
guidata(hObject,handles);


% --- Executes on button press in btn_imagen2.
function btn_imagen2_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_02.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=2;
guidata(hObject,handles);

% --- Executes on button press in btn_imagen3.
function btn_imagen3_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_03.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=3;
guidata(hObject,handles);

% --- Executes on button press in btn_imagen4.
function btn_imagen4_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_04.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=4;
guidata(hObject,handles);


% --- Executes on button press in btn_imagen5.
function btn_imagen5_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_05.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=5;
guidata(hObject,handles);

% --- Executes on button press in btn_imagen6.
function btn_imagen6_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_06.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=6;
guidata(hObject,handles);

% --- Executes on button press in btn_imagen7.
function btn_imagen7_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_07.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=7;
guidata(hObject,handles);

% --- Executes on button press in btn_imagen9.
function btn_imagen9_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_09.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=9;
guidata(hObject,handles);


% --- Executes on button press in btn_imagen10.
function btn_imagen10_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_10.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=10;
guidata(hObject,handles);
% --- Executes on button press in btn_imagen8.
function btn_imagen8_Callback(hObject, eventdata, handles)
% hObject    handle to btn_imagen8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_base = imread('imagen_08.jpg');
axes(handles.imagen_entrada);
imshow(image_base);
handles.im_base=image_base;
handles.im_num=8;
guidata(hObject,handles);

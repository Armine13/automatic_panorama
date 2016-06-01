function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 30-May-2016 19:07:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)
global imgOut;

imgOut = [];
% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

[x,map]=imread('../icons/crop.png');
set(handles.cropButton, 'cdata',x);
[x,map]=imread('../icons/save.png');
set(handles.saveButton, 'cdata',x);
[x,map]=imread('../icons/start.png');
set(handles.startPlanar, 'cdata',x);
set(handles.startCylindrical, 'cdata',x);
set(handles.globeButton, 'cdata',x);
set(handles.sliderPan, 'Enable', 'off');
set(handles.sliderPan, 'Enable', 'on');    

set(handles.sliderMinPlanar, 'Min', 1);
set(handles.sliderMinPlanar, 'Max', 100);
set(handles.sliderMinPlanar, 'Value', 30);
set(handles.sliderMinPlanar, 'SliderStep', [1/(100-1) , 10/(100-1)]);

set(handles.sliderMinCylindrical, 'Min', 1);
set(handles.sliderMinCylindrical, 'Max', 100);
set(handles.sliderMinCylindrical, 'Value', 30);
set(handles.sliderMinCylindrical, 'SliderStep', [1/(100-1) , 10/(100-1)]);
% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browseButton.
function browseButton_Callback(hObject, eventdata, handles)
global imageArray;
global imgOut;

% fileNames = {};
if (get(handles.filesRadio,'Value') == 1),
    
    [fileNames, paths] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
        '*.*','All Files' },'Open Image','MultiSelect', 'on');
    if paths == 0, return; end; 
    if iscellstr(fileNames),
        N = numel(fileNames);
    else
        imageArray = {};
        imgOut = {};
        return;
    end
    
    for i = 1: N,
        fileNames{i} = strcat(paths, fileNames{i});
    end
end

if (get(handles.dirRadio,'Value') == 1),
    
    folder_name = uigetdir;
    if folder_name == 0, return; end; 
    fileNames = getAllFiles(folder_name);
end

if (get(handles.radioVideo,'Value') == 1),
    [file, filePath] = uigetfile({'*.avi;*.mp4;*.mov','All Video Files';...
        '*.*','All Files' },'Open Video');
    if file == 0, return; end; 
    file = strcat(filePath, file);
    fileNames = videoToImages(file);
end

if ~isempty(fileNames) && numel(fileNames) > 1,
    imageArray = {};
    imgOut = {};
    N = numel(fileNames);
    for i = 1: N,
        imageArray{i} = imread(fileNames{i});
    end
    imshow(imageArray{1}, 'parent', handles.axes1);
    set(handles.slider1, 'Min', 1);
    set(handles.slider1, 'Max', N);
    set(handles.slider1, 'Value', 1);
    set(handles.slider1, 'SliderStep', [1/(N-1) , 10/(N-1)]);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
global imageArray;

imIdx = int32(get(handles.slider1, 'Value'));
imshow(imageArray{imIdx}, 'parent', handles.axes1);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sliderPan_Callback(hObject, eventdata, handles)
global imgOut;

imIdx = int32(get(handles.sliderPan, 'Value'));
imshow(imgOut{imIdx}, 'parent', handles.axes2);
set(handles.panText, 'String', sprintf('( %d / %d )', imIdx, numel(imgOut)));

% --- Executes during object creation, after setting all properties.
function sliderPan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderPan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
global imgOut;

[file, path] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'Save Image');
if ~isempty(file),
    imIdx = int32(get(handles.sliderPan, 'Value'));
    if imIdx <= 0,
        imwrite(imgOut{1}, strcat(path, file));
    else
        imwrite(imgOut{imIdx}, strcat(path, file));
    end
end

% --- Executes during object creation, after setting all properties.
function saveButton_CreateFcn(hObject, eventdata, handles)


% --- Executes on slider movement.
function sliderMinPlanar_Callback(hObject, eventdata, handles)

n = int32(get(handles.sliderMinPlanar, 'Value'));
set(handles.planarMinText, 'String', num2str(n));


% --- Executes during object creation, after setting all properties.
function sliderMinPlanar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMinPlanar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in startPlanar.
function startPlanar_Callback(hObject, eventdata, handles)
global imageArray;
global imgOut;
if isempty(imageArray), return; end

n = int32(get(handles.sliderMinPlanar, 'Value'));
imgOut = planar(imageArray, n);

if ~isempty(imgOut),
    N = numel(imgOut);
    imshow(imgOut{1}, 'parent', handles.axes2);
    
    set(handles.panText, 'String', sprintf('( %d / %d )', 1, N));
    if N > 1,
    set(handles.sliderPan, 'Enable', 'on');    
    set(handles.sliderPan, 'Min', 1);
    set(handles.sliderPan, 'Max', N);
    set(handles.sliderPan, 'Value', 1);
    set(handles.sliderPan, 'SliderStep', [1/(N-1) , 10/(N-1)]);
    end
    if N == 1,
        set(handles.sliderPan, 'Enable', 'Off');
    end
end


% --- Executes on slider movement.
function sliderMinCylindrical_Callback(hObject, eventdata, handles)

n = int32(get(handles.sliderMinCylindrical, 'Value'))
set(handles.cylindricalMinText, 'String', num2str(n));


% --- Executes during object creation, after setting all properties.
function sliderMinCylindrical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMinCylindrical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in startCylindrical.
function startCylindrical_Callback(hObject, eventdata, handles)
global imageArray;
global imgOut;
if isempty(imageArray), return; end

n = int32(get(handles.sliderMinCylindrical, 'Value'));
flength = str2num(get(handles.focalLength, 'String'));
if isempty(flength) || flength < 10, return; end;

imgOut = cylindrical(imageArray, n, flength);

if ~isempty(imgOut),
    N = numel(imgOut);
    imshow(imgOut{1}, 'parent', handles.axes2);
    
    set(handles.panText, 'String', sprintf('( %d / %d )', 1, N));
    if N > 1,
    set(handles.sliderPan, 'Enable', 'on');    
    set(handles.sliderPan, 'Min', 1);
    set(handles.sliderPan, 'Max', N);
    set(handles.sliderPan, 'Value', 1);
    set(handles.sliderPan, 'SliderStep', [1/(N-1) , 10/(N-1)]);
    end
    if N == 1,
        set(handles.sliderPan, 'Enable', 'Off');
    end
end

function focalLength_Callback(hObject, eventdata, handles)
% hObject    handle to focalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of focalLength as text
%        str2double(get(hObject,'String')) returns contents of focalLength as a double


% --- Executes during object creation, after setting all properties.
function focalLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to focalLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in globeButton.
function globeButton_Callback(hObject, eventdata, handles)
global imgOut;

if isempty(imgOut), return; end
if numel(imgOut) > 1, imIdx = int32(get(handles.sliderPan, 'Value'));
else imIdx = 1;
end
imgOut{imIdx} = globe(imgOut{imIdx});
imshow(imgOut{imIdx}, 'parent', handles.axes2);


% --- Executes on button press in cropButton.
function cropButton_Callback(hObject, eventdata, handles)
global imgOut;

if isempty(imgOut), return; end

if numel(imgOut) > 1, 
    imIdx = int32(get(handles.sliderPan, 'Value'));
else imIdx = 1;
end

imgOut{imIdx} = crop(imgOut{imIdx},true,true,true,true, 0.75);
imshow(imgOut{imIdx}, 'parent', handles.axes2);

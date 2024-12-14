% SLIDER_DEMO MATLAB code for single image reflection suppression

function varargout = slider_demo(varargin)
% SLIDER_DEMO MATLAB code for slider_demo.fig
%      SLIDER_DEMO, by itself, creates a new SLIDER_DEMO or raises the existing
%      singleton*.
%
%      H = SLIDER_DEMO returns the handle to a new SLIDER_DEMO or the handle to
%      the existing singleton*.
%
%      SLIDER_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLIDER_DEMO.M with the given input arguments.
%
%      SLIDER_DEMO('Property','Value',...) creates a new SLIDER_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before slider_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to slider_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help slider_demo

% Last Modified by GUIDE v2.5 11-Mar-2018 21:49:05

% Begin initialization code - DO NOT EDIT

addpath(genpath(pwd))

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slider_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @slider_demo_OutputFcn, ...
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


% --- Executes just before slider_demo is made visible.
function slider_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to slider_demo (see VARARGIN)

% Choose default command line output for slider_demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slider_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slider_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

a = handles.a; % Original image loaded from Browse button

% Get slider value
h = get(hObject, 'Value');

% Call reflectSuppress to process the image
c = reflectSuppress(a, h, 1e-8); % Processed image

% Display the processed image
str = ['Threshold h:', ' ', sprintf('%.3f', h)];
set(handles.edit1, 'String', str);
axes(handles.axes2);
imshow(c);

% Log PSNR and SSIM values
if size(a, 3) == 3 % Convert original to grayscale if RGB
    a_gray = rgb2gray(a);
else
    a_gray = a;
end

if size(c, 3) == 3 % Convert processed to grayscale if RGB
    c_gray = rgb2gray(c);
else
    c_gray = c;
end


% Ensure both images are of the same class
if ~isa(a_gray, 'double')
    a_gray = im2double(a_gray); % Convert original image to double precision
end
if ~isa(c_gray, 'double')
    c_gray = im2double(c_gray); % Convert processed image to double precision
end

% Calculate PSNR
psnrValue = psnr(c_gray, a_gray);

% Calculate SSIM
ssimValue = ssim(c_gray, a_gray);

% Log the values to the MATLAB command window
disp(['PSNR: ', num2str(psnrValue), ' dB']);
disp(['SSIM: ', num2str(ssimValue)]);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.jpg', 'Pick an image', '.\figures');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       a = imread(filename);
       
       axes(handles.axes1);
       imshow(a);
       handles.a = a;
    end
    % Update handles structure
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
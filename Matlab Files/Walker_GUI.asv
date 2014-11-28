function varargout = Walker_GUI(varargin)
% WALKER_GUI MATLAB code for Walker_GUI.fig
%      WALKER_GUI, by itself, creates a new WALKER_GUI or raises the existing
%      singleton*.
%
%      H = WALKER_GUI returns the handle to a new WALKER_GUI or the handle to
%      the existing singleton*.
%
%      WALKER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WALKER_GUI.M with the given input arguments.
%
%      WALKER_GUI('Property','Value',...) creates a new WALKER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Walker_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Walker_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Walker_GUI

% Last Modified by GUIDE v2.5 25-Nov-2014 13:53:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Walker_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Walker_GUI_OutputFcn, ...
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



% --- Executes just before Walker_GUI is made visible.
function Walker_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Walker_GUI (see VARARGIN)
%initialize blank image
blank = zeros(480,640, 'uint8');
%clear both axes initially.
axes(handles.axes_result);
imshow(blank);
axes(handles.axes_kinect);
imshow(blank);

%initialize Video proporties and other necessary structures.


% Choose default command line output for Walker_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Walker_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Walker_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%initialize blank image
blank = zeros(480,640, 'uint8');

%clear both axes initially.
axes(handles.axes_result);
imshow(blank);
axes(handles.axes_kinect);
imshow(blank);

%Assume result is the file name of the resulting movie file.
image = CaptureKinectGUI(handles);
result = ClassifyWalk(image);

%display results within Status and the second axes.
set(handles.text_walk_id, 'String', result);
axes.(handles.axes_result);
implay(result);






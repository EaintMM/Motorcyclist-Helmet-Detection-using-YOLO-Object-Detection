function varargout = Mainpage(varargin)
% MAINPAGE MATLAB code for Mainpage.fig
%      MAINPAGE, by itself, creates a new MAINPAGE or raises the existing
%      singleton*.
%
%      H = MAINPAGE returns the handle to a new MAINPAGE or the handle to
%      the existing singleton*.
%
%      MAINPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINPAGE.M with the given input arguments.
%
%      MAINPAGE('Property','Value',...) creates a new MAINPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mainpage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mainpage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mainpage

% Last Modified by GUIDE v2.5 20-Aug-2019 21:09:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mainpage_OpeningFcn, ...
                   'gui_OutputFcn',  @Mainpage_OutputFcn, ...
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


% --- Executes just before Mainpage is made visible.
function Mainpage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mainpage (see VARARGIN)

% Choose default command line output for Mainpage

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
uniimage=imread('utycc.jpg');
logoimage=imread('forreal.png');

axes(handles.axes1);
imshow(logoimage);
axes(handles.axes4);
imshow(uniimage);
% axes(handles.axes5)
% imshow(unilogoimage)

% UIWAIT makes Mainpage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Mainpage_OutputFcn(hObject, eventdata, handles) 
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


figHandles=findobj('type','figure','-not','name','nameOfGUI');
close(figHandles)
run('secondpage.m')

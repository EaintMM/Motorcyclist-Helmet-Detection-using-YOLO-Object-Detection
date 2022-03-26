function varargout = resultTable(varargin)
% RESULTTABLE MATLAB code for resultTable.fig
%      RESULTTABLE, by itself, creates a new RESULTTABLE or raises the existing
%      singleton*.
%
%      H = RESULTTABLE returns the handle to a new RESULTTABLE or the handle to
%      the existing singleton*.
%
%      RESULTTABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTTABLE.M with the given input arguments.
%
%      RESULTTABLE('Property','Value',...) creates a new RESULTTABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resultTable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resultTable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resultTable

% Last Modified by GUIDE v2.5 21-Aug-2019 17:45:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resultTable_OpeningFcn, ...
                   'gui_OutputFcn',  @resultTable_OutputFcn, ...
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


% --- Executes just before resultTable is made visible.
function resultTable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resultTable (see VARARGIN)

% Choose default command line output for resultTable
if exist('old_data.mat','file')

A = load('old_data.mat');
Data = A.old_data(:,:);
end
colnames = {'<html><center /><font face="Times New Roman" size=5>Date</font></html>','<html><center /><font face="Times New Roman" size=5>Helmet</font></html>','<html><center /><font face="Times New Roman" size=5>No Helmet</font></html>','<html><center /><font face="Times New Roman" size=5>Total</font></html>',};



global countHelmet;
global countHead;
global countCycle;
global d;

 C = cell(1, 4);
for i = 1:4
    if(i==1)
         C{1,i} = d;
          elseif(i==2)
                    C{1,i} = countHelmet;
            elseif(i==3)
                        C{1,i} = countHead;
            else
                        C{1,i} = countCycle;
    end
end
           
%Data = [a,b,c,d];
old_data = C;
if exist('old_data.mat','file')
Data(end+1,:) = C;
old_data = Data;
end
save old_data;

% set(handles.uitable1,'data',old_data,'ColumnName',colnames);
set(handles.uitable1,'data',old_data,'ColumnName',colnames);

helmetpercent = (countHelmet/countCycle)*100;
headpercent = (countHead/countCycle)*100;
helmetpercentformat = strcat(num2str(helmetpercent),'%');

headpercentformat = strcat(num2str(headpercent) , '%');

percent = [helmetpercent headpercent];
labels = {helmetpercentformat,headpercentformat};
axes(handles.axes1);
pie(percent,labels);
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

 

% UIWAIT makes resultTable wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resultTable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see  GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path='D:\Motorcyclist without helmet detection\Plates\'
winopen(path)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('old_data.mat');
col_header = {'Date','Helmet','No Helmet','Total'};
 xlswrite('Plates\dailyData.xls',old_data);
xlswrite('Plates\dailyData.xls',col_header);
% output_matrix=[col_header;old_data];
% xlswrite('Plates\dailyData.xls',col_header,old_data);
msgbox('File Export Success!!');

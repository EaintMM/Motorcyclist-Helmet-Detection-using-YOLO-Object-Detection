function varargout = ToTestWithoutDetect(varargin)
% TOTESTWITHOUTDETECT MATLAB code for ToTestWithoutDetect.fig
%      TOTESTWITHOUTDETECT, by itself, creates a new TOTESTWITHOUTDETECT or raises the existing
%      singleton*.
%
%      H = TOTESTWITHOUTDETECT returns the handle to a new TOTESTWITHOUTDETECT or the handle to
%      the existing singleton*.
%
%      TOTESTWITHOUTDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOTESTWITHOUTDETECT.M with the given input arguments.
%
%      TOTESTWITHOUTDETECT('Property','Value',...) creates a new TOTESTWITHOUTDETECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ToTestWithoutDetect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ToTestWithoutDetect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ToTestWithoutDetect

% Last Modified by GUIDE v2.5 19-Aug-2019 00:13:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ToTestWithoutDetect_OpeningFcn, ...
                   'gui_OutputFcn',  @ToTestWithoutDetect_OutputFcn, ...
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


% --- Executes just before ToTestWithoutDetect is made visible.
function ToTestWithoutDetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ToTestWithoutDetect (see VARARGIN)

% Choose default command line output for ToTestWithoutDetect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ToTestWithoutDetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ToTestWithoutDetect_OutputFcn(hObject, eventdata, handles) 
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
[file,path] = uigetfile({'*.*','All Files'});
if isequal(file,0)
    disp('User selected Cancel');
else
    ax = handles.axes1;
    axOut = handles.axes2;
     fullFile=fullfile(path,file);

   
    
%%%%%%%%%
foregroundDetector = vision.ForegroundDetector('NumGaussians', 5,'LearningRate',0.15, ...
    'MinimumBackgroundRatio',0.3,'NumTrainingFrames', 50);

videoReader = vision.VideoFileReader(fullFile);
%depVideoPlayer=vision.DeployableVideoPlayer;
for i = 1:15
    frame = step(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);

end

h=size(frame,1);
w=size(frame,2);
s=struct('cdata',zeros(h,w,3,'uint8'),'colormap',[]);


%figure; imshow(frame); title('Video Frame');
%figure; imshow(foreground); title('Foreground');

se1 = strel('square', 12);
se2 = strel('disk', 20);

filteredForeground = imopen(foreground, se1);
filteredForeground1=imdilate(filteredForeground,se2);
%figure; imshow(filteredForeground1); title('Clean Foreground');

%  blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%      'AreaOutputPort', false, 'CentroidOutputPort', false, ...
%      'MinimumBlobArea', 30000);

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
      'AreaOutputPort', false, 'CentroidOutputPort', false, ...
     'MinimumBlobArea', 7500);

%   blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%       'AreaOutputPort', false, 'CentroidOutputPort', false, ...
%      'MinimumBlobArea', 50000);


 %for hm.mp4
% blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%     'AreaOutputPort', false, 'CentroidOutputPort', false, ...
%     'MinimumBlobArea', 9000);
bbox = step(blobAnalysis, filteredForeground);
result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green','LineWidth',7);

numCars = size(bbox, 1);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
    'FontSize', 14);
%figure; imshow(result); title('Detected Cars');
videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
 




k=1;
i=1;
b=1;

while ~isDone(videoReader)
    
    frame = step(videoReader); % read the next video frame
    
   
    % Detect the foreground in the current video frame
    foreground = step(foregroundDetector, frame);

    filteredForeground = imopen(foreground, se1);
    filteredForeground1=imdilate(filteredForeground,se2);
    % Use morphological opening to remove noise in the foreground

    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    bbox = step(blobAnalysis, filteredForeground1);

    % Draw bounding boxes around the detected cars
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green','LineWidth',7);
    
  
    
    image(result, 'Parent', ax);
 
        set(ax, 'Visible', 'off');
    
    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    
    
    i=1;
    
    %For e1SpeedUp.mp4 youtube HD
       if(numCars>=1)
            for j=1:numCars;
               
                %if 200<=bbox(j,2) && bbox(j,2)<=210
                %if 900<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=950
                 %if 650<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=700
                 if 440<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=450
                 %if isequal((h-30),bbox(j,2)+bbox(j,4))
                    
                    ans=bbox(j,2)+bbox(j,4)
                    s(k).cdata=frame;
                    
                    image(s(k).cdata, 'Parent', axOut);
                     set(axOut, 'Visible', 'off');
                              
                      
                      
                 end
            
              
            end
        end 
    
    
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
    
    
    step(videoPlayer, result);  % display the results
      % depVideoPlayer(result);
   
end

release(videoReader); % close the video files

    %release(depVideoPlayer);
end
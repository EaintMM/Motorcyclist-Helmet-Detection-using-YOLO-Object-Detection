function varargout = secondpage(varargin)
% SECONDPAGE MATLAB code for secondpage.fig
%      SECONDPAGE, by itself, creates a new SECONDPAGE or raises the existing
%      singleton*.
%
%      H = SECONDPAGE returns the handle to a new SECONDPAGE or the handle to
%      the existing singleton*.
%
%      SECONDPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SECONDPAGE.M with the given input arguments.
%
%      SECONDPAGE('Property','Value',...) creates a new SECONDPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before secondpage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to secondpage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help secondpage

% Last Modified by GUIDE v2.5 21-Aug-2019 02:33:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @secondpage_OpeningFcn, ...
                   'gui_OutputFcn',  @secondpage_OutputFcn, ...
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


% --- Executes just before secondpage is made visible.
function secondpage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to secondpage (see VARARGIN)

% Choose default command line output for secondpage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
icon_img_1=imread('playbandw.png');
axes(handles.axes1);
imshow(icon_img_1);
icon_img_2=imread('imageicon.png');
axes(handles.axes4);
imshow(icon_img_2);


% UIWAIT makes secondpage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = secondpage_OutputFcn(hObject, eventdata, handles) 
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
    ax = handles.axes3;
    axOut = handles.axes5;
     fullFile=fullfile(path,file);

    % Load pretrained detector for the example.
    pretrained = load('networks\yccyolomotorbike.mat');
    detector = pretrained.detector;


    helmetpretrained = load('networks\yolohead.mat');
    helmetdetector = helmetpretrained.detector;
    
    platepretrained = load('networks\yoloplate.mat');
    platedetector = platepretrained.detector;
    
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


se1 = strel('square', 12);
se2 = strel('disk', 20);

filteredForeground = imopen(foreground, se1);
filteredForeground1=imdilate(filteredForeground,se2);


blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
      'AreaOutputPort', false, 'CentroidOutputPort', false, ...
     'MinimumBlobArea', 7500);

bbox = step(blobAnalysis, filteredForeground);
result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green','LineWidth',7);

numCars = size(bbox, 1);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
    'FontSize', 14);
%figure; imshow(result); title('Detected Cars');
 videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
 %set(0,'showHiddenHandles','on');
 videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
% videoPlayer.Position(3:4) = [0,0];
 hide(videoPlayer);
global countCycle;
global countHelmet;
global countHead;
global d;
d = date;
countCycle=0;
countHelmet=0;
countHead=0;


k=1;
i=1;
b=1;
 prev=imread('ss (1).jpg');
    prev = imresize(prev,[224 224]);
    
    figH=handles.figure1;
    t = datetime('now','Format','yyyy_MM_dd''_''HHmmss')
    S = char(t);
                                 
   folderPath = strcat('Plates\',S,'\');
   mkdir(folderPath);
   
while ~isDone(videoReader)
    
    if ~ishghandle(figH)
        disp("Exit")
        break
    end
    
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
    
  
    axes(handles.axes3);
   imshow(result);
  
    
    % Display the number of cars found in the video frame
    numCars = size(bbox, 1);
    
       if(numCars>=1)
            for j=1:numCars;
               
                
                %For not duplicate....
                  
                    dx=bbox(1,1);
                    dy=bbox(1,2);
                    dw=bbox(1,3);
                    dh=bbox(1,4);
                    current=imcrop(result,[dx,dy,dw,dh]);
                    current = imresize(current,[224 224]);
                    imwrite( current,fullfile('temp',['cyclebbox',int2str(k),'.jpg']));
                    current=imread(fullfile('temp',['cyclebbox',int2str(k),'.jpg']));
                    
                    ssimval = ssim(current,prev);
                    
                    
                   %not duplicate end
               
                %if 200<=bbox(j,2) && bbox(j,2)<=210
                %if 900<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=950
                 %if 650<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=700
                 if 440>bbox(j,2)+bbox(j,4)
                  %if 690>bbox(j,2)+bbox(j,4)   
                     prev=imread('ss (1).jpg');
                     prev = imresize(prev,[224 224]);
                 end
                 
                 
                 if 440<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=465 && ssimval<0.5
                 %if 690<=bbox(j,2)+bbox(j,4) && bbox(j,2)+bbox(j,4)<=715 && ssimval<0.5
                 %if isequal((h-30),bbox(j,2)+bbox(j,4))
                 disp("#############")
                 disp(ssimval)
                 ans=bbox(j,2)+bbox(j,4)
                 
                    s(k).cdata=frame;
                    
                    
                    [bboxes,scores,label] = detect(detector,s(k).cdata);
                    [score,idx] = max(scores);
                    
                    
                    %bboxes = bboxes(idx,:);
                    annotation = sprintf('%s:(Confidence = %f)',label(idx),score);
                    
                    %disp(label(idx))
                    I = insertObjectAnnotation(s(k).cdata,'rectangle',bboxes,annotation);
               
                    if(isequal(label(idx),'motorcycle'))
                        
                       %I = imresize(I,[100 200]); 
                    %ToDisplayAxesOutput
                     image(I, 'Parent', axOut);
                     set(axOut, 'Visible', 'off');
                     numCycles = size(bboxes, 1);
                     if(numCycles>1)  
                         disp('numcycles>1')
                         for i=1:numCycles;
                           y=bboxes(i,2)+bboxes(i,4);
                           if(y>=430)
                             disp('y>=430')
                               x=bboxes(i,1);
                                y=bboxes(i,2);
                                w=bboxes(i,3);
                                 h=bboxes(i,4);
                                motorcycle=imcrop(s(k).cdata,[x,y-25,w,h+25]);
                                motorcycle = imresize(motorcycle,[224 224]);
                                %imwrite( motorcycle,fullfile('D:\Image\images\forNSMK',['motorcycle',int2str(k),'.jpg']));
                                % Run the helmet detector.
                                [helmetbboxes,scores,label] = detect(helmetdetector,motorcycle);
                                 disp('UntilHead')

                                if not(isempty(label))
                                    
                                    countHead=countHead+1;
                                    %annotation = sprintf('%s:(Confidence = %f)',label,scores);
                                    %I1 = insertObjectAnnotation(motorcycle,'rectangle',bboxes,annotation);
                                    ans='WithoutHelmet'
                                     motorcycle = imresize(motorcycle,[300 200]);
                                    axes(handles.axes7);
                                    
                                    imshow(motorcycle);
                                    disp(label)
                                    
                                    motorcycle = imresize(motorcycle,[224 224]);
                                    [platebboxes,scores,platelabel] = detect(platedetector,motorcycle);
                                    if(isequal(platelabel,'plate'))
                                    platex=platebboxes(1,1);
                                    platey=platebboxes(1,2);
                                    platew=platebboxes(1,3);
                                    plateh=platebboxes(1,4);
                                    plate=imcrop(motorcycle,[platex,platey,platew,plateh]);
                                    axes(handles.axes6);
                                    imshow(plate,'InitialMagnification',150);
                                   % bigPlate=imresize(plate,[100,200]);
                                   
                                    imwrite( bigPlate,fullfile(folderPath,['Image',int2str(k),'.jpg']));
                                    
                                    else
                                       axes(handles.axes6);
                                    imshow('noplate.png'); 
                                    imwrite( motorcycle,fullfile(folderPath,['Image',int2str(k),'.jpg']));
                                    end
                        
                        
                                
                                else
                               countHelmet=countHelmet+1;
                                end
                               
                           end 
                            
                         end
                         
                      %imwrite( I,fullfile('D:\Image\images\double',['Image',int2str(k),'.jpg']));   
                     else
                     
                     %imwrite( I,fullfile('D:\Image\images',['Image',int2str(k),'.jpg']));
                     x=bboxes(1,1);
                     y=bboxes(1,2);
                     w=bboxes(1,3);
                     h=bboxes(1,4);
                     motorcycle=imcrop(s(k).cdata,[x,y-25,w,h+25]);
                     motorcycle = imresize(motorcycle,[224 224]);
                    % imwrite( motorcycle,fullfile('D:\Image\images\forNSMK',['motorcycle',int2str(k),'.jpg']));
                                
                    % Run the helmet detector.
                    [helmetbboxes,scores,label] = detect(helmetdetector,motorcycle);
                 

                    
                    if not(isempty(label))
                        countHead=countHead+1;

                               ans='WithoutHelmet'
                                motorcycle = imresize(motorcycle,[300 200]);
                               axes(handles.axes7);
                                imshow(motorcycle);
                        motorcycle = imresize(motorcycle,[224 224]);
                        [platebboxes,scores,platelabel] = detect(platedetector,motorcycle);
                        if(isequal(platelabel,'plate'))
                        platex=platebboxes(1,1);
                        platey=platebboxes(1,2);
                        platew=platebboxes(1,3);
                        plateh=platebboxes(1,4);
                        plate=imcrop(motorcycle,[platex,platey,platew,plateh]);
                        axes(handles.axes6);
                        imshow(plate,'InitialMagnification',150);
                        bigPlate=imresize(plate,[100,200]);
                       
                         imwrite( bigPlate,fullfile(folderPath,['Image',int2str(k),'.jpg']));                        
                       
                         else
                               axes(handles.axes6);
                               imshow('noplate.png'); 
                               imwrite( motorcycle,fullfile(folderPath,['Image',int2str(k),'.jpg']));
                        
                        end 
                    else
                        countHelmet=countHelmet+1;
                    end
                    end
                     
                    end
                    k=k+1;
                    prev=current;

                 end
            
              
            end
        end 
    
    
    result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
   % axes(handles.axes2);
   % imshow(result)
  
 step(videoPlayer, result);  % display the results
     
    countCycle=countHead+countHelmet;  
   
end



disp(countCycle);
disp(countHead);
disp(countHelmet);

release(videoReader);%close the video files

end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figHandles=findobj('type','figure','-not','name','nameOfGUI');
close(figHandles);
run('resultTable.m');

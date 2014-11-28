function [image] = CaptureKinectGUI(handles)
% CaptureKinect Main function to capture and process kinect video and
% skeletal data.
%
% Eventual expension will create a motion energy image using this data.
% This will probably done over a black background where the indexes of 
% joints and the line connecting them will trigger changes in the image.
% 
% Current method would be to create an image using the skeletalViewer
% function and then using the image as a part of the motion energy image
% creation process.
%
% Current questions include: When should recording start?
%                            How long will recording last for?
%                            Is extra processing time necessary?
%
% Assumes that a kinect is connected and both RGB and depth camera are
% recognized!
%
% All MEI's used for comparison are built from 3 sec long clips at 29 fps
% The kinect records at 30 fps with a resolution of 480 x 640
% We will capture images first before processing into MEI
%
%
%
%set RGB input (potentially not needed just for main screen.)
dbstop if error
imaqreset %deletes any image acquisition objects that exsist in memory

%------------Setup-----------------
nFrame = 50;

%set depth input (for skeletal data)
depthVid = videoinput('kinect', 2, 'Depth_640x480');

%Set up connection map to connect joints 
SkeletonConnectionMap = [[1 2]; % Spine
                         [2 3];
                         [3 4];
                         [3 5]; %Left Hand
                         [5 6];
                         [6 7];
                         [7 8];
                         [3 9]; %Right Hand
                         [9 10];
                         [10 11];
                         [11 12];
                         [1 17]; % Right Leg
                         [17 18];
                         [18 19];
                         [19 20];
                         [1 13]; % Left Leg
                         [13 14];
                         [14 15];
                         [15 16]];

%initialize blank image
blank = zeros(480,640, 'uint8');
%------------------------------------------------
%setting up record
%------------------------------------------------

%Set a video timeout property limit to 50 seconds 
set(depthVid, 'Timeout',50);

%set the triggering mode to 'manual'
triggerconfig(depthVid, 'manual');

%set the FramePerTrigger property of the VIDEOINPUT objects to 100 to
%acquire 100 frames per trigger.
set(depthVid, 'FramesPerTrigger', 1);
set(depthVid, 'TriggerRepeat', nFrame);

%Set data to collect skeleton information
set(getselectedsource(depthVid), 'TrackingMode', 'Skeleton');

%initialize an array to hold skeletal data (400 frames is approximately 6 seconds):
skel_frames = zeros(20,2,nFrame);

%initialize timer object
count = 3;
t = timer('TimerFcn', 'count = count - 1;set(handles.text_count, ''String'', int2str(count));drawnow',...
          'Period', 1,...
          'ExecutionMode', 'fixedSpacing',...
          'TasksToExecute', 3);

set(handles.text_satus, 'String', 'Video record set-up complete');
drawnow;
%------------------------------------------------
%Initiating the aquisition
%------------------------------------------------
set(handles.text_satus, 'String', 'Starting Steam');
drawnow;

start(depthVid);

%Countdown 3 seconds but also display what the kinect sees in the depth
%camera
set(handles.text_satus, 'String', 'Starting Countdown');
drawnow;

start(t);
while(count >0)
    [imgDepth, ~, ~] = getdata(depthVid);
    imshow(imgDepth);
end

for x = 1:nFrame
    trigger(depthVid);
    [imgDepth, ~, metaData_Depth] = getdata(depthVid);
    isTracked = metaData_Depth.IsSkeletonTracked;
    nSkeleton = sum(isTracked);
    skeleton = metaData_Depth.JointImageIndices;
    
    if nSkeleton == 1
       for i = 1:6
          if isTracked(i) == 1
              skeletonID = i;
              break;
          end
       end
    end

    imshow(blank);
    hold on;
        
    if nSkeleton > 0
     %draw lines onto plot as well as blank image.   
       for i = 1:19
          X1 = [skeleton(SkeletonConnectionMap(i,1),1,skeletonID), 
                       skeleton(SkeletonConnectionMap(i,2),1,skeletonID)];
          Y1 = [skeleton(SkeletonConnectionMap(i,1),2,skeletonID),
                       skeleton(SkeletonConnectionMap(i,2),2,skeletonID)];
          line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
          
       end
    %save skeletal data for that particular frame
    skel_frames(:,:,x) = skeleton(:,:,skeletonID);    
    else
        hold off;
        imshow(imgDepth, [0 4096]);
    end 
end

stop(depthVid);

set(handles.text_satus, 'String', 'Done collecting, processing information');
drawnow;

%process skeletal information from frames
for idx=1:nFrame
    for i = 1:19
        X1 = [skel_frames(SkeletonConnectionMap(i,1),1,idx), skel_frames(SkeletonConnectionMap(i,2),1,idx)];
        Y1 = [skel_frames(SkeletonConnectionMap(i,1),2,idx), skel_frames(SkeletonConnectionMap(i,2),2,idx)];
        if(X1(1) <= 640) && (X1(2) <= 640) && (Y1(1) <= 480) && (Y1(2) <= 480)
            if(X1(1) > 0) && (X1(2) > 0) && (Y1(1) > 0) && (Y1(2) > 0)
                x = linspace(X1(1), X1(2), 1000);
                y = linspace(Y1(1), Y1(2), 1000);
                index = sub2ind(size(blank),round(y), round(x));
                %Set the pixels to white.
                blank(index) = 255; 
            end
        end
    end
end

set(handles.text_satus, 'String', 'Done processing, displaying image');
drawnow;

imshow(blank);

image = blank;
end


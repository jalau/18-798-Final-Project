function [ ] = CaptureKinect( )
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
colorVid = videoinput('kinect', 1, 'RGB_640x480');

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
    
%------------------------------------------------
%setting up record
%------------------------------------------------

%Set a video timeout property limit to 50 seconds from
%www.mathworks.com/matlabcentral/answers/103543-why-do-i-receive-the-error
% -getdata-timed-out-before-frames-were-available-when-using-getdata-in-im
set(colorVid, 'Timeout',50);
set(depthVid, 'Timeout',50);

%set the triggering mode to 'manual'
triggerconfig([colorVid depthVid], 'manual');

%set the FramePerTrigger property of the VIDEOINPUT objects to 100 to
%acquire 100 frames per trigger.
set([colorVid depthVid], 'FramesPerTrigger', 1);
set([colorVid depthVid], 'TriggerRepeat', inf);

%Set data to collect skeleton information
set(getselectedsource(depthVid), 'TrackingMode', 'Skeleton');

disp('Video record set-up complete');

%------------------------------------------------
%Initiating the aquisition
%------------------------------------------------
disp('Starting Steam');

start([colorVid depthVid]);

himg = figure

while ishandle(himg)
    trigger(depthVid);
    [imgDepth, ~, metaData_Depth] = getdata(depthVid);
    isTracked = metaData_Depth.IsSkeletonTracked;
    nSkeleton = sum(isTracked);
    skeleton = metaData_Depth.JointImageIndices;
%     if nSkeleton > 0
%         skeletonJoints = metaData_Depth.JointImageIndices(:,:,metaData_Depth.IsSkeletonTracked);
%         imshow(imgDepth, [0 4096]);
%         hold on;
%         plot(skeletonJoints(:,1), skeletonJoints(:,2), '*');
%         hold off;

    imshow(imgDepth, [0 4096]);
    hold on;
        
    if nSkeleton > 0
        while(nSkeleton >0)
            trigger(depthVid);
            [imgDepth, ~, metaData_Depth] = getdata(depthVid);
            isTracked = metaData_Depth.IsSkeletonTracked;
            nSkeleton = sum(isTracked);
            skeleton = metaData_Depth.JointImageIndices;    
            for i = 1:19
                X1 = [skeleton(SkeletonConnectionMap(i,1),1,isTracked), 
                       skeleton(SkeletonConnectionMap(i,2),1,isTracked)];
                Y1 = [skeleton(SkeletonConnectionMap(i,1),2,isTracked),
                       skeleton(SkeletonConnectionMap(i,2),2,isTracked)];
                line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
            end
        end
        %hold off;
    else
        hold off;
        imshow(imgDepth, [0 4096]);
    end
end

stop([colorVid depthVid]);
% 
% for i= 1:201
%     %trigger both objects
%     trigger([colorVid depthVid]);
%     [imgColor, ~, metaData_Color] = getdata(colorVid);
%     [imgDepth, ~, metaData_Depth] = getdata(depthVid);
%     skeletonViewer(metaData_Depth.JointImageIndices, imgColor, metaData_Depth.IsSkeletonTracked);
% end


end


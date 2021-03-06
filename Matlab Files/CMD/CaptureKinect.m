function [image, stride, arm, knee_r, knee_l] = CaptureKinect( )
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
colorVid = videoinput('kinect', 1, 'RGB_640x480');
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

%initialize variables for statistic collection
stride_max = 0;
stride_avg = 0;
arm_max = 0;
arm_avg = 0;
knee_l_max = 0;
knee_l_min = 0;
knee_r_max = 0;
knee_r_min = 0;
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
set([colorVid depthVid], 'TriggerRepeat', nFrame);

%Set data to collect skeleton information
set(getselectedsource(depthVid), 'TrackingMode', 'Skeleton');

%initialize an array to hold skeletal data (400 frames is approximately 6 seconds):
skel_frames = zeros(20,2,nFrame);

disp('Video record set-up complete');

%------------------------------------------------
%Initiating the aquisition
%------------------------------------------------
disp('Starting Steam');

start([colorVid depthVid]);

preview(depthVid);

pause(1);
disp('3');
pause(1);
disp('2');
pause(1);
disp('1');
pause(1);
closepreview;
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
    
%     if nSkeleton > 0
%         skeletonJoints = metaData_Depth.JointImageIndices(:,:,metaData_Depth.IsSkeletonTracked);
%         imshow(imgDepth, [0 4096]);
%         hold on;
%         plot(skeletonJoints(:,1), skeletonJoints(:,2), '*');
%         hold off;

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

stop([colorVid depthVid]);

disp('Done collecting, processing information');
%fprintf('Size of skel_frames: %d', size(skel_frames));

%Initialize knee_min values 
knee_l_min = skel_frames(6,2,1);
knee_r_min = skel_frames(10,2,1);
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
    
    %Compile information on statistics
    %stride length
    diff = abs(skel_frames(16,1,idx) - skel_frames(20,1,idx));
    if(stride_max < diff)
       stride_max = diff;
    end
    stride_avg = stride_avg + diff;
    
    %arm range of motion
    diff = abs(skel_frames(6,1,idx) - skel_frames(10,1,idx));
    if(arm_max < diff)
       arm_max = diff;
    end
    arm_avg = arm_avg + diff;
    
    %knee range of motion
    if(knee_l_max < skel_frames(6,2,idx))
        knee_l_max = skel_frames(6,2,idx);
    else if (knee_l_min > skel_frames(6,2,idx))
        knee_l_min = skel_frames(6,2,idx);
        end
    end
    
    if(knee_r_max < skel_frames(10,2,idx))
        knee_r_max = skel_frames(10,2,idx);
    else if (knee_r_min > skel_frames(10,2,idx))
        knee_r_min = skel_frames(10,2,idx);
        end
    end
end

stride_avg = stride_avg/nFrame;
arm_avg = arm_avg/nFrame;

stride = 100*(stride_max/stride_avg);
arm = 100*(arm_max/arm_avg);
knee_r = 100*(knee_r_max/knee_r_min);
knee_l = 100*(knee_l_max/knee_l_min);

disp('Done processing, displaying image');
imshow(blank);

% 
% for i= 1:201
%     %trigger both objects
%     trigger([colorVid depthVid]);
%     [imgColor, ~, metaData_Color] = getdata(colorVid);
%     [imgDepth, ~, metaData_Depth] = getdata(depthVid);
%     skeletonViewer(metaData_Depth.JointImageIndices, imgColor, metaData_Depth.IsSkeletonTracked);
% end
%img_dir = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\final project\18-798-Final-Project\Image Files';
%imwrite(blank, fullfile(img_dir, 'kinect_img.png'));
image = blank;
end


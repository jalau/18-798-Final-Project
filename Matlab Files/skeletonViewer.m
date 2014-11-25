function [] = skeletonViewer(skeleton, image, IsSkeletonTracked)
%skeletonViewer: Draws skeletal data over an RGB image.
%Next step is to only use the skeletal data to create an
%motion energy image.
%   Initially, we expect the inputed image to be the RGB from the kinect.
%   However, in later parts of the project, we will instead provide a 
%   black background to view the skeletal data.
%
%   Using the skeletal data, we create a connection map in order
%   to accurately plot the points over the RGB image.
%   Source: http://www.mathworks.com/help/imaq/using-the-skeleton-viewer
%           -for-kinect-skeletal-data.html
%
% Note: This is the order of the joints returned by the Kinect adaptor:
%    Hip_Center = 1;
%    Spine = 2;
%    Shoulder_Center = 3;
%    Head = 4;
%    Shoulder_Left = 5;
%    Elbow_Left = 6;
%    Wrist_Left = 7;
%    Hand_Left = 8;
%    Shoulder_Right = 9;
%    Elbow_Right = 10;
%    Wrist_Right = 11;
%    Hand_Right = 12;
%    Hip_Left = 13;
%    Knee_Left = 14;
%    Ankle_Left = 15;
%    Foot_Left = 16; 
%    Hip_Right = 17;
%    Knee_Right = 18;
%    Ankle_Right = 19;
%    Foot_Right = 20;
nSkeleton = sum(IsSkeletonTracked);

imshow(image, [0 4096]);
hold on;

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
%Go through data and draw points and lines. Note this only draws up to 2 
%skeletons.
for i = 1:19
     
     if nSkeleton > 0
         X1 = [skeleton(SkeletonConnectionMap(i,1),1,1) skeleton(SkeletonConnectionMap(i,2),1,1)];
         Y1 = [skeleton(SkeletonConnectionMap(i,1),2,1) skeleton(SkeletonConnectionMap(i,2),2,1)];
         line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
     end
     if nSkeleton > 1
         X2 = [skeleton(SkeletonConnectionMap(i,1),1,2) skeleton(SkeletonConnectionMap(i,2),1,2)];
         Y2 = [skeleton(SkeletonConnectionMap(i,1),2,2) skeleton(SkeletonConnectionMap(i,2),2,2)];     
         line(X2,Y2, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'g');
     end
 end
 hold off;                     
                     
end


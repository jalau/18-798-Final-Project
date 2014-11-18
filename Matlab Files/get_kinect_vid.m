% Launches installer tool
% Select Kinect SDK
targetinstaller

% Test installation
info = imaqhwinfo('kinect')

% View RGB camera video
info.DeviceInfo(1)
colorVid = videoinput('kinect', 1, 'RGB_640x480');
preview(colorVid);

% Display snapshot from Depth camera video
info.DeviceInfo(2)
depthVid = videoinput('kinect', 2, 'Depth_640x480');
imshow(getsnapshot(depthVid), [0, 400000]);

% Start data stream for Depth camera video
start(depthVid);
[frameDataDepth, timeDataDepth, metaDataDepth] = getdata(depthVid);


%Get Skeletal Data
function [] = skeletonViewer(skeleton, image, nSkeleton)
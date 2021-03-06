function image =  motion_energy(file, thresh)
% motion energy algorithm
%
% motion_energy(file, filter)
%
% Parameters:   
%   file - the name of the file
%   thresh - pixel difference threshold

inputVideo = VideoReader(file);
nFrames = inputVideo.NumberOfFrames;

bg = read(inputVideo, 1);
first= double(rgb2gray(bg));	% convert background to greyscale
[height width] = size(first);	% frame size

result = zeros(height, width);      % allocate array for image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterate through the all the remaining frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 2:nFrames-1
    fr = read(inputVideo, i);
    fr_bw = rgb2gray(fr);
    diff = abs(double(fr_bw) - double(first));
    
    if (0 == mod(i, 50))
        display(i);
    end
    
    for j=1:width                 % if fr_diff > thresh pixel in foreground
         for k=1:height
            if ((diff(k,j) > thresh))
                 result(k,j) = 255;      %Add it to the foreground             
            end
         end    
    end
    
%     figure(1),subplot(1,2,1),imshow(fr)     
%     title('Input Frame')
%     subplot(1,2,2),imshow(uint8(result)) 
%     title('Motion Energy Image') 
    image = result;
end
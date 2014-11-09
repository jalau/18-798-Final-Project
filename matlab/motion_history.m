function motion_history(file, thresh)
% motion history algorithm
%
% motion_history(file, thresh)
%
% Parameters:   
%   file - the name of the file
%   thresh - the threshold file
%

inputVideo = VideoReader(file);
nFrames = inputVideo.NumberOfFrames;

bg = read(inputVideo, 1);
prev = double(rgb2gray(bg));	% convert background to greyscale
[height width] = size(prev);	% frame size

history = zeros(height, width);  % allocate array for image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterate through the all the remaining frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 2:nFrames-1
    fr = read(inputVideo, i);
    fr_bw = rgb2gray(fr);
    diff = abs(double(fr_bw) - double(prev));
    
    if (0 == mod(i, 50))
        display(i);
    end
    
    for j=1:width
         for k=1:height
            if ((diff(k,j) > thresh)) %changed value
                if (history(k,j) ~= 0) 
                    history(k,j) = history(k,j) - 5; 
                else
                    history(k,j) = 255;
                end
            end
         end    
    end
    
    prev = fr_bw;
    
    figure(1),subplot(1,2,1),imshow(fr)     
    title('Input Frame')
    subplot(1,2,2),imshow(uint8(history)) 
    title('Motion History Image') 
    
end
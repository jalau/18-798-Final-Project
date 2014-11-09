path = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\Assignment 3\SAM_0562.mp4';
%path = 'nursing_home/image_';

%Get input video
inputObj = VideoReader(path);
nframes = inputObj.NumberofFrames;

%Set default input values
thresh = 30;
BG = 150;
filt = 4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the first frame to build the initial background model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bg = read(inputObj, 1);  %Grab the first image of the video.
bg_bw = double(rgb2gray(bg));	% convert background to greyscale
[height width] = size(bg_bw);	% frame size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If specified refine the initial backgnd model using the first BG frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if (BG~=0)
    for i = 2:BG

        fr = read(inputObj, i); %Read each individual frame of the video.
        fr_bw = rgb2gray(fr);

        for j=1:width          
            for k=1:height
             
             if (fr_bw(k,j) > bg_bw(k,j))       %Update the background model     
                 bg_bw(k,j) = bg_bw(k,j) + 1;           
             elseif (fr_bw(k,j) < bg_bw(k,j))
                 bg_bw(k,j) = bg_bw(k,j) - 1;     
             end
            end  
        end
%         
%         figure(1),subplot(2,1,1),imshow(fr) 
%         title('Input Frame')   
%         subplot(2,1,2),imshow(uint8(bg_bw)) 
%         title('Background model')   
    end
else
    BG = 2;
end


fg = zeros(height, width);      % allocate array for foreground
max_diff = 30;
BLOCK_SIZE = 100000;                          % initial capacity (& increment size)
listSize = BLOCK_SIZE;                      % current list capacity
X_list = zeros(listSize, 1);                  % actual list
Y_list = zeros(listSize, 1);
X_Ptr = 1;                                % pointer to last free position
Y_Ptr = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterate through the all the remaining frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = BG:90:nframes
    fprintf('analyzing frame %d\n', i);
    fr = read(inputObj,i);
    fr_bw = rgb2gray(fr);
    fr_diff = abs(double(fr_bw) - double(bg_bw));

    for j=1:width                 % if fr_diff > thresh pixel in foreground
         for k=1:height

             if ((fr_diff(k,j) > thresh))
                 %push items onto list
                 X_list(X_Ptr, 1) = k;
                 Y_list(Y_Ptr, 1) = j;
                 X_Ptr = X_Ptr + 1;
                 Y_Ptr = Y_Ptr + 1;
                 %add more memory if needed
                 if( X_Ptr+(BLOCK_SIZE/10) > listSize )  % less than 10%*BLOCK_SIZE free slots
                    listSize = listSize + BLOCK_SIZE;       % add new BLOCK_SIZE slots
                    X_list(X_Ptr+1:listSize,:) = 0;
                    Y_list(Y_Ptr+1:listSize,:) = 0;
                  end
                 fg(k,j) = fr_bw(k,j);      %Add it to the foreground
             else
                 fg(k,j) = 0;               
             end

             if (fr_bw(k,j) > bg_bw(k,j))       %Update the background model     
                 bg_bw(k,j) = bg_bw(k,j) + 1;           
             elseif (fr_bw(k,j) < bg_bw(k,j))
                 bg_bw(k,j) = bg_bw(k,j) - 1;     
             end

         end    
    end
    
%     fg_filt = medfilt2(fg, [filt,filt]);
%     
%     figure(1),subplot(2,2,1),imshow(fr)     
%     title('Input Frame') 
%     subplot(2,2,3),imshow(uint8(bg_bw))
%     title('Background Model') 
%     subplot(2,2,4),imshow(uint8(fg))  
%     title('Foreground') 
%     subplot(2,2,2),imshow(uint8(fg_filt)) 
%     title('Filtered Foreground') 
end
%remove unused slots
X_list(X_Ptr:end,:) = [];
Y_list(Y_Ptr:end,:) = [];
%Plot the original background image and merge the motion energy image over
%it.
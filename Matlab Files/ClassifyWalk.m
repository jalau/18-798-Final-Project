function filename = ClassifyWalk(image)
%This function looks through a set of motion energy images within our
%database and compares scores of row and column vectors. The image with the
%best comparison will be returned.
%   image - a black and white (or greyscale) image of size 480x640
%   filename - 'nothing' or the filename of some MEI and video.
%
%   Database selection: We will process pictures one at a time in the order
%   that the file system as organized them. This procedure can be improved
%   later as a standard arises.
%   
%   Scoring: Rows will be scored based upon how many pixels within the
%   vector are white. Columns will be scored the same way. Thus, we will
%   have an array of size 640 and another of size 480 of scores for both
%   the image passed to us, and the image within our database.
%   
%   Comparison: We first look for the first non zero value of the two
%   vectors we want to compare and starting from there, give points for
%   values that are similar within 5 (1 point if we're 5 values off, 2
%   points if we're 4 values off, etc). We can potentially set  threshold
%   to quicken the process later but for now, we will use this comparison
%   for each image and compare scores to determine the best match.
%
%   Returning: Along with the image score, we will also save the image's
%   associated file name.

%Directory of the files
vid_dir = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\final project\18-798-Final-Project\convert_vid';
img_dir = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\final project\18-798-Final-Project\Image Files';
vids = fullfile(vid_dir, '*.mp4');
imgs = fullfile(img_dir, '*.png');
files = dir(imgs);
names = {files.name};

%Initialize necessary data structures
% threshould - How lenient scoring will be.
% height - The expected height of the given image and images in the database.
% width - The expected width of the given image and images in the database.
% data_row - An array to store the scores for a data file
% data_col - An array to store the scores for a data file
% data_collection - An array to store the comparison scores between the
% corresponding data file and the given image.
% img_row - An array to store the scores for the given image file.
% img_col - An array to store the scores for the given image file.
%nData = 16;
score_threshold = 5;
height = 480;
width = 640;
data_row = zeroes(height);
data_col = zeroes(width);
data_collection = zeroes(numel(files));
img_row = zeroes(height);
img_col = zeroes(width);

%score given image.
[img_row, img_col] = ScoreImage(image, width, height);

%Loop through database to find comparisons for all images.

cd(img_dir);

for id = 1:numel(files);
    cur_img = imread(names{id});
    [data_row, data_col] = ScoreImage(cur_img, width, height);
    data_collection(id) = data_collection(id) + CompareScore(img_row, data_row, height, score_threshold);
    data_collection(id) = data_collection(id) + CompareScore(img_col, data_col, width, score_threshold);
end


%Compare scores and determine the winner.
max = 0;
max_index = 1;
for id = 1:numel(files);
    if data_collection(id) > max
        max = data_collection(id);
        max_index = id;
    end
end

[~, filename, ~] = fileparts(names{max_index});
end

function [img_row, img_col] = ScoreImage(image, width, height)
    img_row = zeros(height);
    img_col = zeros(width);
        
    %Make sure image fits expected size.
    [row, col] = size(image);
    if row ~= height || col ~= width
        disp('The given image does not match with expected dimensions!');
        return;
    end

    %collect scores for image.
    for row = 1:height
        for col = 1:width
            if image(row,col) > 0
                img_row(row) = img_row(row) + 1;
                img_col(col) = img_col(col) + 1;
            end
        end
    end
end

function score = CompareScore(img_v, data_v, v_size, threshold)
    idx_img = 1;
    idx_data = 1;
    score = 0;
    
    for index = 1:v_size
        if img_v(index) > 0
            idx_img = index;
            break;
        end
    end
    for index = 1:v_size
        if data_v(index) > 0
            idx_data = index;
            break;
        end
    end
    while (idx_img <= v_size) && (idx_data <= v_size)
       diff = abs(img_v(idx_img) - data_v(idx_data));
       if diff < threshold
           score = score + threshold - diff;
       end
       idx_img = idx_img + 1;
       idx_data = idx_data + 1;
    end
end


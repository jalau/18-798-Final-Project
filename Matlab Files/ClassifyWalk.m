function [filename] = ClassifyWalk(image)
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

%Initialize necessary data structures
% nData - The number of images to compare
% height - The expected height of the given image and images in the database.
% width - The expected width of the given image and images in the database.
% data_row - An array to store the scores for a data file
% data_col - An array to store the scores for a data file
% data_collection - An array to store the comparison scores between the
% corresponding data file and the given image.
nData = 16;
height = 480;
width = 640;
data_row = zeroes(height);
data_col = zeroes(width);
data_collection = zeroes(nData);
img_row = zeroes(height);
img_col = zeroes(width);

%Make sure image fits expected size.
[row, col] = size(image);
if row ~= height || col ~= width
    disp('The given image does not match with expected dimensions!');
    filename = 'nothing';
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

%Loop through database to find comparisons for all images.



%Compare scores and determine the winner.





end


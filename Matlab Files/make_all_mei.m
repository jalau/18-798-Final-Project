%Directory of the files
d = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\hw4(assign2)\Eigenface\Eigenface\male\*.bmp';
full_d = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\hw4(assign2)\Eigenface\Eigenface\male\';
%Get name of the files
files = dir(d);
names = {files.name};
%loop through files (assuming they're all images
for id = 1:numel(files)
    %print original name.    
    %disp(names);
    %fprintf('original name: %s\n',files(id).name);
    %fprintf('%d\n', x);
    %fprintf('new name: %s\n', sprintf('%03d.jpg',id));
    %rename file
    fprintf('files: %d', numel(files));
    newName = fullfile(full_d, sprintf('%03d.bmp',id));
    oldName = fullfile(full_d, names{id});
    if(strcmp(newName,oldName) == 0)
    %fprintf('full file address: %s\n', fullfile(full_d,names{id}));
        movefile(fullfile(full_d,names{id}) ,newName);
    end
end
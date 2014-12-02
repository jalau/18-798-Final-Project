function make_all_mei()

    %Directory of the files
    vid_dir = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\final project\18-798-Final-Project\new convert vid';
    img_dir = 'C:\Users\Jeff Lau\SkyDrive\Documents\Classes\18-798\final project\18-798-Final-Project\Image Files';
    vids = fullfile(vid_dir, '*.mp4');
    imgs = fullfile(img_dir, '*.png');
    %Get name of the files
    files = dir(vids);
    names = {files.name};

    %change workin director to video folder
    cd(vid_dir);

    %loop through files (assuming they're all 480x640 mp4's
    for id = 1:numel(files)
        image = motion_energy(names{id}, 100);
        [~, name, ~] = fileparts(names{id});
        imwrite(image, fullfile(img_dir, sprintf('%s.png',name)));
    end

end
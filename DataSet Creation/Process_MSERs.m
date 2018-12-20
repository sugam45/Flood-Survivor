total_new_folder = 'C:\Users\Roopesh\Desktop\DIP\New_Dataset';
feature_folder = 'C:\Users\Roopesh\Desktop\DIP\Features';
image_folders = dir(fullfile(total_new_folder,'*000*'));
total_datasets = numel(image_folders);

mkdir(feature_folder);

tots = 0;
l = [];
Person = cell(1,284);
image = cell(1,284);

descrip = des();

for k = 1:total_datasets
    filenames = dir(fullfile(total_new_folder,fullfile(image_folders(k).name, '*.bmp')));  % read all images with specified extention, its jpg in our case
    total_image_folder = numel(filenames);    % count total number of photos present in that folder
    new_f = fullfile(feature_folder,image_folders(k).name);
    mkdir(feature_folder,image_folders(k).name);
    
    for n = 1:total_image_folder
        full_name= fullfile(fullfile(total_new_folder,image_folders(k).name), filenames(n).name);
        files_im = dir(fullfile(full_name,'*.bmp'));
        total_images = numel(files_im);
        mkdir(fullfile(fullfile(feature_folder,image_folders(k).name), filenames(n).name));
        save_full_name = fullfile(fullfile(feature_folder,image_folders(k).name), filenames(n).name);
        for i = 1:total_images
            im = imread(fullfile(full_name,files_im(i).name));
            im_7 = image_enhance(im);
            descriptor_1 = gene(im_7,descrip);
            save_figp = strcat(fullfile(fullfile(fullfile(feature_folder,image_folders(k).name), filenames(n).name),num2str(i)),'.mat');
            save(save_figp, 'descriptor_1');
            disp(save_figp);
        end
    end
end

function y = des()
    x_ax = 32;
    y_ax = 16; 
    y = cell(1,2000);
    for h = 1:2000
        rand_i = randi(7);
        xmin = randi(x_ax-1);
        ymin = randi(y_ax-1);
        width = randi(y_ax-ymin);
        height = randi(x_ax-xmin);
        y{h} = table(rand_i,[xmin ymin width height]);
    end
end

function y = gene(x,z)
    for h = 1:2000
        j = imcrop(x{z{h}.rand_i},z{h}.Var2);
        y{h} = sum(j,'all');
    end
end

function y = image_enhance(x)
    y = cell(1,7);
    f1 = [-1 2 -1;0 0 0;1 2 1];
    c1 = abs(imfilter(x,f1,'conv'));
    f2 = imrotate(f1,-30,'bilinear','crop');
    y{1} = abs(imfilter(x,f2,'conv'));
    f3 = imrotate(f1,-60,'bilinear','crop');
    y{2} = abs(imfilter(x,f3,'conv'));
    f4 = imrotate(f1,-90,'bilinear','crop');
    y{3} = abs(imfilter(x,f4,'conv'));
    f5 = imrotate(f1,-120,'bilinear','crop');
    y{4} = abs(imfilter(x,f5,'conv'));
    f6 = imrotate(f1,-150,'bilinear','crop');
    y{5} = abs(imfilter(x,f6,'conv'));
    f7 = imrotate(f1,-180,'bilinear','crop');
    y{6} = abs(imfilter(x,f7,'conv'));
    f8 = [-1 0 1; -2 0 2; -1 0 1];
    c2 = abs(imfilter(x,f8,'conv'));
    y{7} = sqrt(double(times(c1,c1) + times(c2,c2)));
end

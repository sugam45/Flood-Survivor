total_folder = 'C:\Users\Roopesh\Desktop\DIP\Dataset'; %  Enter name of folder from which you want to upload pictures with full path
total_new_folder = 'C:\Users\Roopesh\Desktop\DIP\New_Dataset';
image_folders = dir(fullfile(total_folder,'*000*'));
total_datasets = numel(image_folders);

mkdir(total_new_folder);

tots = 0;
l = [];
Person = cell(1,284);
image = cell(1,284);
for k = 1:total_datasets
    filenames = dir(fullfile(total_folder,fullfile(image_folders(k).name, '*.bmp')));  % read all images with specified extention, its jpg in our case
    total_images = numel(filenames);    % count total number of photos present in that folder
    new_f = fullfile(total_new_folder,image_folders(k).name);
    mkdir(total_new_folder,image_folders(k).name);
    
    for n = 1:total_images
        full_name= fullfile(fullfile(total_folder,image_folders(k).name), filenames(n).name);
        mkdir(fullfile(fullfile(total_new_folder,image_folders(k).name), filenames(n).name));
        save_full_name = fullfile(fullfile(total_new_folder,image_folders(k).name), filenames(n).name);
        %our_images = imread(full_name);                 % Read images  
        %enhanced_image = histogram(our_images);
        %imshowpair(enhanced_image ,our_images,'montage');
        if(k == 1 && n == 3)
        our_images = imread(full_name);   
        %{
        figure(1);
        hold on;
        subplot(1,2,1);
        imshow(our_images);
        subplot(1,2,2);
        histogram(our_images);
        %}
        [enhanced_image,cc] = image_enhance(our_images);
        imshow(our_images); hold on;
        plot(enhanced_image,'showPixelList',false,'showEllipses',true);
        %[features,new_image] = extractFeatures(our_images,enhanced_image);
        %plot(new_image);
        c_new = construct_new(enhanced_image,our_images);
        
        for i = 1:enhanced_image.Count
            save_figp = strcat(strcat(fullfile(fullfile(fullfile(total_new_folder,image_folders(k).name), filenames(n).name),'-'),num2str(i)),'.bmp');
            figure(i+1)
            imshow(c_new{i});
            %imwrite(uint8(imresize(c_new{i},[32,16])),save_figp);
            %saveas(imresize(c_new{i},[240,200]),save_figp);
            %imshow(imresize(c_new{i},[240,200]))
        end
        %imshowpair(enhanced_image ,our_images,'montage');
        end
        %close(figure);
    end
end

%figure(37)
%imshow(our_images)

%c_new = construct_new(enhanced_image,our_images);
%{
for i = 1:35
    figure(i+1)
    imshow(imresize(c_new{i},[240,200]))
end
%}
%{
for i = 1:35
   %Step 1. Convert the 3d matrix into a bunch of rows
    c_new{i} = mat2str(c_new{i});
end

sizeA = size(c_new');  
A_rows = reshape(c_new',[],sizeA(2))';
%Step 2. Call unique on the rows

A_unique = unique(A_rows,'stable','rows');
%Step 3. Reshape the rows back into a 3d matrix

A_unique = reshape( A_unique' ,sizeA(1),sizeA(2));
   %imshow(imresize(c_new{i},[240,200])); 

%}
function [y,z] = image_enhance(x)
[regions,cc] = detectMSERFeatures(x);
%print(cc);
y = regions;
z = cc;
end


function img = construct_new(x,our_images)
img = cell(1,x.Count);
for n = 1:x.Count
    max_x = 0;
    min_x = intmax;
    max_y = 0;
    min_y = intmax;
    for j = 1:size(x.PixelList{n},1)
        if(max_x < x.PixelList{n}(j,2))
            max_x = x.PixelList{n}(j,2);
        end
        if(max_y < x.PixelList{n}(j,1))
            max_y = x.PixelList{n}(j,1);
        end
        if(min_x > x.PixelList{n}(j,2))
            min_x = x.PixelList{n}(j,2);
        end
        if(min_y > x.PixelList{n}(j,1))
            min_y = x.PixelList{n}(j,1);
        end
    end
    %disp([max_x,min_x,max_y,min_y]);
    img{n} = imcrop(our_images,[min_y-1,min_x-1,max_y-min_y,max_x-min_x]);
end
end

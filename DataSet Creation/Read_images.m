total_folder = 'C:\Users\Roopesh\Desktop\DIP\Dataset'; %  Enter name of folder from which you want to upload pictures with full path
image_folders = dir(fullfile(total_folder,'*000*'));
total_datasets = numel(image_folders);
tots = 0;
l = [];
All_im = cell(1,284);
All_Gt = cell(1,284);
for k = 1:total_datasets
    filenames = dir(fullfile(image_folders(k).name, '*.bmp'));  % read all images with specified extention, its jpg in our case
    total_images = numel(filenames);    % count total number of photos present in that folder
    fid = fopen(fullfile(image_folders(k).name,'groundTruth.txt'),'r');
    % read file comments
    line = fgets(fid);
    while line(1) == '%'
        line = fgets(fid);
    end
    
    % read number of images
    numImages = sscanf(line, '%d', 1);

    
    
    for n = 1:total_images
        full_name= fullfile(image_folders(k).name, filenames(n).name);
        % get image name
        imageName = fscanf(fid, '%c',13);
        % get number of boxes
        numBoxes = fscanf(fid, '%d', 1);
        
        % get the boxes
        for j=1:numBoxes
            tmp = fscanf(fid, '%c',2); %% [space](
            coords = fscanf(fid, '%d %d %d %d');
            tmp = fscanf(fid, '%c',1); %% )
            ulX=coords(1); ulY=coords(2);
            lrX=coords(3); lrY=coords(4);
            boxes{j}.X = [ulX lrX lrX ulX ulX]';
            boxes{j}.Y = [ulY ulY lrY lrY ulY]';
        end 
        tmp = fgetl(fid); % get until end of line
        
  % it will specify images names with full path and extension
        our_images = imread(full_name);                 % Read images  
        %l = append([],our_images);
        %figure (n)                           % used tat index n so old figures are not over written by new new figures
        imshow(our_images);
        %colormap('gray');
        %axis('off');
        %title(sprintf('Image %d', i));
        hold on;
    
        % display the boxes
        for j=1:numBoxes
            plot(boxes{j}.X, boxes{j}.Y, 'y');
        end
        hold off;
        F = getframe ;
        tots = tots+1;
        All_Gt{tots} = F.cdata;
        All_im{tots} = our_images;
        close(figure);
        %imshow(our_images)                  % Show all images
    end
    fclose(fid);
end

save('y_train.mat', 'All_Gt');
save('x_train.mat', 'All_im');

Data_T = table(All_im',All_Gt');

%writetable(Data_T,'RCNNData.mat') 

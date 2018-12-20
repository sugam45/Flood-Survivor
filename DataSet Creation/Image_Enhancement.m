total_folder = 'C:\Users\Roopesh\Desktop\DIP\Dataset'; %  Enter name of folder from which you want to upload pictures with full path
image_folders = dir(fullfile(total_folder,'*000*'));
total_datasets = numel(image_folders);

tots = 0;
l = [];
Person = cell(1,284);
image = cell(1,284);
for k = 1:total_datasets
    filenames = dir(fullfile(total_folder,fullfile(image_folders(k).name, '*.bmp')));  % read all images with specified extention, its jpg in our case
    total_images = numel(filenames);    % count total number of photos present in that folder

    
    
    for n = 1:total_images
        full_name= fullfile(fullfile(total_folder,image_folders(k).name), filenames(n).name);
        our_images = imread(full_name);                 % Read images  
        %enhanced_image = histogram(our_images);
        %imshowpair(enhanced_image ,our_images,'montage');
        if(n == 40 && k == 9)
        %{
        figure(1);
        hold on;
        subplot(1,2,1);
        imshow(our_images);
        subplot(1,2,2);
        histogram(our_images);
        %}
        enhanced_image = image_enhance(our_images);
        imshowpair(enhanced_image ,our_images,'montage');
        end
        %close(figure);
    end
end
%{
function y = image_enhance(x) %
LEN = 3;
THETA = 0;
signal_var = var(im2double(x(:)));
uniform_quantization_var = (1/256)^2 / 12;
%noise_var = 0.0001;
PSF = fspecial('motion', LEN, THETA);
y = deconvwnr(x, PSF, uniform_quantization_var / signal_var);
end
%}
%{
function y = image_enhance(x) %histogram equalization
y = histeq(x);
end
%}
%{
function y = image_enhance(x) %morphological opening
se = strel('disk',15);
background = imopen(x,se);
y= x - background;
y = imadjust(y);
%y = imbinarize(y);
y = bwareaopen(y,50);
end
%}
%{
function y = image_enhance(x) %image sharpening
y = imsharpen(x);
end
%}
function y = image_enhance(x) %weighted average
y1 = imsharpen(x);
se = strel('disk',15);
background = imopen(x,se);
y2= x - background;
y2 = imadjust(y2);
%y = imbinarize(y);
y2 = bwareaopen(y2,50);
y3 = histeq(x);
LEN = 3;
THETA = 0;
signal_var = var(im2double(x(:)));
uniform_quantization_var = (1/256)^2 / 12;
%noise_var = 0.0001;
PSF = fspecial('motion', LEN, THETA);
y4 = deconvwnr(x, PSF, uniform_quantization_var / signal_var);
y = 0.25*(y1+y2+y3+y4);
end

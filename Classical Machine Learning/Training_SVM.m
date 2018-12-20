%ClassificationSVM
Data = load('C:\Users\Roopesh\Desktop\DIP\Features\00001\00001.mat');
D1 = Data.gTruth.LabelData.Person;

d = 0.955/0.5084;

D4 = cell(1339,1);
D5 = cell(1339,1);
D7 = cell(1339,1);
for i = 1:1339
    [filepath,name,ext] = fileparts(strrep(strrep(Data.gTruth.DataSource.Source{i},'New_Dataset','Features'),'-',''));
    ext = strrep(ext,'.bmp','.mat');
    D7{i} = load(fullfile(filepath,strcat(name,ext)));
    D5{i} = cell2mat(D7{i, 1}.descriptor_1);
end

imds = table(cell2mat(D5),categorical(D1));

idx = floor(0.6 * height(imds));
imdsTrain = imds(1:idx,:);
imdsTest = imds(idx:end,:);


%{
for i = 1:1339
    D6(:,i) = D5{i};
end
%}
SVMModel = fitcsvm(imdsTrain.Var1,imdsTrain.Var2,'KernelFunction','rbf','KernelScale','auto','Standardize',true);
CMdl = compact(SVMModel);

YPred = predict(CMdl,imdsTest.Var1);

YTest = imdsTest.Var2;

DTrue = cell(numel(YTest),1);

for i = 1:numel(YTest)
    DTrue = true;
end

DTrue = categorical(DTrue);

accuracy = d*sum((YPred == YTest) & (YTest == DTrue))/sum((YTest == DTrue));

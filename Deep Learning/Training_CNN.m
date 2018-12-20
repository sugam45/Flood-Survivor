Data = load('C:\Users\Roopesh\Desktop\DIP\Features\00001\00001.mat');

%D1 = cell(1,1339);

D1 = Data.gTruth.LabelData.Person;

D2 = cell(1339,1);
D3 = cell(1339,1);
for i = 1:1339
    D3{i} = imread(Data.gTruth.DataSource.Source{i});
    if(D1(i,:) == 1)
        D2{i} = '1';
    else
        D2{i} = '0';
    end
end

D2 = categorical(D2);



imds = table(D3,D2);

idx = floor(0.9 * height(imds));
imdsTrain = imds(1:idx,:);
imdsTest = imds(idx:end,:);

% Create image input layer.
inputLayer = imageInputLayer([32 16]);
% Define the convolutional layer parameters.
filterSize = [3 3];
numFilters = 32;
% Create the middle layers.
inputLayer = imageInputLayer([32 16]);
%{
middleLayers = [
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)   
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 1)  
    reluLayer() 
    maxPooling2dLayer(3, 'Stride',2)    
    ];
% Create the final layer.
finalLayers = [
    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    fullyConnectedLayer(64)
    % Add a ReLU non-linearity.
    reluLayer()
    % Add the last fully connected layer. At this point, the network must
    % produce outputs that can be used to measure whether the input image
    % belongs to one of the object classes or background. This measurement
    % is made using the subsequent loss layers.
    fullyConnectedLayer(2)
    % Add the softmax loss layer and classification layer. 
    softmaxLayer()
    classificationLayer()
];

% Combine the input, middle, and final layers.
layers = [
    inputLayer
    middleLayers
    finalLayers
    ];
%}

layers = [
    inputLayer
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    %reluLayer   
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    %reluLayer   
    %maxPooling2dLayer(2,'Stride',2)
    %convolution2dLayer(3,64,'Padding','same')
    %batchNormalizationLayer
    %reluLayer   
    % Add a fully connected layer with 64 output neurons. The output size
    % of this layer will be an array with a length of 64.
    fullyConnectedLayer(64)
    % Add a ReLU non-linearity.
    reluLayer()
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
    ];
%{
layers = [ ...
    imageInputLayer([32 16])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];
%}
    
options = trainingOptions('adam', ...
    'MaxEpochs',400,...
    'InitialLearnRate',1e-4, ...
    'ValidationData',imdsTest, ...
    'ValidationFrequency',5, ...
    'Verbose',true, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

%indices = crossvalind('Kfold',imdsTrain,10);

YPred = classify(net,imdsTest);
YTest = imdsTest.D2;

DTrue = cell(numel(YTest),1);

for i = 1:numel(YTest)
    DTrue = 0;
end

DTrue = categorical(DTrue);


accuracy = sum((YPred == YTest) & (YTest == DTrue))/sum((YTest == DTrue));

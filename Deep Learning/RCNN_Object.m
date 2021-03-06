DatasetFS = T;

%idx = floor(0.6 * height(DatasetFS));
trainingData = DatasetFS(1:31,:);
testData = DatasetFS(31:end,:);

% Create image input layer.
inputLayer = imageInputLayer([240 360]);

% Define the convolutional layer parameters.
filterSize = [3 3];
numFilters = 32;

% Create the middle layers.
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
    fullyConnectedLayer(width(DatasetFS))

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

% Options for step 1.
optionsStage1 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'OutputFcn',@(info)savetrainingplot(info),...
    'CheckpointPath', tempdir);

% Options for step 2.
optionsStage2 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'OutputFcn',@(info)savetrainingplot(info),...
    'CheckpointPath', tempdir);

% Options for step 3.
optionsStage3 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'OutputFcn',@(info)savetrainingplot(info),...
    'CheckpointPath', tempdir);
% Options for step 4.
optionsStage4 = trainingOptions('sgdm', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'OutputFcn',@(info)savetrainingplot(info),...
    'CheckpointPath', tempdir);
options = [
    optionsStage1
    optionsStage2
    optionsStage3
    optionsStage4
    ];
 %options = [optionsStage1];
 % Set random seed to ensure example training reproducibility.
rng(0);    
    % Train Faster R-CNN detector. Select a BoxPyramidScale of 1.2 to allow
    % for finer resolution for multiscale object detection.
    detector = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
        'NegativeOverlapRange', [0 0.3], ...
        'PositiveOverlapRange', [0.6 1], ...
        'NumRegionsToSample', [256 128 256 128], ...
        'BoxPyramidScale', 1.2);

function stop=savetrainingplot(info)
stop=false;  %prevents this function from ending trainNetwork prematurely
if info.State=='done'   %#ok<BDSCA> %check if all iterations have completed
% if true
        saveas(gcf,'filename.png')  % save figure as .png, you can change this
end
end

clc;
clear;

% Step 1: Generate all 6-bit binary sequences (2^6 = 64 combinations)
inputs = de2bi(0:63, 6, 'left-msb')';  % 6 x 64 matrix (each column is one input)

% Step 2: Define the target output
% 1 if number of 1's is even, 0 if odd
targets = mod(sum(inputs), 2) == 0;   % 1×64 logical array
targets = double(targets);           % convert to double precision

% Step 3: Create and configure the neural network
net = patternnet(10);  % 1 hidden layer with 10 neurons

net.trainFcn = 'trainlm';            % Training algorithm
net.performFcn = 'mse';              % Mean Squared Error

% Disable input/output pre-processing for binary inputs
net.inputs{1}.processFcns = {};
net.outputs{2}.processFcns = {};

net.divideFcn = 'dividerand';        % Random split
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;

net.trainParam.epochs = 200;
net.trainParam.goal = 1e-3;

% Step 4: Train the network
[net, tr] = train(net, inputs, targets);

% Step 5: Test the network
outputs = net(inputs);
predicted = round(outputs);  % convert to binary output
errors = abs(predicted - targets);
accuracy = 1 - sum(errors)/length(errors);

% Step 6: Display results
fprintf('Classification Accuracy: %.2f%%\n', accuracy * 100);

% Step 7: Confusion matrix
figure;
plotconfusion(targets, outputs);
title('Confusion Matrix');

% Optional: View the network
% view(net)

clc;
clear;

% Step 1: Generate training data
x = linspace(-4, 4, 20);
y = linspace(-4, 4, 20);
[X, Y] = meshgrid(x, y);

Z = 0.7 * exp(1).^cos(pi * X) + 0.3 * cos(2 * pi * Y);  % True function

inputs = [X(:)'; Y(:)'];  % 2 x 400 matrix
targets = Z(:)';          % 1 x 400 vector

% Step 2: Create and configure the neural network
net = feedforwardnet(10, 'trainlm');              % 1 hidden layer with 10 neurons
net.layers{1}.transferFcn = 'tansig';             % Hidden layer: tansig
net.layers{2}.transferFcn = 'purelin';            % Output layer: linear
net.inputs{1}.processFcns = {};                   % Disable default input preprocessing

net.divideFcn = 'dividerand';                     % Random data split
net.divideParam.trainRatio = 0.6;
net.divideParam.valRatio = 0.2;
net.divideParam.testRatio = 0.2;

net.trainParam.lr = 0.05;
net.trainParam.epochs = 150;
net.trainParam.goal = 1e-5;
net.trainParam.show = 50;

% Step 3: Train the network
net = train(net, inputs, targets);

% Step 4: Test on a dense grid
testX = linspace(-4, 4, 50);
testY = linspace(-4, 4, 50);
[TestX, TestY] = meshgrid(testX, testY);

testInputs = [TestX(:)'; TestY(:)'];  % 2 x 2500

% Compute true values for each (x,y) pair
trueValues = 0.7 * exp(1).^cos(pi * testInputs(1,:)) + 0.3 * cos(2 * pi * testInputs(2,:));

predictedValues = sim(net, testInputs);

% Step 5: Compute and display error
testMSE = mse(trueValues - predictedValues);
fprintf('Test Mean Squared Error: %.6f\n', testMSE);

% Step 6: Visualize results
Z_true = reshape(trueValues, 50, 50);
Z_pred = reshape(predictedValues, 50, 50);

figure;
subplot(1, 2, 1);
surf(testX, testY, Z_true);
title('True Function f(x, y)');
xlabel('x'); ylabel('y'); zlabel('f');
shading interp; view(3);

subplot(1, 2, 2);
surf(testX, testY, Z_pred);
title('Neural Network Approximation');
xlabel('x'); ylabel('y'); zlabel('f_{approx}');
shading interp; view(3);

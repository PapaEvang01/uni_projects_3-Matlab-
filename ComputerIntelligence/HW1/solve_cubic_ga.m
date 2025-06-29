clc; clear;

AM = 6; 
f = @(x) x.^3 + x.^2 + x + 50 + AM;

% Define fitness function as absolute value (we want f(x) ? 0)
fitness = @(x) abs(f(x));

% GA options
opts = optimoptions('ga', ...
    'MaxGenerations', 100, ...
    'Display', 'iter', ...
    'FunctionTolerance', 1e-4);

% Run GA on 1 variable in range [-10, 10]
[x, fval] = ga(fitness, 1, [], [], [], [], -10, 10, [], opts);

% Round result to 3 decimal places
x_rounded = round(x, 3);

fprintf('\n=== Solution ===\n');
fprintf('Root found: x = %.3f\n', x_rounded);
fprintf('f(x) = %.6f\n', f(x_rounded));

clc; clear;

cards = 1:15;
n = numel(cards);

% Each card is assigned to one of 3 stacks (1, 2, or 3)
intcon = 1:n;
lb = ones(1, n);       % Lower bound: group 1
ub = 3 * ones(1, n);   % Upper bound: group 3

% Define fitness function
fitness = @(x) calc_penalty(x, cards);

% GA options
opts = optimoptions('ga', ...
    'PopulationSize', 200, ...
    'MaxGenerations', 1000, ...
    'Display', 'iter');

% Run Genetic Algorithm
[x, fval] = ga(fitness, n, [], [], [], [], lb, ub, [], intcon, opts);

% Interpret solution
stack1 = cards(x == 1);
stack2 = cards(x == 2);
stack3 = cards(x == 3);

fprintf('\n=== Solution Found ===\n');
fprintf('Stack 1 (sum = %d): %s\n', sum(stack1), mat2str(stack1));
fprintf('Stack 2 (sum = %d): %s\n', sum(stack2), mat2str(stack2));
fprintf('Stack 3 (product = %d): %s\n', prod(stack3), mat2str(stack3));

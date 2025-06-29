clc;
clear;

% Step 1: Define city locations (X, Y coordinates)
locations = [1304 2312; 3639 1315; 4177 2244; 3712 1399; 3488 1535;
             3326 1556; 3238 1229; 4196 1044; 4312  790; 4386  570;
             3007 1970; 2562 1756; 2788 1491; 2381 1676; 1332  695;
             3715 1678; 3918 2179; 4061 2370; 3780 2212; 3676 2578;
             4029 2838; 4263 2931; 3429 1908; 3507 2376; 3394 2643;
             3439 3201; 2935 3240; 3140 3550; 2545 2357; 2778 2826;
             2370 2975];

n = size(locations, 1);  % Number of cities

% Plot the city coordinates
figure;
plot(locations(:,1), locations(:,2), 'bo');
title('City Map');
xlabel('X Coordinate');
ylabel('Y Coordinate');
grid on;

% Step 2: Compute the distance matrix between all city pairs
distances = zeros(n);
for i = 1:n
    for j = i:n
        dx = locations(i,1) - locations(j,1);
        dy = locations(i,2) - locations(j,2);
        d = sqrt(dx^2 + dy^2);
        distances(i,j) = d;
        distances(j,i) = d;  % symmetric
    end
end

% Step 3: Define fitness function and plot function
FitnessFcn = @(x) tsp_fitness(x, distances);
PlotFcn = @(options, state, flag) tsp_traveling_salesman_plot(options, state, flag, locations);

% Step 4: Configure Genetic Algorithm options
options = gaoptimset( ...
    'PopulationType', 'custom', ...
    'PopInitRange', [1; n], ...
    'CreationFcn', @tsp_create_permutations, ...
    'CrossoverFcn', @tsp_crossover_permutation, ...
    'MutationFcn', @tsp_mutate_permutation, ...
    'PlotFcn', PlotFcn, ...
    'Generations', 1000, ...
    'PopulationSize', 60, ...
    'StallGenLimit', 200, ...
    'Vectorized', 'on', ...
    'Display', 'iter');

% Step 5: Run the Genetic Algorithm
numberOfVariables = n;
[x, fval, reason, output] = ga(FitnessFcn, numberOfVariables, options);

% Step 6: Display final results
fprintf('\n=== Genetic Algorithm Result ===\n');
fprintf('Total tour length: %.2f\n', fval);
fprintf('Best route (city order):\n');
disp(x);
fprintf('Termination reason: %s\n', reason);

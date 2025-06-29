% Define problem inputs
weights = [8,17,12,20,15,8,8,15,16,15,12,18,18,12,16,16,15,7,17,16,14,12,9,13,12,16,11,17,9,12,13,14,19,15,17,17,17,19,20,14,13,18,19,14,19,14,17,17,9,17,14,8,9,18,14,13,11,9,17,10,19,17,9,8,11,10,7,12,16,11,10,19,7,10,10,7,13,18,13,10,17,19,14,14,15,13,8,13,19,20,10,8,10,7,18,20,8,8,14,17];
values = [356,367,309,338,392,339,338,390,317,343,392,369,359,390,367,313,325,351,372,321,302,359,359,350,371,330,304,367,345,346,368,365,346,351,384,363,368,391,348,367,343,307,305,378,316,323,340,394,328,342,383,364,372,302,380,352,303,384,334,357,345,348,316,323,312,321,374,351,308,321,329,379,381,301,327,356,378,387,354,351,382,371,382,347,375,314,338,319,349,329,341,324,390,365,365,377,399,315,330,352];
max_weight = 27;

% Define GA options
options = optimoptions('ga', 'PopulationSize', 50, 'MaxGenerations', 100, 'Display', 'off', 'MutationFcn', {@mutationadaptfeasible, 0.1}, 'CrossoverFcn', @crossoverarithmetic);

% Define fitness function
fitness_func = @(x) -1 * (x * values' + (max_weight - x * weights') * 1000 * (max_weight < x * weights')) / max(x * values' + (max_weight - x * weights') * 1000 * (max_weight < x * weights'));


% Solve using GA
[x, fval] = ga(fitness_func, length(weights), [], [], [], [], zeros(length(weights), 1), ones(length(weights), 1), [], options);



% Print results
fprintf('Selected items: %s\n', num2str(find(x>0.5)));
fprintf('Total value: %f\n', -1 * fval);
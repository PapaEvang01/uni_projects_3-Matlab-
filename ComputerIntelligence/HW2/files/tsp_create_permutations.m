function pop = tsp_create_permutations(nVars, FitnessFcn, options)
%TSP_CREATE_PERMUTATIONS Custom initial population function for TSP.
%   Generates a population of valid permutations (random tours).
%
%   Inputs:
%     nVars      - Number of cities (size of each individual)
%     FitnessFcn - Fitness function (not used here)
%     options    - GA options structure (used to get population size)
%
%   Output:
%     pop        - Cell array of random permutations (initial population)

totalPopulationSize = sum(options.PopulationSize);
pop = cell(totalPopulationSize, 1);  % Preallocate cell array

for i = 1:totalPopulationSize
    pop{i} = randperm(nVars);  % Each individual is a random tour
end

end

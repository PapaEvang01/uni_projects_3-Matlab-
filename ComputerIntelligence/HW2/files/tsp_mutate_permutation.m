function mutationChildren = tsp_mutate_permutation(parents, options, nVars, ...
    FitnessFcn, state, thisScore, thisPopulation, mutationRate)
%TSP_MUTATE_PERMUTATION Custom mutation function for the Traveling Salesman Problem.
%   This function applies swap mutation on permutations by swapping two cities.
%
%   Inputs:
%     parents        - Indices of parents selected for mutation
%     options        - GA options structure
%     nVars          - Number of variables (cities)
%     FitnessFcn     - Fitness function (unused here)
%     state          - Current state of the GA
%     thisScore      - Scores of current population
%     thisPopulation - Current population (cell array of permutations)
%     mutationRate   - Mutation rate (unused here but can be incorporated)
%
%   Output:
%     mutationChildren - Cell array containing the mutated children

mutationChildren = cell(length(parents), 1);  % Initialize child cell array

for i = 1:length(parents)
    parent = thisPopulation{parents(i)};      % Get parent permutation
    child = parent;

    % Randomly choose two distinct indices to swap
    swap_idx = randperm(nVars, 2);
    % Perform the swap
    temp = child(swap_idx(1));
    child(swap_idx(1)) = child(swap_idx(2));
    child(swap_idx(2)) = temp;

    mutationChildren{i} = child;  % Save mutated child
end

end

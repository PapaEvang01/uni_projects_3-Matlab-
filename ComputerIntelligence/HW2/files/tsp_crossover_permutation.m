function xoverKids = tsp_crossover_permutation(parents, options, nVars, ...
    FitnessFcn, thisScore, thisPopulation)
%TSP_CROSSOVER_PERMUTATION Custom crossover function for the TSP.
%   Creates offspring by reversing a random subsegment of a parent.
%
%   Inputs:
%     parents        - Indices of selected parents (should be even length)
%     options        - GA options structure
%     nVars          - Number of cities
%     FitnessFcn     - Fitness function (unused here)
%     thisScore      - Current fitness scores
%     thisPopulation - Current population (cell array of permutations)
%
%   Output:
%     xoverKids      - Cell array of children (1 per crossover event)

nKids = floor(length(parents) / 2);     % Each pair produces 1 child
xoverKids = cell(nKids, 1);             % Preallocate child array

index = 1;

for i = 1:nKids
    % Get the first parent from the pair
    parent = thisPopulation{parents(index)};
    index = index + 2;  % Move to the next pair
    
    % Generate two distinct crossover points
    cut1 = randi(nVars - 1);            % start index
    cut2 = cut1 + randi(nVars - cut1);  % end index (ensures cut2 > cut1)
    
    % Create child by reversing the subsegment
    child = parent;
    child(cut1:cut2) = fliplr(parent(cut1:cut2));
    
    % Store the child
    xoverKids{i} = child;
end

end

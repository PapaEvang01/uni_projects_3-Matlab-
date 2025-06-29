function scores = tsp_fitness(x, distances)
%TSP_FITNESS Fitness function for the Traveling Salesman Problem (TSP).
%   Computes the total length of each tour (i.e., each permutation of cities)
%   based on the provided distance matrix.
%
%   Inputs:
%     x         - Cell array of permutations (each individual is a 1×n vector)
%     distances - Precomputed distance matrix (n×n)
%
%   Output:
%     scores    - Column vector of tour lengths (1 per individual)

scores = zeros(size(x, 1), 1);  % Preallocate score vector

for j = 1:size(x, 1)
    route = x{j};  % Retrieve one permutation (a possible route)
    
    % Start with the distance from last city back to the first
    total_distance = distances(route(end), route(1));
    
    % Add up the distances between consecutive cities
    for i = 2:length(route)
        total_distance = total_distance + distances(route(i-1), route(i));
    end
    
    scores(j) = total_distance;
end

end

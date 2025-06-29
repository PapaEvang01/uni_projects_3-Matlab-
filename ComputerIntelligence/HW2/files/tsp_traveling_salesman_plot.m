function state = tsp_traveling_salesman_plot(options, state, flag, locations)
%TSP_TRAVELING_SALESMAN_PLOT Custom plot function for the Traveling Salesman Problem.
%   Plots the current best route found by the GA at each generation.
%
%   Inputs:
%       options   - GA options structure
%       state     - Current state of the GA
%       flag      - Plotting stage (not used here)
%       locations - City coordinates (Nx2 array)
%
%   Output:
%       state - unchanged GA state (required by GA framework)

% Get the index of the best individual in the current population
[~, idx] = min(state.Score);
best_route = state.Population{idx};

% Plot the cities
plot(locations(:,1), locations(:,2), 'bo');
hold on;

% Plot the path connecting the cities
plot(locations(best_route,1), locations(best_route,2), 'r-', 'LineWidth', 1.5);

% Optionally, connect the last city back to the first (to close the loop)
plot([locations(best_route(end),1), locations(best_route(1),1)], ...
     [locations(best_route(end),2), locations(best_route(1),2)], ...
     'r-', 'LineWidth', 1.5);

title('Best Route Found');
xlabel('X Coordinate');
ylabel('Y Coordinate');
grid on;
hold off;

end

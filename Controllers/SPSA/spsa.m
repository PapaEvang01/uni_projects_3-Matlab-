% ==========================================================
% spsa.m
% ----------------------------------------------------------
% Implements the Simultaneous Perturbation Stochastic Approximation (SPSA)
% algorithm to optimize PID gains using a noisy cost function.
% Only requires two cost evaluations per iteration.
% ==========================================================

function best_gains = spsa(cost_fn, theta0, max_iter, a, c)
    theta = theta0;

    for k = 1:max_iter
        ak = a / (k+1)^0.602;
        ck = c / (k+1)^0.101;

        % Generate perturbation vector (+1/-1)
        delta = 2 * randi([0,1], size(theta)) - 1;

        % Evaluate cost at perturbed points
        theta_plus  = theta + ck * delta;
        theta_minus = theta - ck * delta;

        y_plus  = cost_fn(theta_plus);
        y_minus = cost_fn(theta_minus);

        % SPSA gradient estimate
        ghat = (y_plus - y_minus) ./ (2 * ck * delta);

        % Gradient descent step
        theta = theta - ak * ghat;

        % Clamp gains to safe bounds [0, 1.5]
        theta = max(min(theta, 1.5), 0);

        % Compute current cost
        current_cost = cost_fn(theta);

        % Logging
        fprintf('Iter %3d: PID = [%6.3f, %6.3f, %6.3f], Cost = %.2f\n', ...
                k, theta(1), theta(2), theta(3), current_cost);

        % Optional early stopping
        if current_cost < 10
            fprintf('Early stopping at iteration %d\n', k);
            break;
        end
    end

    best_gains = theta;
end

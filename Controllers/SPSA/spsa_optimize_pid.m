% ==========================================================
% spsa_optimize_pid.m
% ----------------------------------------------------------
% Main script: initializes the PID tuning, runs SPSA optimization,
% visualizes the system response, and saves the results.
% ==========================================================

clc; clear;

% Initial PID guess (small but nonzero)
theta0 = [0.8, 0.1, 0.05];

% SPSA hyperparameters
a = 0.0025;     % learning rate
c = 0.001;      % perturbation size
max_iter = 100;

% Cost function (linked to simulation)
cost_fn = @(pid) simulate_pid_response(pid);

% Run SPSA optimizer
best_gains = spsa(cost_fn, theta0, max_iter, a, c);
final_cost = cost_fn(best_gains);

fprintf('\n? Optimal PID Gains:\n');
disp(best_gains);

% Run simulation and plot the result
simulate_and_plot(best_gains);

% Save results to a text file
save_results_to_txt('pid_optimization_results.txt', best_gains, final_cost);

% ------------------------------
% Visualization function
% ------------------------------
function simulate_and_plot(pid_gains)
    Kp = pid_gains(1); Ki = pid_gains(2); Kd = pid_gains(3);
    tspan = [0 10]; y0 = [0; 0]; reference = 1;
    integral_error = 0; prev_error = 0;

    function dxdt = dynamics(t, x)
        y = x(1); dy = x(2);
        error = reference - y;
        integral_error = max(min(integral_error + error * 0.01, 5), -5);
        derivative_error = (error - prev_error) / 0.01;
        prev_error = error;
        u = Kp * error + Ki * integral_error + Kd * derivative_error;
        u = max(min(u, 10), -10);
        wn = 2*pi; zeta = 0.7;
        ddy = wn^2 * (u - y) - 2*zeta*wn*dy;
        dxdt = [dy; ddy];
    end

    [t, y] = ode45(@dynamics, tspan, y0);
    figure;
    plot(t, y(:,1), 'b', 'LineWidth', 2); hold on;
    yline(reference, 'r--', 'LineWidth', 1.5);
    title('System Response with Optimized PID Controller');
    xlabel('Time (s)'); ylabel('Output y(t)');
    legend('System Output', 'Reference Signal');
    grid on;
end

% ------------------------------
% Save Results to Text File
% ------------------------------
function save_results_to_txt(filename, pid_gains, cost)
    fid = fopen(filename, 'w');
    if fid == -1
        warning('Failed to open file for writing.');
        return;
    end

    fprintf(fid, 'SPSA-PID Optimization Results\n');
    fprintf(fid, '-----------------------------\n');
    fprintf(fid, 'Optimal PID Gains:\n');
    fprintf(fid, 'Kp = %.6f\n', pid_gains(1));
    fprintf(fid, 'Ki = %.6f\n', pid_gains(2));
    fprintf(fid, 'Kd = %.6f\n', pid_gains(3));
    fprintf(fid, '\nFinal Cost (Objective Value): %.6f\n', cost);
    fprintf(fid, 'Saved on: %s\n', datestr(now));

    fclose(fid);
    fprintf('[?] Results saved to "%s"\n', filename);
end

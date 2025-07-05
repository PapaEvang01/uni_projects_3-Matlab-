% ==========================================================
% lqr_controller_design.m
% ----------------------------------------------------------
% Designs an LQR controller for a second-order system,
% simulates the closed-loop response, and logs results.
% ==========================================================

clc; clear;

% System parameters (mass-spring-damper-like)
zeta = 0.7;         % Damping ratio
wn = 2 * pi;        % Natural frequency (rad/s)

% Define state-space matrices
A = [0 1; -wn^2 -2*zeta*wn];
B = [0; 1];
C = [1 0];
D = 0;

% Define LQR cost weights
Q = C' * C;         % Penalize position error
R = 0.1;            % Penalize control effort

% Compute optimal gain
K = lqr(A, B, Q, R);

% Initial state: position = 1, velocity = 0
x0 = [1; 0];

% Simulate closed-loop system
[t, x, u] = simulate_lqr_response(A, B, K, x0);

% Plot position and control effort
figure;
subplot(2,1,1);
plot(t, x(:,1), 'b', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Position y(t)');
title('System Output');
grid on;

subplot(2,1,2);
plot(t, u, 'r', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Control Input u(t)');
title('Control Effort');
grid on;

% Log results to .txt file
save_lqr_results('lqr_results.txt', K, x(end,:));

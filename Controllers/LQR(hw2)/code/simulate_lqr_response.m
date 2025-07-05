function [t, x, u] = simulate_lqr_response(A, B, K, x0)
    % Closed-loop system: dx/dt = (A - BK)x
    A_cl = A - B * K;

    % Simulate with ode45
    tspan = [0 10];
    [t, x] = ode45(@(t, x) A_cl * x, tspan, x0);

    % Compute control input: u(t) = -Kx(t)
    u = zeros(size(t));
    for i = 1:length(t)
        u(i) = -K * x(i,:)';
    end
end

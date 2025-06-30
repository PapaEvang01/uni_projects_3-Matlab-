% ==========================================================
% simulate_pid_response.m
% ----------------------------------------------------------
% Simulates a second-order system with a given PID controller.
% Returns a cost value based on tracking error, final accuracy,
% and overshoot (used by SPSA to evaluate PID performance).
% ==========================================================

function cost = simulate_pid_response(pid_gains)
    % Unpack gains
    Kp = pid_gains(1); Ki = pid_gains(2); Kd = pid_gains(3);

    % Reject invalid or extreme PID values
    if any(~isfinite(pid_gains)) || any(pid_gains < 0) || any(pid_gains > 1.5)
        cost = 1e6; return;
    end

    % Simulation setup
    tspan = [0 10];
    y0 = [0; 0];         % Initial conditions: [y; dy/dt]
    reference = 1;
    integral_error = 0;
    prev_error = 0;

    % Define ODE system with nested function
    function dxdt = dynamics(t, x)
        y = x(1); dy = x(2);
        error = reference - y;

        % PID terms
        integral_error = max(min(integral_error + error * 0.01, 5), -5); % anti-windup
        derivative_error = (error - prev_error) / 0.01;
        prev_error = error;

        u = Kp * error + Ki * integral_error + Kd * derivative_error;
        u = max(min(u, 10), -10); % saturate control input

        wn = 2 * pi; zeta = 0.7; % second-order system
        ddy = wn^2 * (u - y) - 2*zeta*wn*dy;
        dxdt = [dy; ddy];
    end

    % Run simulation
    try
        [~, y] = ode45(@dynamics, tspan, y0);
        error = reference - y(:,1);

        % Smarter cost: tracking + settling + overshoot
        settling_error = abs(error(end));
        overshoot = max(0, max(y(:,1)) - reference);
        cost = sum(error.^2) + 20 * settling_error + 10 * overshoot;

    catch
        cost = 1e6; % penalize if ODE fails
    end
end

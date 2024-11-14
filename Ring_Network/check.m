clc; clear; close all;

% Parameter setup
N = 360;  % Number of neurons
theta = linspace(0, 2 * pi * (N-1) / N, N)';   % Neuron preferred angles (add 1 to include 2*pi)
J_0 = -0.5;  % Global synaptic strength
J_1 = 2.5;  % Feature-specific synaptic strength
I_0 = 1;  % Uniform external input
I_1 = 0;  % Feature-specific external input strength
theta_0 = pi / 4;  % Center of external stimulus
max_iterations = 10^5;  % Maximum number of iterations
tolerance = 1e-4;  % Convergence threshold

% Construct the weight matrix W
W = zeros(N, N);
for i = 1:N
    for j = 1:N
        W(i, j) = (J_0 + J_1 * cos(theta(i) - theta(j))) / N;
    end
end

% Compute the external input I
I = I_0 + I_1 * cos(theta - theta_0);
activation_func = 'ReLU';

% Initialize the neuronal states u
% u = zeros(N, 1);
% u = initializing_u(N, 'Cos');
% u = initializing_u(N, 'Gaussian_v2');
% u = initializing_u(N, 'Linear');
rng(100);
u = initializing_u(N, 'Uniform');

% Iteratively update the neuronal states
for iteration = 1:max_iterations
    u_prev = u;
    u_input = W * u + I;

    % Apply the ReLU function
    u = apply_activation(u_input, activation_func);

    % Check for convergence
    if norm(u - u_prev) / N < tolerance
        fprintf('The network converged after %d iterations.\n', iteration);
        break;
    end
end

if iteration == max_iterations
    disp('The network did not converge within the maximum number of iterations.');
end

plot_theta_u(theta, u)
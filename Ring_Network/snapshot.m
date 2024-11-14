clear; close all;

% Parameter setup
N = 360;  % Number of neurons
theta = linspace(0, 2 * pi, N + 1)';  % Neuron preferred angles (add 1 to include 2*pi)
theta(end) = [];  % Remove the last element to keep N points in [0, 2*pi)
J_0 = 0.8;  % Global synaptic strength
J_1 = 0.5;  % Feature-specific synaptic strength
I_0 = 0.5;  % Uniform external input
I_1 = 0.2;  % Feature-specific external input strength
theta_0 = pi;  % Center of external stimulus
max_iterations = 10^4;  % Maximum number of iterations
tolerance = 1e-4;  % Convergence threshold
activation_func = 'ReLU';  % Choose activation function ('ReLU', 'sigmoid', 'tanh', 'none')

% Construct the weight matrix W
W = zeros(N, N);
for i = 1:N
    for j = 1:N
        W(i, j) = (J_0 + J_1 * cos(theta(i) - theta(j))) / N;
    end
end

% Compute the external input I
I = I_0 + I_1 * cos(theta - theta_0);

% Initialize the neuronal states u
rng(100);
% mu = 0;
% sigma = 0.1;
% u = mu + sigma * randn(N, 1);
u = rand(N, 1);

% Set up variables to store activity snapshots
snapshot_intervals = [0, 1:10, 20];  % Include initial state (iteration 0) in the snapshots
snapshot_data = zeros(N, length(snapshot_intervals));  % Store activity snapshots
snapshot_data(:, 1) = u;  % Store initial state as the first snapshot
snapshot_idx = 2;

% Iteratively update the neuronal states
for iteration = 1:max_iterations
    u_prev = u;
    u_input = W * u + I;
    
    % Apply the chosen activation function
    u = apply_activation(u_input, activation_func);
    disp(max(u))
    
    % Capture snapshots at specified intervals
    if ismember(iteration, snapshot_intervals)
        snapshot_data(:, snapshot_idx) = u;
        snapshot_idx = snapshot_idx + 1;
    end
    
    % Check for convergence
    if norm(u - u_prev) < tolerance
        fprintf('The network converged after %d iterations.\n', iteration);
        break;
    end
end

if iteration == max_iterations
    disp('The network did not converge within the maximum number of iterations.');
end

% Plot the evolution of neuronal activity
figure('Position', [100, 100, 1000, 600]);
for i = 1:length(snapshot_intervals)
    subplot(ceil(length(snapshot_intervals) / 2), 2, i);
    plot(theta, snapshot_data(:, i), 'o-');
    xlabel('Neuron Preferred Angle \theta');
    ylabel('Activity Level u(\theta)');
    if snapshot_intervals(i) == 0
        title('Initial State (Iteration 0)');
    else
        title(sprintf('Iteration %d', snapshot_intervals(i)));
    end
    xlim([0, 2 * pi]);
    xticks(0:pi/2:2*pi);
    xticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});
end

sgtitle('Evolution of Neuronal Activity Distribution Over Iterations');
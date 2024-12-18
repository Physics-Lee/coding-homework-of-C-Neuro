clear; clc; close all;

%%
rng(42)

%% Parameters
N = 1000;                 % Total number of neurons
N_E = 500;                % Number of excitatory neurons (indices 1 to 500)
N_I = 500;                % Number of inhibitory neurons (indices 501 to 1000)
p = 0.1;                  % Connection probability (K = p * N)
K = round(p * N);         % Number of connections per neuron
tau = 1e-2;               % Time constant (10 ms)
dt = 1e-3;                % Time step (0.1 ms)
T = 10;                    % Total simulation time (1 second)
steps = T / dt;           % Number of time steps

%% Weight Parameters
wEE = 1;                  % Base weight for E->E connections
wIE = 1;                  % Weight for E->I connections
wEI = 1.1;                  % Weight for I->E connections
wII = 1.1;                  % Weight for I->I connections

%% External input weights
c_out = 10;
hE = c_out * sqrt(K) * wEE; % Constant external input for E neurons
% hI = c_out * sqrt(K) * wIE; % Constant external input for I neurons
hI = 0.8 * c_out * sqrt(K) * wIE; % Constant external input for I neurons

%% Question 1
alpha_E = wEI / wEE
alpha_I = wII / wIE
beta_E = c_out
beta_I = c_out * 0.8
r_I = (beta_E - beta_I) / (alpha_E - alpha_I)
r_E = (beta_E*alpha_I-beta_I*alpha_E)/(alpha_E - alpha_I)

%% Define neuron groups
E_neurons = 1:N_E;        % Excitatory neurons (1 to 500)
I_neurons = (N_E+1):N;    % Inhibitory neurons (501 to 1000)

%% Synaptic Connectivity

% Create explicit lists of presynaptic connections for each neuron
connections_E = cell(N_E, 1);  % Excitatory neurons' presynaptic connections
connections_I = cell(N_I, 1);  % Inhibitory neurons' presynaptic connections

% Generate connections for excitatory neurons
for i = 1:N_E
    % Connect to other Excitatory neurons
    targets_E = randperm(N_E, K);
    % Connect to Inhibitory neurons
    targets_I = randperm(N_I, K) + N_E; % Offset for inhibitory indices
    % Store connections
    connections_E{i} = [targets_E, targets_I];
end

% Generate connections for inhibitory neurons
for i = 1:N_I
    % Connect to Excitatory neurons
    targets_E = randperm(N_E, K);
    % Connect to other Inhibitory neurons
    targets_I = randperm(N_I, K) + N_E; % Offset for inhibitory indices
    % Store connections
    connections_I{i} = [targets_E, targets_I];
end

%% Initialize Activity Variables
rE = rand(N_E, 1);     % Firing rates of E neurons
rI = rand(N_I, 1);     % Firing rates of I neurons
I_E = rand(N_E, 1);    % Input currents to E neurons
I_I = rand(N_I, 1);    % Input currents to I neurons

% Record activity for visualization
rE_record = zeros(N_E, steps);
rI_record = zeros(N_I, steps);

%% Simulation Loop
for t = 1:steps
    % Update Excitatory neurons
    for i = 1:N_E
        presynaptic_neurons = connections_E{i}; % Get connections
        % Split into Excitatory and Inhibitory presynaptic contributions
        presynaptic_rates = [rE(presynaptic_neurons(presynaptic_neurons <= N_E)); ...
                             rI(presynaptic_neurons(presynaptic_neurons > N_E) - N_E)];
        % Update input current using weights
        I_E(i) = I_E(i) + (-I_E(i) + sum(presynaptic_rates(1:K) * wEE / sqrt(K)) ...
                           - sum(presynaptic_rates(K+1:end) * wEI / sqrt(K)) + hE) * dt / tau;
    end
    
    % Update Inhibitory neurons
    for i = 1:N_I
        presynaptic_neurons = connections_I{i}; % Get connections
        % Split into Excitatory and Inhibitory presynaptic contributions
        presynaptic_rates = [rE(presynaptic_neurons(presynaptic_neurons <= N_E)); ...
                             rI(presynaptic_neurons(presynaptic_neurons > N_E) - N_E)];
        % Update input current using weights
        I_I(i) = I_I(i) + (-I_I(i) + sum(presynaptic_rates(1:K) * wIE / sqrt(K)) ...
                           - sum(presynaptic_rates(K+1:end) * wII / sqrt(K)) + hI) * dt / tau;
    end
    
    % Update firing rates with ReLU activation
    rE = max(0, I_E); % Excitatory activity
    rI = max(0, I_I); % Inhibitory activity
    
    % Record activity
    rE_record(:, t) = rE;
    rI_record(:, t) = rI;
end

%% Visualization
time = (0:steps-1) * dt;

% Population Activity
plot_mean_r(time, rE_record, rI_record, wEE, wIE, wEI, wII, c_out)

% Raster plot
figure;
subplot(2, 1, 1);
imagesc(time, 1:N_E, rE_record);
xlabel('Time (s)');
ylabel('Neuron Index');
title('E Population Activity');
colorbar;

subplot(2, 1, 2);
imagesc(time, 1:N_I, rI_record);
xlabel('Time (s)');
ylabel('Neuron Index');
title('I Population Activity');
colorbar;

% Prototype
figure;
plot(time, rE_record(1,:));
hold on;
plot(time, rI_record(1,:));
xlabel('Time (s)');
ylabel('r');
legend("E Neuron 1","I Neuron 1");

%%
plot_neural_correlations(rE_record)
plot_neural_correlations(rI_record)
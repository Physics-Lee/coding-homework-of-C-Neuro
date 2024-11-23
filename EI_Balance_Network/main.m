% E-I Balanced Network Simulation in MATLAB
clear; clc;

% Parameters
N = 1000;             % Total number of neurons in each population
p = 0.1;              % Connection probability (K = p * N)
K = round(p * N);     % Number of connections per neuron
tau = 10e-3;          % Time constant (10 ms)
dt = 1e-4;            % Time step (0.1 ms)
T = 1;                % Total simulation time (1 second)
steps = T / dt;       % Number of time steps

% Weight parameters
wEE = 1;              % Base synaptic weight
alphaE = 0.5;         % Scaling factor for wEI
alphaI = 0.5;         % Scaling factor for wII
betaE = 0.2;          % External input scaling for E population
betaI = 0.2;          % External input scaling for I population
wEI = alphaE * wEE;
wII = alphaI * wEE;
w0E = betaE * wEE;
w0I = betaI * wEE;

% Synaptic weight matrices (diluted connectivity)
JEE = (wEE / sqrt(K)) * (rand(N, N) < p);  % E to E
JEI = (wEI / sqrt(K)) * (rand(N, N) < p);  % I to E
JIE = (wEI / sqrt(K)) * (rand(N, N) < p);  % E to I
JII = (wII / sqrt(K)) * (rand(N, N) < p);  % I to I

% External input
hE = sqrt(K) * w0E;
hI = sqrt(K) * w0I;

% Activity variables
rE = zeros(N, 1);     % Firing rates of E neurons
rI = zeros(N, 1);     % Firing rates of I neurons
I_E = zeros(N, 1);    % Input currents to E neurons
I_I = zeros(N, 1);    % Input currents to I neurons

% Store firing rates for visualization
rE_record = zeros(N, steps);
rI_record = zeros(N, steps);

% Simulation
for t = 1:steps
    % Update input currents (Euler integration)
    dI_E = (-I_E + JEE * rE - JEI * rI + hE) * dt / tau;
    dI_I = (-I_I + JIE * rE - JII * rI + hI) * dt / tau;
    I_E = I_E + dI_E;
    I_I = I_I + dI_I;
    
    % Update firing rates with ReLU activation
    rE = max(0, I_E); % ReLU: rE = max(0, I_E)
    rI = max(0, I_I); % ReLU: rI = max(0, I_I)
    
    % Record firing rates
    rE_record(:, t) = rE;
    rI_record(:, t) = rI;
end

% Plot results
time = (0:steps-1) * dt;

% Average firing rates
avg_rE = mean(rE_record, 1);
avg_rI = mean(rI_record, 1);

figure;
plot(time, avg_rE, 'LineWidth', 2);
hold on;
plot(time, avg_rI, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Average Firing Rate');
legend('E Population', 'I Population');
title('E-I Balanced Network Firing Rates');
grid on;

% Raster plot of neuronal activity (optional)
figure;
subplot(2, 1, 1);
imagesc(time, 1:N, rE_record);
xlabel('Time (s)');
ylabel('Neuron Index');
title('E Population Activity');
colorbar;

subplot(2, 1, 2);
imagesc(time, 1:N, rI_record);
xlabel('Time (s)');
ylabel('Neuron Index');
title('I Population Activity');
colorbar;

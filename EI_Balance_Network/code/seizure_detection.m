function is_seizure = seizure_detection(wII_range, c_out_range)
% Function to determine seizure state based on grid search over wII and c_out
%
% Inputs:
% wII_range - Range of wII values (e.g., 0.1:0.1:1.0)
% c_out_range - Range of c_out values (e.g., 1.0:1.0:10.0)
%
% Output:
% is_seizure - Matrix indicating seizure state for each combination of wII and c_out

%% Parameters
N = 1000;                 % Total number of neurons
N_E = 500;                % Number of excitatory neurons
N_I = 500;                % Number of inhibitory neurons
p = 0.1;                  % Connection probability (K = p * N)
K = round(p * N);         % Number of connections per neuron
tau = 1e-2;               % Time constant
dt = 1e-3;                % Time step
T = 5;                   % Total simulation time
steps = T / dt;           % Number of time steps

% Fixed weight parameters
wEE = 0.5;
wIE = 0.5;

%% Initialize results matrix
is_seizure = zeros(length(wII_range), length(c_out_range));

%% Grid Search
count = 0;
for i = 1:length(wII_range)
    for j = 1:length(c_out_range)
        count = count + 1;

        % Update weights
        wII = wII_range(i);
        wEI = wII; % Constraint: wEI equals wII
        c_out = c_out_range(j);
        hE = c_out * sqrt(K) * wEE; % Constant external input for E neurons
        hI = c_out * sqrt(K) * wIE; % Constant external input for I neurons

        %% Define neuron groups
        E_neurons = 1:N_E;        % Excitatory neurons
        I_neurons = (N_E+1):N;    % Inhibitory neurons

        %% Synaptic Connectivity
        % Create explicit lists of presynaptic connections for each neuron
        connections_E = cell(N_E, 1);  % Excitatory neurons' presynaptic connections
        connections_I = cell(N_I, 1);  % Inhibitory neurons' presynaptic connections

        % Generate connections for excitatory neurons
        for k = 1:N_E
            targets_E = randperm(N_E, K);
            targets_I = randperm(N_I, K) + N_E; % Offset for inhibitory indices
            connections_E{k} = [targets_E, targets_I];
        end

        % Generate connections for inhibitory neurons
        for k = 1:N_I
            targets_E = randperm(N_E, K);
            targets_I = randperm(N_I, K) + N_E; % Offset for inhibitory indices
            connections_I{k} = [targets_E, targets_I];
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
            for k = 1:N_E
                presynaptic_neurons = connections_E{k};
                presynaptic_rates = [rE(presynaptic_neurons(presynaptic_neurons <= N_E)); ...
                    rI(presynaptic_neurons(presynaptic_neurons > N_E) - N_E)];
                I_E(k) = I_E(k) + (-I_E(k) + sum(presynaptic_rates(1:K) * wEE / sqrt(K)) ...
                    - sum(presynaptic_rates(K+1:end) * wEI / sqrt(K)) + hE) * dt / tau;
            end

            % Update Inhibitory neurons
            for k = 1:N_I
                presynaptic_neurons = connections_I{k};
                presynaptic_rates = [rE(presynaptic_neurons(presynaptic_neurons <= N_E)); ...
                     rI(presynaptic_neurons(presynaptic_neurons > N_E) - N_E)];
                I_I(k) = I_I(k) + (-I_I(k) + sum(presynaptic_rates(1:K) * wIE / sqrt(K)) ...
                    - sum(presynaptic_rates(K+1:end) * wII / sqrt(K)) + hI) * dt / tau;
            end

            % Update firing rates with ReLU activation
            rE = max(0, I_E); % Excitatory activity
            rI = max(0, I_I); % Inhibitory activity

            % Avoid Inf
            if max(rE) > 10^4 || max(rI) > 10^4
                continue;
            end

            % Record activity
            rE_record(:, t) = rE;
            rI_record(:, t) = rI;
        end

        %% Calculate std/mean of last rE and rI
        std_mean_ratio_E = std(rE) / mean(rE);
        std_mean_ratio_I = std(rI) / mean(rI);

        % Determine seizure state
        if std_mean_ratio_E < 0.1 && std_mean_ratio_I < 0.1
            is_seizure(i, j) = 1;
        else
            is_seizure(i, j) = 0;
        end

        if mod(count,1) == 0
            %% Visualization
            time = (0:steps-1) * dt;
            plot_mean_r(time, rE_record, rI_record, wEE, wIE, wEI, wII, c_out)
        end
    end
end
end
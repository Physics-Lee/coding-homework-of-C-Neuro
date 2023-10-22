clc;
clear;
close all;
tic

% Constants
V_threshold = 1; % dimensionless
tau = 1e-2; % s
tau_adapt = 0.2; % s
J_adapt = 1; % dimensionless
baseline_current = V_threshold; % dimensionless

% Time step configuration
time_step = 1e-4; % s
time_step_ratio = time_step / tau;
time_step_ratio_adapt = time_step / tau_adapt;
total_time = 10; % s
n_steps = ceil(total_time / time_step);

% Current and Neuron setup
range_of_I_e = baseline_current + [0.001:0.001:0.01, 0.01:0.01:1]; % dimensionless
n_currents = length(range_of_I_e);

% Initialize
spike_times = cell(1, n_currents);
average_firing_rate = zeros(1, n_currents);
V = zeros(1, n_currents);
I_adapt = zeros(1, n_currents);
n_spikes = zeros(1, n_currents);
V_trace = zeros(n_currents, n_steps);
I_adapt_trace = zeros(n_currents, n_steps);
is_fire = false(1,n_currents);

%% loop to process each step
for i = 2:n_steps

    % save
    I_adapt_trace(:, i) = I_adapt';
    V_trace(:, i) = V';

    % update I_adapt
    I_adapt = (1 - time_step_ratio_adapt) * I_adapt - J_adapt * is_fire; % core

    % update V_adapt
    V = (1 - time_step_ratio) * V + time_step_ratio * (range_of_I_e + I_adapt);

    % Check for neurons that have crossed the threshold
    is_fire = (V >= V_threshold);
    neurons_fire = find(is_fire);

    if ~isempty(neurons_fire)

        % reset to 0
        V(neurons_fire) = 0;

        % Record spike times and count spikes
        for neuron_idx = neurons_fire
            spike_times{neuron_idx} = [spike_times{neuron_idx}; time_step * i];
            n_spikes(neuron_idx) = n_spikes(neuron_idx) + 1;
        end
    end
end

% Calculate rates and instantaneous firing rates
min_intervals = 1;
the_first_instantaneous_firing_rate = zeros(n_currents, min_intervals);

for k = 1:n_currents
    if ~isempty(spike_times{k})
        spikes = spike_times{k}';
        average_firing_rate(k) = length(spikes) / total_time;
        intervals = diff(spikes);
        n_intervals = length(intervals);

        if n_intervals >= min_intervals
            the_first_instantaneous_firing_rate(k, 1:min_intervals) = 1 ./ intervals(1:min_intervals);
        end
    end
end

%% disp
simulation_time = toc;
fprintf('Simulation time: %.2f seconds\n', simulation_time);

%% calculate the period of steady state
ratio_threshold = 0.99;

% Detect peaks for all traces at once
[peak_values, peak_indices] = cellfun(@findpeaks, num2cell(V_trace, 2), 'UniformOutput', false);

% Calculate periods for each trace
periods_cell = cellfun(@diff, peak_indices, 'UniformOutput', false);

% Calculate ratios for each trace
ratio_cell = cellfun(@(x) x(1:end-1) ./ x(2:end), periods_cell, 'UniformOutput', false);

% Determine the start index of the steady state for each trace
steady_state_start_indices = cellfun(@(x) find(x > ratio_threshold, 1), ratio_cell, 'UniformOutput', false);

% Extract steady-state period for each trace
steady_state_periods = cellfun(@(p, idx) p(idx + 1) * time_step, periods_cell, steady_state_start_indices);

%% numerical solution of the algebraic equation
f_theory = numerical_solution_of_algebraic_equation(tau,tau_adapt,J_adapt,range_of_I_e);

%% plot

% f~I_e
figure
plot(range_of_I_e, average_firing_rate, 'b', range_of_I_e, the_first_instantaneous_firing_rate(:, 1), 'r')
xlabel('Injected Current (normalized)');
ylabel('Firing Rate (Hz)');
title('F-I curves for adapting neuron');
xlim([0.9 2]);
hold on;
plot(range_of_I_e, f_theory, 'k');
legend('Average Rate', 'the first instantaneous firing rate', 'f theory');

% f~I_e
figure
plot(range_of_I_e, average_firing_rate, 'b')
xlabel('Injected Current (normalized)');
ylabel('Firing Rate (Hz)');
title('F-I curves for adapting neuron');
xlim([0.9 2]);
hold on;
plot(range_of_I_e, f_theory, 'k');
legend('Average Rate', 'f theory');

% T~I_e
figure
plot(range_of_I_e, 1./average_firing_rate, 'b', range_of_I_e, 1./the_first_instantaneous_firing_rate(:, 1), 'r');
hold on;
plot(range_of_I_e, steady_state_periods, 'k');
xlabel('Injected Current (normalized)');
ylabel('T (s)');
legend('Average T', 'first T', 'steady T');
title('T~I curves for adapting neuron');
xlim([0.9 2]);

% V~t
time_vector = time_step:time_step:total_time;
figure
subplot(2, 1, 1);
neuron_id = 1;
plot(time_vector, V_trace(1, :));
xlabel('Time (s)');
ylabel('Voltage (normalized)');
title_str = sprintf('Voltage trace of neuron %d\n', neuron_id);
title(title_str);

subplot(2, 1, 2);
neuron_id = n_currents;
plot(time_vector, V_trace(end, :));
xlabel('Time (s)');
ylabel('Voltage (normalized)');
title_str = sprintf('Voltage trace of neuron %d\n', neuron_id);
title(title_str);

% for neuron_id = 1:20:n_currents
%     figure;
%     plot(time_vector, V_trace(neuron_id, :));
%     xlabel('Time (s)');
%     ylabel('V (normalized)');
%     title_str = sprintf('V trace of neuron %d\n', neuron_id);
%     title(title_str);
% end

% I_adapt~t
figure
subplot(2, 1, 1);
neuron_id = 1;
plot(time_vector, I_adapt_trace(neuron_id, :));
xlabel('Time (s)');
ylabel('I adapt (normalized)');
title_str = sprintf('I adapt trace of neuron %d\n', neuron_id);
title(title_str);

subplot(2, 1, 2);
neuron_id = n_currents;
plot(time_vector, I_adapt_trace(neuron_id, :));
xlabel('Time (s)');
ylabel('I adapt (normalized)');
title_str = sprintf('I adapt trace of neuron %d\n', neuron_id);
title(title_str);

for neuron_id = 1:50:n_currents
    figure;
    plot(time_vector, I_adapt_trace(neuron_id, :));
    xlabel('Time (s)');
    ylabel('I adapt (normalized)');
    title_str = sprintf('I adapt trace of neuron %d\n', neuron_id);
    title(title_str);
end

%% save
% save_folder_name = sprintf('J_adapt = %.2f',J_adapt);
% save_folder_path = fullfile('../result/',save_folder_name);
% save_all_figures(save_folder_path);
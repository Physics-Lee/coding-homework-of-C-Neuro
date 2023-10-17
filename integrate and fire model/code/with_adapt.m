clc;
clear;
close all;
tic

% Constants
V_threshold = 1; % s
time_constant = 1e-2; % s
time_constant_adapt = 0.2; % s
J_adapt = 0.1;
baseline_current = V_threshold;

% Time step configuration
time_step = 1e-4; % s
time_step_ratio = time_step / time_constant;
time_step_ratio_adapt = time_step / time_constant_adapt;
total_time = 10; % s
n_steps = ceil(total_time / time_step);

% Current and Neuron setup
current_values = baseline_current + [0.001:0.001:0.01, 0.01:0.01:1];
n_currents = length(current_values);

% Initialize
spike_times = cell(1, n_currents);
average_firing_rate = zeros(1, n_currents);
V = zeros(1, n_currents);
I_adapt = zeros(1, n_currents);
n_spikes = zeros(1, n_currents);
V_trace = zeros(n_currents, n_steps);
I_adapt_trace = zeros(n_currents, n_steps);
is_fire = false(1,n_currents);

% Main simulation loop
for i = 2:n_steps

    % save
    I_adapt_trace(:, i) = I_adapt';
    V_trace(:, i) = V';

    % update I_adapt
    I_adapt = (1 - time_step_ratio_adapt) * I_adapt - J_adapt * is_fire;

    % update V_adapt
    V = (1 - time_step_ratio) * V + time_step_ratio * (current_values + I_adapt);

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

%% Plot

% f~I_const
figure
plot(current_values, average_firing_rate, 'b', current_values, the_first_instantaneous_firing_rate(:, 1), 'r')
xlabel('Injected Current (normalized)');
ylabel('Firing Rate (Hz)');
legend('Average Rate', 'the first instantaneous firing rate');
title('F-I curves for non-adapting neuron');
xlim([0.9 2]);

% T~I_const
figure
plot(current_values, 1./average_firing_rate, 'b', current_values, 1./the_first_instantaneous_firing_rate(:, 1), 'r')
xlabel('Injected Current (normalized)');
ylabel('T (s)');
legend('Average T', 'first T');
title('T~I curves for non-adapting neuron');
xlim([0.9 2]);


% V~t
time_vector = time_step:time_step:total_time;
figure
subplot(2, 1, 1);
plot(time_vector, V_trace(1, :));
xlabel('Time (s)');
ylabel('Voltage (normalized)');
title('Voltage trace of the first neuron');

subplot(2, 1, 2);
plot(time_vector, V_trace(end, :));
xlabel('Time (s)');
ylabel('Voltage (normalized)');
title('Voltage trace of the last neuron');

%
for neuron_id = 1:20:n_currents
    figure;
    plot(time_vector, V_trace(neuron_id, :));
    xlabel('Time (s)');
    ylabel('V (normalized)');
    title_str = sprintf('V trace of neuron %d\n', neuron_id);
    title(title_str);
end

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

%
for neuron_id = 1:20:n_currents
    figure;
    plot(time_vector, I_adapt_trace(neuron_id, :));
    xlabel('Time (s)');
    ylabel('I adapt (normalized)');
    title_str = sprintf('I adapt trace of neuron %d\n', neuron_id);
    title(title_str);
end

%% disp
simulation_time = toc;
fprintf('Simulation time: %.2f seconds\n', simulation_time);
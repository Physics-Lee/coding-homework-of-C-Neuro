clc;clear;close all;

%% load data
load('../data/H1.mat');

%% basic statistics
mean(stim)
std(stim)

mean(rho)
std(rho)

%% basic info

frame_rate = 500; % Hz
t_total = 20*60; % s
frame_total = t_total * frame_rate; % no dimension
mean_firing_rate = sum(rho) / t_total; % Hz

%% histogram of the inter-spike-interval

% Find the indices of spikes
spike_indices = find(rho == 1);

% inter-spike intervals
isi = diff(spike_indices) / frame_rate;

% Tukey test (no need)
% IQR_index_max = 20;
% table = Tukey_test_plot_number_of_outliers_vs_IQR_index(isi_seconds, IQR_index_max);
% 
% IQR_index = 5;
% [number_of_up_outliers, number_of_down_outliers, mask_up, mask_down,...
%     up_limit, down_limit, upper_bound, lower_bound] =...
%     Tukey_test(isi_seconds, IQR_index);

% screen
test_Poisson_process(isi);
test_Poisson_process(isi(isi > 0.02));

%% spike-trigger-average (all)

fire_indices = find(rho == 1);
n_fire = length(fire_indices);
time_window = 0.3; % s
frame_window = time_window * frame_rate;

% Calculate
s_before_spikes = get_the_stimulus_before_spikes(stim,fire_indices,frame_window);

% Plot
figure;
t = (-frame_window:-1) / frame_rate; % s
plot(t,s_before_spikes);
xlabel('t (s)');
ylabel('s (some unit of intensity)');
title('Stimulus Before Spikes');
subtitle(sprintf("number of fires: %d; percentage: %.2f",length(fire_indices),1));
ylim([0,60]);

%% spike-trigger-average (spikes within 5ms)

interval_threshold = 0.005; % s
time_window = 0.3; % s
frame_window = time_window * frame_rate;

% Find indices of spikes
spike_indices = find(rho == 1);

% Find pairs of spikes with interval smaller than 5 ms
spike_intervals = diff(spike_indices) / frame_rate; % Convert intervals to seconds
close_pairs = find(spike_intervals < interval_threshold) + 1; % Indices of second spikes in close pairs
fire_indices_short_interval = fire_indices(close_pairs);

% Calculate
s_before_spikes = get_the_stimulus_before_spikes(stim,fire_indices_short_interval,frame_window);

% Plot
figure;
t = (-frame_window:-1) / frame_rate; % s
plot(t,s_before_spikes);
xlabel('t (s)');
ylabel('s (some unit of intensity)');
title('Stimulus Before Spikes, with <5ms Intervals');
subtitle(sprintf("number of fires: %d; percentage: %.2f",length(fire_indices_short_interval),length(fire_indices_short_interval)/n_fire));
ylim([0,60]);

%% spikes with longer intervals than 10ms before and after

% Define the minimum interval in frames
min_interval = 0.01 * frame_rate; % 10ms converted to frames

% Find indices of spikes
spike_indices = find(rho == 1);

% Initialize an array to store the indices of spikes with long enough intervals
fire_indices_long_interval = [];

% Check each spike to see if it has a long enough interval before and after
for i = 2:(n_fire-1) % Start at 2 and end at n_fire - 1 to avoid edge cases
    pre_interval = spike_indices(i) - spike_indices(i-1);
    post_interval = spike_indices(i+1) - spike_indices(i);
    if pre_interval > min_interval && post_interval > min_interval
        fire_indices_long_interval(end+1,1) = spike_indices(i);
    end
end

% Now long_interval_spikes contains indices of spikes with >10ms intervals before and after
% You can now calculate and plot the stimulus before these spikes as you did before

% Calculate
s_before_long_interval_spikes = get_the_stimulus_before_spikes(stim, fire_indices_long_interval, frame_window);

% Plot
figure;
t = (-frame_window:-1) / frame_rate; % s
plot(t, s_before_long_interval_spikes);
xlabel('t (s)');
ylabel('s (some unit of intensity)');
title('Stimulus Before Spikes, with >10ms Pre- and Post-Intervals');
subtitle(sprintf("number of fires: %d; percentage: %.2f",length(fire_indices_long_interval),length(fire_indices_long_interval)/n_fire));
ylim([0, 60]);

%% kernal (no dimension)
variance_of_white_noise = (std(stim))^2;
firing_rate = n_fire / t_total; % Hz
D = s_before_spikes * firing_rate / variance_of_white_noise;

% Plot
figure;
t = (- frame_window:-1) / frame_rate; % s
plot(t,D);
title('kernal of the white noise');
xlabel('t (s)');
ylabel('kernal');

%% ideal Poisson process
t_events = generate_poisson_process(mean_firing_rate, t_total);

% Visualization
figure; % Create a new figure
stem(t_events, ones(size(t_events)), 'filled'); % Plot the event times
xlabel('Time'); % Label for the x-axis
ylabel('Events'); % Label for the y-axis (though all events are at 1)
title('Poisson Process Visualization'); % Title of the plot
axis([0 t_total/1000 0 2]); % Set the axis limits
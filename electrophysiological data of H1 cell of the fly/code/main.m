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

%% spike-trigger-average

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
title('stimulus before spikes');
xlabel('t (s)');
ylabel('s (some unit of intensity)');
ylim([0,60]);

%% spike-trigger-average v2

interval_threshold = 0.005; % s
time_window = 0.3; % s
frame_window = time_window * frame_rate;

% Find indices of spikes
spike_indices = find(rho == 1);

% Find pairs of spikes with interval smaller than 5 ms
spike_intervals = diff(spike_indices) / frame_rate; % Convert intervals to seconds
close_pairs = find(spike_intervals < interval_threshold) + 1; % Indices of second spikes in close pairs
fire_indices_v2 = fire_indices(close_pairs);

% Calculate
s_before_spikes = get_the_stimulus_before_spikes(stim,fire_indices_v2,frame_window);

% Plot
figure;
t = (-frame_window:-1) / frame_rate; % s
plot(t,s_before_spikes);
title('stimulus before spikes v2');
xlabel('t (s)');
ylabel('s (some unit of intensity)');
ylim([0,60]);

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
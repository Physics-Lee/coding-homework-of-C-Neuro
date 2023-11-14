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
time_window_all = 1; % s
[r_real,r_box,r_Gauss,r_exp] = count_spikes(rho,time_window_all);

%% histogram of the inter-spike-interval

fire_indices = find(rho == 1);
n_fire = length(fire_indices);
frame_events_real = fire_indices;
t_events_real = fire_indices / frame_rate; % s
isi_real = diff(fire_indices) / frame_rate; % s

% Tukey test (no need)
% IQR_index_max = 20;
% table = Tukey_test_plot_number_of_outliers_vs_IQR_index(isi_seconds, IQR_index_max);
%
% IQR_index = 5;
% [number_of_up_outliers, number_of_down_outliers, mask_up, mask_down,...
%     up_limit, down_limit, upper_bound, lower_bound] =...
%     Tukey_test(isi_seconds, IQR_index);

% test
test_Poisson_process(isi_real);
test_Poisson_process(isi_real(isi_real > 0.02));

%% spike-trigger-average (all)
time_window = 0.3; % s
frame_window = time_window * frame_rate;

% Calculate
s_before_spikes = get_the_stimulus_before_spikes(stim,fire_indices,frame_window);

% Plot
figure;
t_D = (-frame_window:-1) / frame_rate; % s
plot(t_D,s_before_spikes);
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
fire_indices = find(rho == 1);

% Find pairs of spikes with interval smaller than 5 ms
spike_intervals = diff(fire_indices) / frame_rate; % Convert intervals to seconds
close_pairs = find(spike_intervals < interval_threshold) + 1; % Indices of second spikes in close pairs
fire_indices_short_interval = fire_indices(close_pairs);

% Calculate
s_before_spikes = get_the_stimulus_before_spikes(stim,fire_indices_short_interval,frame_window);

% Plot
figure;
t_D = (-frame_window:-1) / frame_rate; % s
plot(t_D,s_before_spikes);
xlabel('t (s)');
ylabel('s (some unit of intensity)');
title('Stimulus Before Spikes, with <5ms Intervals');
subtitle(sprintf("number of fires: %d; percentage: %.2f",length(fire_indices_short_interval),length(fire_indices_short_interval)/n_fire));
ylim([0,60]);

%% spikes with longer intervals than 10ms before and after

% Define the minimum interval in frames
min_interval = 0.01 * frame_rate; % 10ms converted to frames

% Find indices of spikes
fire_indices = find(rho == 1);

% Initialize an array to store the indices of spikes with long enough intervals
fire_indices_long_interval = [];

% Check each spike to see if it has a long enough interval before and after
for i = 2:(n_fire-1) % Start at 2 and end at n_fire - 1 to avoid edge cases
    pre_interval = fire_indices(i) - fire_indices(i-1);
    post_interval = fire_indices(i+1) - fire_indices(i);
    if pre_interval > min_interval && post_interval > min_interval
        fire_indices_long_interval(end+1,1) = fire_indices(i);
    end
end

% Now long_interval_spikes contains indices of spikes with >10ms intervals before and after
% You can now calculate and plot the stimulus before these spikes as you did before

% Calculate
s_before_long_interval_spikes = get_the_stimulus_before_spikes(stim, fire_indices_long_interval, frame_window);

% Plot
figure;
t_D = (-frame_window:-1) / frame_rate; % s
plot(t_D, s_before_long_interval_spikes);
xlabel('t (s)');
ylabel('s (some unit of intensity)');
title('Stimulus Before Spikes, with >10ms Pre- and Post-Intervals');
subtitle(sprintf("number of fires: %d; percentage: %.2f",length(fire_indices_long_interval),length(fire_indices_long_interval)/n_fire));
ylim([0, 60]);

%% kernal

variance_of_white_noise = (std(stim))^2;
firing_rate = n_fire / t_total; % Hz
D = s_before_spikes * mean_firing_rate / variance_of_white_noise;

% Plot
figure;
t_D = (- frame_window:-1) / frame_rate; % s
plot(t_D,D);
title('kernal of the white noise');
xlabel('t (s)');
ylabel('kernal');

%% ideal Poisson process
t_events_ideal = generate_poisson_process(mean_firing_rate, t_total);

% Visualization
figure; % Create a new figure
stem(t_events_ideal, ones(size(t_events_ideal)), 'Marker','none'); % Plot the event times
xlabel('Time'); % Label for the x-axis
ylabel('Events'); % Label for the y-axis (though all events are at 1)
title('Poisson Process Visualization'); % Title of the plot
axis([0 t_total/1000 0 2]); % Set the axis limits

% test
test_Poisson_process(diff(t_events_ideal));

% from t_events to rho
frame_events_ideal = round(t_events_ideal * frame_rate);
frame_events_ideal_test = unique(frame_events_ideal); % here we have an issue that is impossible to be fixed
rho_ideal = zeros(frame_total,1);
rho_ideal(frame_events_ideal) = 1;

%% linear model
r_linear = conv(stim, D, 'same');
r_0 = mean_firing_rate - mean(r_linear);
r = r_0 + r_linear;

% Reshape r into a 500x1200 matrix
r_reshaped = reshape(r, 500, []);

% Calculate mean of each column
r_predict = mean(r_reshaped, 1);

% Reshape back to 1200x1 vector
r_predict = r_predict';

% check
if abs(mean(r_predict)-mean_firing_rate) < 10^(-4)
    disp("check succeeds!");
end

% Plot
figure;
hold on;
t_all = 0:time_window_all:t_total-time_window_all;
plot(t_all, r_real, 'black');
plot(t_all, r_predict, 'magenta');
xlabel('t (s)');
ylabel('r (Hz)');
title('linear model');
error_RMSE = RMSE(r_real,r_predict);
subtitle(sprintf("RMSE: %.4f",error_RMSE));
legend('real','predict');
xlim([1000,1200]);

%% ReLU
r_linear = conv(stim, D, 'same');
r_nonlinear = ReLU(r_linear);
r_0 = mean_firing_rate - mean(r_nonlinear);
r = r_0 + r_nonlinear;

% Reshape r into a 500x1200 matrix
r_reshaped = reshape(r, 500, []);

% Calculate mean of each column
r_predict = mean(r_reshaped, 1);

% Reshape back to 1200x1 vector
r_predict = r_predict';

% check
if abs(mean(r_predict)-mean_firing_rate) < 10^(-4)
    disp("check succeeds!");
end

% Plot
figure;
hold on;
t_all = 0:time_window_all:t_total-time_window_all;
plot(t_all, r_real, 'black');
plot(t_all, r_predict, 'magenta');
xlabel('t (s)');
ylabel('r (Hz)');
title('Activation Function: ReLU');
error_RMSE = RMSE(r_real,r_predict);
subtitle(sprintf("RMSE: %.4f",error_RMSE));
legend('real','predict');
xlim([1000,1200]);

%% ReLU with up bound
r_linear = conv(stim, D, 'same');
up_bound = 150; % super-parameter
r_nonlinear = ReLU_with_up_bound(r_linear,up_bound);
r_0 = mean_firing_rate - mean(r_nonlinear);
r = r_0 + r_nonlinear;

% Reshape r into a 500x1200 matrix
r_reshaped = reshape(r, 500, []);

% Calculate mean of each column
r_predict = mean(r_reshaped, 1);

% Reshape back to 1200x1 vector
r_predict = r_predict';

% check
if abs(mean(r_predict)-mean_firing_rate) < 10^(-4)
    disp("check succeeds!");
end

% RMSE
error_RMSE = RMSE(r_real,r_predict);

% Plot
figure;
hold on;
t_all = 0:time_window_all:t_total-time_window_all;
plot(t_all, r_real, 'black');
plot(t_all, r_predict, 'magenta');
xlabel('t (s)');
ylabel('r (Hz)');
title('Activation Function: ReLU with up bound');
subtitle(sprintf("RMSE: %.4f",error_RMSE));
legend('real','predict');
xlim([1000,1200]);

%% Sigmoid
r_linear = conv(stim, D, 'same');
r_linear = normalization_to_0_1(r_linear); % must normalize when using ML!
amplitude = 2000; % super-parameter
r_nonlinear = amplitude * sigmoid(r_linear);
r_0 = mean_firing_rate - mean(r_nonlinear);
r = r_0 + r_nonlinear;

% Reshape r into a 500x1200 matrix
r_reshaped = reshape(r, 500, []);

% Calculate mean of each column
r_predict = mean(r_reshaped, 1);

% Reshape back to 1200x1 vector
r_predict = r_predict';

% check
if abs(mean(r_predict)-mean_firing_rate) < 10^(-4)
    disp("check succeeds!");
end

% RMSE
error_RMSE = RMSE(r_real,r_predict);

% Plot
figure;
hold on;
t_all = 0:time_window_all:t_total-time_window_all;
plot(t_all, r_real, 'black');
plot(t_all, r_predict, 'magenta');
xlabel('t (s)');
ylabel('r (Hz)');
title('Activation Function: Sigmoid');
subtitle(sprintf("RMSE: %.4f",error_RMSE));
legend('real','predict');
xlim([1000,1200]);

%% isi_real vs isi_ideal

% histogram
figure
isi_real_ms = isi_real * 1000; % ms
edges = [0 0:1:20 20];
histogram(isi_real_ms,edges);
xlabel('t (ms)');
ylabel('count');
title('inter-spike-interval real');

figure
isi_ideal = diff(t_events_ideal);
isi_ideal_ms = isi_ideal * 1000; % ms
edges = [0 0:1:20 20];
histogram(isi_ideal_ms,edges);
xlabel('t (ms)');
ylabel('count');
title('inter-spike-interval ideal');

% sig/mean
disp("isi real")
disp_cv(isi_real);
disp("isi ideal")
disp_cv(isi_ideal);

%% auto-corr by autocorr
max_lag = 50; % 100 ms
lag_frames = -max_lag:max_lag;
lag_time = lag_frames / frame_rate * 1000; % ms
lag_time_half = lag_time(lag_time >= 0);

[acf_real, lags_real, bounds_real] = autocorr(rho, max_lag);
[acf_ideal, lags_ideal, bounds_ideal] = autocorr(rho_ideal, max_lag);
figure;
hold on;
plot(lag_time_half,acf_real,'r-o')
plot(lag_time_half,acf_ideal,'b-o')
xlabel("t(ms)");
ylabel('Auto-correlation');
title('Auto-correlation of the spike train');
legend("real","ideal");
set_full_screen;

%% auto-corr by xcorr
auto_corr_real = xcorr(centralization(rho), max_lag, 'coeff'); % Calculate autocorrelation
auto_corr_ideal = xcorr(centralization(rho_ideal), max_lag, 'coeff'); % Calculate autocorrelation

figure;
hold on;
plot(lag_time, auto_corr_real,'r-o');
plot(lag_time, auto_corr_ideal,'b-o');
xlabel('t (ms)');
ylabel('Auto-correlation');
title('Auto-correlation of the spike train');
legend('real','ideal');
set_full_screen;
xlim([0,100]);

%% auto-corr by xcov
auto_corr_real = xcov(rho, max_lag, 'coeff'); % Calculate autocorrelation
auto_corr_ideal = xcov(rho_ideal, max_lag, 'coeff'); % Calculate autocorrelation

figure;
hold on;
plot(lag_time, auto_corr_real,'r-o');
plot(lag_time, auto_corr_ideal,'b-o');
xlabel('t (ms)');
ylabel('Auto-correlation');
title('Auto-correlation of the spike train');
legend('real','ideal');
set_full_screen;
xlim([0,100]);

%% auto-corr by hand
auto_corr_real_by_hand = auto_corr_manual(rho, max_lag);
auto_corr_ideal_by_hand = auto_corr_manual(rho_ideal, max_lag);
figure;
hold on;
plot(lag_time_half, auto_corr_real_by_hand,'r-o');
plot(lag_time_half, auto_corr_ideal_by_hand,'b-o');
xlabel('t (ms)');
ylabel('Auto-correlation');
title('Auto-correlation of the spike train');
legend('real','ideal');
set_full_screen;

%% save
% save_folder_path = "../result";
% save_all_figs(save_folder_path);
close all;
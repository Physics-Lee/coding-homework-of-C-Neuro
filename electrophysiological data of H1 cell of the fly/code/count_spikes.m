clc;clear;close all;

%% load data
load('../data/H1.mat');

%% basic info

frame_rate = 500; % Hz
t_total = 1200; % s
frame_total = t_total * frame_rate; % no dimension
mean_firing_rate = sum(rho) / t_total; % Hz

%% Bar Plot of Fires

time_window = 1; % s
frame_window = time_window * frame_rate; % no dimension
spike_counts = zeros(1, ceil(frame_total/frame_window));

% loop to process each bin
for i = 1:frame_window:frame_total
    end_idx = min(i + frame_window - 1, frame_total);
    spike_counts(ceil(i/frame_window)) = sum(rho(i:end_idx));
end

%
firing_rate = spike_counts / time_window;

%% Gauss

% Define a Gaussian Kernel
sigma = 5; % s
sz = 10; % s
x = linspace(-sz / 2, sz / 2, sz);
gauss_kernel = exp(-x .^ 2 / (2 * sigma ^ 2));
gauss_kernel = gauss_kernel / sum(gauss_kernel); % Normalize the kernel

% Convolve
r_Gauss = conv(firing_rate, gauss_kernel, 'same');

%% Exp

% Define an Exponential Kernel
tau = 5; % s
exp_kernel = exp(- x / tau);
exp_kernel = exp_kernel / sum(exp_kernel); % Normalize the kernel

% Convolve
r_exp = conv(firing_rate, exp_kernel, 'same');

%% Boxcar

% Define a Boxcar Kernel (rectangular window)
box_width = 2; % s
box_kernel = ones(1, box_width) / box_width;

% Convolve spike counts with the Boxcar kernel
r_box = conv(firing_rate, box_kernel, 'same');

%% plot kernel
figure;
hold on;
plot(box_kernel);
plot(gauss_kernel);
plot(exp_kernel);
legend('box kernel','Gauss kernel','exp kernel');

% Plot
figure;
hold on;
t = 0:time_window:t_total-time_window;
plot(t, firing_rate, 'black');
plot(t, r_box, 'green');
plot(t, r_Gauss, 'red');
plot(t, r_exp, 'blue');
xlabel('t (s)');
ylabel('r (Hz)');
legend('origin','box kernel','Gauss kernel','exp kernel');
xlim([0,200]);
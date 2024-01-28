% generate, corrupt and recall.
%
% Yixuan Li, 2024-01-28
%

clc;clear;close all;

% paras
N_neuron = 500;
N_pattern_range = 10:10:150;
N_exp = 100;
fraction_of_corrupted_bits = 0;

% init
f_error_pattern_mean = zeros(size(N_pattern_range));
f_error_pattern_SEM = zeros(size(N_pattern_range));
f_error_neuron_mean = zeros(size(N_pattern_range));
f_error_neuron_SEM = zeros(size(N_pattern_range));

% loop to process each N_pattern
for idx = 1:length(N_pattern_range)

    % N pattern now
    N_pattern = N_pattern_range(idx);

    % generate, corrupt and recall
    [f_error_pattern_mean(idx),f_error_pattern_SEM(idx),f_error_neuron_mean(idx),f_error_neuron_SEM(idx)] = generate_corrupt_recall(N_neuron, N_pattern, N_exp, fraction_of_corrupted_bits);
end

% plot
figure;
errorbar(N_pattern_range/N_neuron, f_error_pattern_mean, f_error_pattern_SEM);
xlabel('N_{pattern}/N_{neuron}');
ylabel('P(error pattern)');
title(sprintf('N_{neuron} = %d; Fraction of Corrupted Bits = %.1f; N_{exp} = %d', N_neuron, fraction_of_corrupted_bits, N_exp));
subtitle("Error Bar for SEM");

figure;
errorbar(N_pattern_range/N_neuron, f_error_neuron_mean, f_error_neuron_SEM);
xlabel('N_{pattern}/N_{neuron}');
ylabel('P(error neuron)');
title(sprintf('N_{neuron} = %d; Fraction of Corrupted Bits = %.1f; N_{exp} = %d', N_neuron, fraction_of_corrupted_bits, N_exp));
subtitle("Error Bar for SEM");
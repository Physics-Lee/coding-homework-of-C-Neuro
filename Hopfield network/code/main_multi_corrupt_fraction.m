clc; clear; close all;

% Parameters
N_neuron = 500;
N_pattern_range = 10:10:150;
N_exp = 10;
fraction_of_corrupted_bits_values = 0.0:0.1:0.4;

% Initialize
f_error_pattern_mean = zeros(length(N_pattern_range), length(fraction_of_corrupted_bits_values));
f_error_pattern_SEM = zeros(size(f_error_pattern_mean));
f_error_neuron_mean = zeros(size(f_error_pattern_mean));
f_error_neuron_SEM = zeros(size(f_error_pattern_mean));

% calculate
for f_idx = 1:length(fraction_of_corrupted_bits_values)
    fraction_of_corrupted_bits = fraction_of_corrupted_bits_values(f_idx);
    
    % Loop to process each N_pattern
    for idx = 1:length(N_pattern_range)
        N_pattern = N_pattern_range(idx);
        [f_error_pattern_mean(idx, f_idx), f_error_pattern_SEM(idx, f_idx), ...
         f_error_neuron_mean(idx, f_idx), f_error_neuron_SEM(idx, f_idx)] = ...
         generate_corrupt_recall(N_neuron, N_pattern, N_exp, fraction_of_corrupted_bits);
    end
    
end

% First figure: Error pattern
figure;
hold on;
for f_idx = 1:length(fraction_of_corrupted_bits_values)   
    errorbar(N_pattern_range/N_neuron, f_error_pattern_mean(:, f_idx), f_error_pattern_SEM(:, f_idx));
end
hold off;

% Add legend, labels, and title
legend(arrayfun(@(x) sprintf('Fraction of Corrupted Bits = %.1f', x), fraction_of_corrupted_bits_values, 'UniformOutput', false));
xlabel('N_{pattern}/N_{neuron}');
ylabel('P(error pattern)');
title(sprintf('N_{neuron} = %d; N_{exp} = %d', N_neuron, N_exp));
subtitle("Error Bar for SEM");

% Second figure: Error neuron
figure;
hold on;
for f_idx = 1:length(fraction_of_corrupted_bits_values)
    errorbar(N_pattern_range/N_neuron, f_error_neuron_mean(:, f_idx), f_error_neuron_SEM(:, f_idx));
end
hold off;

% Add legend, labels, and title
legend(arrayfun(@(x) sprintf('Fraction of Corrupted Bits = %.1f', x), fraction_of_corrupted_bits_values, 'UniformOutput', false));
xlabel('N_{pattern}/N_{neuron}');
ylabel('P(error neuron)');
title(sprintf('N_{neuron} = %d; N_{exp} = %d', N_neuron, N_exp));
subtitle("Error Bar for SEM");
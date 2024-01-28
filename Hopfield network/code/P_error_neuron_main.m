clc;clear;close all;

% set up
N_neuron = 500; % number of neurons
fraction_of_corrupted_bit = 0; % a const
P_range = 10:10:100;
f_error_neuron_mean = zeros(size(P_range));
f_error_neuron_SEM = zeros(size(P_range));

% loop to process each P
for idx = 1:length(P_range)

    % init all memory patterns
    N_memory_pattern = P_range(idx); % number of patterns
    S = randi([0, 1], [N_neuron*N_memory_pattern, 1])*2 - 1; % neurons
    memory_patterns = cell(N_memory_pattern, 1); % patterns
    for i = 1:N_memory_pattern
        memory_patterns{i} = S((i-1)*N_neuron+1:i*N_neuron);
    end

    % calculate the weight matrix
    W = calculate_W(N_neuron,N_memory_pattern,memory_patterns);

    % corrupt and recall
    N_exp = 1000;
    [f_error_neuron_mean(idx),f_error_neuron_SEM(idx)] = corrupt_and_recall(W, N_neuron, N_exp, memory_patterns, fraction_of_corrupted_bit);
end

% plot
errorbar(P_range/N_neuron, f_error_neuron_mean, f_error_neuron_SEM);
xlabel('P/N');
ylabel('P(error neuron)');
title(sprintf('N = %d; fraction of corrupted bit = %.1f; N exp = %d', N_neuron, fraction_of_corrupted_bit, N_exp));
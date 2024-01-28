% For all patterns, corrupt and recall.
%
% Yixuan Li, 2024-01-28
%

clc;clear;close all;

% set up
N_neuron = 500; % number of neurons
fraction_of_corrupted_bit = 0; % a const
P_range = 1:1:100;
ratio = zeros(size(P_range));

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
    N_exp = 1; % do many exps and calculate the average
    ratio(idx) = recall_all_pattern(W, N_neuron, N_exp, memory_patterns, fraction_of_corrupted_bit);
end

% plot
figure;
plot(P_range/N_neuron, 1 - ratio);
xlabel('P/N');
ylabel('P(error pattern)');
title(sprintf('N = %d; fraction of corrupted bit = %f; N_exp = %d', N_neuron, fraction_of_corrupted_bit, N_exp));
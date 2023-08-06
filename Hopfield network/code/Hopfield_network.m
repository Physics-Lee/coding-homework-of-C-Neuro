clc;clear;close all;

% set up
rng(123);
n_neuron = 500; % number of neurons
fraction_of_corrupted_bit = 0.1:0.1:1;
P_range = 10:10:100; % different values of P to loop through

legend_labels = cell(0, 1);
figure;
xlabel('fraction of corrupted bit');
ylabel('fraction of perfect recall');
hold on;
for p = 1:length(P_range)
    n_pattern = P_range(p);
    memory_patterns = cell(n_pattern, 1); % memory patterns that need to be stored.
    for i = 1:n_pattern
        memory_patterns{i} = randi([0, 1], [n_neuron, 1])*2 - 1;
    end

    % calculate the weight matrix
    W = zeros(n_neuron,n_neuron);
    for i = 1:n_neuron
        for j = i+1:n_neuron
            for k = 1:n_pattern
                W(i,j) = W(i,j) + 1/n_neuron*memory_patterns{k}(i)*memory_patterns{k}(j);
            end
        end
    end
    W = W + W';

    % corrupt and recall
    n_exp = 100;
    fraction_of_perfect_recall = zeros(size(fraction_of_corrupted_bit));
    for idx = 1:numel(fraction_of_corrupted_bit)
        [fraction_of_perfect_recall(idx),~] = corrupt_and_recall(W, n_neuron, n_exp, memory_patterns, fraction_of_corrupted_bit(idx));
    end
    plot(fraction_of_corrupted_bit, fraction_of_perfect_recall);
    legend_labels{end+1} = ['P = ', num2str(P_range(p))];
    legend(legend_labels);
    drawnow;
end
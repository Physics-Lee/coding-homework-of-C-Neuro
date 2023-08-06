function fraction_of_perfect_recall_vs_fraction_of_corrupted_bits
% init
n_neuron = 400;
range_of_fraction_of_corrupted_bits = 0.1:0.1:1;
range_of_n_memory_pattern = 50;
legend_labels = {};
n_exp_for_different_memory_pattern = 10;
n_exp_for_different_corrupt = 100;

% plot set up
figure;
xlabel('fraction of corrupted bits');
ylabel('fraction of perfect recalls');
title(['number of neurons = ' num2str(n_neuron)]);
ylim([-0.2 1.2]);
hold on;

% loop to explore different number of memory patterns
for n_memory_pattern = range_of_n_memory_pattern

    % init
    fraction_of_perfect_recall = zeros(n_exp_for_different_memory_pattern,length(range_of_fraction_of_corrupted_bits));

    % loop to explore the effect of different generated memory pattern
    for i = 1:n_exp_for_different_memory_pattern

        % generate memory patterns
        memory_patterns = generate_memory_patterns(n_neuron,n_memory_pattern);

        % calculate W
        W = calculate_W(n_neuron,n_memory_pattern,memory_patterns);

        % loop to explore different fraction of corrupted bits
        for j = 1:length(range_of_fraction_of_corrupted_bits)
            fraction_of_corrupted_bits = range_of_fraction_of_corrupted_bits(j);
            [fraction_of_perfect_recall(i,j),~] = corrupt_and_recall(W, n_neuron, n_exp_for_different_corrupt, memory_patterns, fraction_of_corrupted_bits);
        end
    end

    % plot
    errorbar(range_of_fraction_of_corrupted_bits, mean(fraction_of_perfect_recall,1), std(fraction_of_perfect_recall,1));

    % legend
    legend_labels{end+1} = ['number of memory patterns = ' num2str(n_memory_pattern)];
    legend(legend_labels);

    % update the figure now!
    drawnow;
end
end
function fraction_of_perfect_recall_vs_fraction_of_corrupted_bits
% init
n_neuron = 400;
range_of_fraction_of_corrupted_bits = 0.0:0.1:0.5;
range_of_n_memory_pattern = 30:10:70;
legend_labels = {};
n_exp_for_different_memory_pattern = 100; % 100
n_exp_for_different_corrupt = 137; % 137

% plot set up
figure(1);
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

    % back to figure 1
    figure(1);

    % plot
    mean_of_data = mean(fraction_of_perfect_recall,1);
    std_of_data = std(fraction_of_perfect_recall,1);
    SEM_of_data = std_of_data/sqrt(n_exp_for_different_memory_pattern);
    errorbar(range_of_fraction_of_corrupted_bits, mean_of_data, SEM_of_data);

    % legend
    legend_labels{end+1} = ['number of memory patterns = ' num2str(n_memory_pattern)];
    legend(legend_labels);

    % update the figure now!
    drawnow;

    % save
    folder_path_main = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\Hopfield network\result\SEM';
    file_name_main = sprintf('number of memory patterns = %d', n_memory_pattern);
    save_and_not_close(folder_path_main,file_name_main,'png');

    % histogram for each point in the above graph
    for j = 1:length(range_of_fraction_of_corrupted_bits)

        % plot
        figure;
        edges = 0:0.1:1;
        histogram(fraction_of_perfect_recall(:,j),edges,'Normalization','probability');

        % label
        xlabel('fraction of perfect recall');
        ylabel('probability');
        title(['fraction of corrupted bits = ' num2str(range_of_fraction_of_corrupted_bits(j))]);

        % lim
        xlim([0,1]);
        ylim([0,1]);

        % save
        folder_path_hist = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\Hopfield network\result\SEM';
        file_name_hist = sprintf('fraction of corrupted bits = %.1f', range_of_fraction_of_corrupted_bits(j));
        file_name_hist = strcat(file_name_main,';',file_name_hist,'.png');
        save_and_close_v2(folder_path_hist,file_name_hist);

    end
end
end

function save_and_not_close(folder_path,file_name,ext_str)
full_path = fullfile(folder_path,file_name);
saveas(gcf,full_path,ext_str);
end

function save_and_close_v2(folder_path,file_name)
full_path = fullfile(folder_path,file_name);
saveas(gcf,full_path);
close;
end
function [fraction_of_perfect_recall,fraction_of_errors_mean,fraction_of_errors_mean_std] = corrupt_and_recall(W, n_neuron, n_exp_for_different_corrupt, memory_patterns, fraction_of_corrupted_bits)

number_of_corrupted_bits = int32(fraction_of_corrupted_bits * n_neuron);
number_of_perfect_recall = 0;
fraction_of_errors_each_exp = zeros(1,n_exp_for_different_corrupt);
for j = 1:n_exp_for_different_corrupt
    
    %% corrupt

    % choose a random pattern
    idx_pattern_corrupted = randi([1,size(memory_patterns,1)]);
    S_corrupt = memory_patterns{idx_pattern_corrupted};

    % choose random neurons
    idx_neuron_randomized = randperm(n_neuron);
    idx_neuron_corrupted = idx_neuron_randomized(1:number_of_corrupted_bits);

    % corrupt by turn -1 to +1 and +1 to -1
    S_corrupt(idx_neuron_corrupted) = - S_corrupt(idx_neuron_corrupted);
    
    %% recall    
    N_steps = 100; % maximal steps.
    for i = 1:N_steps
        S_corrupt = sgn(W * S_corrupt);
        if all(S_corrupt == memory_patterns{idx_pattern_corrupted},'all')
            number_of_perfect_recall = number_of_perfect_recall + 1;
            fraction_of_errors_each_exp(j) = 0;
            break;
        end
    end
    
    % track the process of recall, not just the result of recall
    if i == N_steps
        fraction_of_errors_each_exp(j) = sum(S_corrupt ~= memory_patterns{idx_pattern_corrupted})/n_neuron;
    end
    
end

% the result of recall
fraction_of_perfect_recall = number_of_perfect_recall/n_exp_for_different_corrupt;

% the process of recall
fraction_of_errors_mean = mean(fraction_of_errors_each_exp);
fraction_of_errors_mean_std = std(fraction_of_errors_each_exp);

end
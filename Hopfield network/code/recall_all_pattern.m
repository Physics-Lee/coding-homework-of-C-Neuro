function f_error_pattern = recall_all_pattern(W, n_neuron, n_exp, memory_patterns, fraction_of_corrupted_bits)

number_of_corrupted_bits = int32(fraction_of_corrupted_bits * n_neuron);
N_memory_pattern = length(memory_patterns);
Is_recalled = zeros(N_memory_pattern,1);

% loop to corrupt each pattern
for k = 1:N_memory_pattern

    % init
    number_of_perfect_recall = 0;
    S_corrupt = memory_patterns{k};

    % loop to do many exps
    for j = 1:n_exp

        % choose random neurons
        idx_neuron_randomized = randperm(n_neuron);
        idx_neuron_corrupted = idx_neuron_randomized(1:number_of_corrupted_bits);

        % corrupt by turn -1 to +1 and +1 to -1
        S_corrupt(idx_neuron_corrupted) = - S_corrupt(idx_neuron_corrupted);

        % recall
        N_steps = 100; % use 100 as the max steps.
        for i = 1:N_steps
            S_corrupt = sgn(W * S_corrupt);
            if all(S_corrupt == memory_patterns{k},'all')
                number_of_perfect_recall = number_of_perfect_recall + 1;
                break;
            end
        end

    end

    % If P_recall > 0.8, set it as 1. If not, set it as 0
    fraction_of_perfect_recall = number_of_perfect_recall/n_exp;
    if fraction_of_perfect_recall >= 0.8
        Is_recalled(k) = 1;
    end
end

% frequency
f_error_pattern = sum(Is_recalled)/N_memory_pattern;

end
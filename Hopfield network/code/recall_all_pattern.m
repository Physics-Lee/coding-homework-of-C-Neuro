function f_error_pattern = recall_all_pattern(W, N_neuron, N_exp, memory_patterns, fraction_of_corrupted_bits)

N_corrupted_bits = int32(fraction_of_corrupted_bits * N_neuron);
N_pattern = length(memory_patterns);
Is_recalled = zeros(N_pattern,1);

% loop to corrupt each pattern
for k = 1:N_pattern

    % init
    N_perfect_recall = 0;
    pattern_now = memory_patterns{k};

    % loop to do many exps
    for j = 1:N_exp

        % choose random neurons
        idx_neuron_randomized = randperm(N_neuron);
        idx_neuron_corrupted = idx_neuron_randomized(1:N_corrupted_bits);

        % corrupt by turn -1 to +1 and +1 to -1
        pattern_now(idx_neuron_corrupted) = - pattern_now(idx_neuron_corrupted);

        % recall
        N_steps = 100; % use 100 as the max steps.
        for i = 1:N_steps
            pattern_now = sgn(W * pattern_now);
            if all(pattern_now == memory_patterns{k},'all')
                N_perfect_recall = N_perfect_recall + 1;
                break;
            end
        end
        
    end

    % If P_recall > 0.8, set it as 1. If not, set it as 0
    if N_perfect_recall/N_exp >= 0.8
        Is_recalled(k) = 1;
    end
end

% frequency
f_error_pattern = sum(Is_recalled)/N_pattern;

end
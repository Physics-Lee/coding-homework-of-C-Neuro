function [f_error_neuron_mean,f_error_neuron_SEM] = corrupt_and_recall(W, n_neuron, n_exp, memory_patterns, fraction_of_corrupted_bits)

number_of_corrupted_bits = int32(fraction_of_corrupted_bits * n_neuron);
N_memory_pattern = length(memory_patterns);
f_error_neuron = zeros(N_memory_pattern,n_exp);

% loop to corrupt each pattern
for k = 1:N_memory_pattern
    for j = 1:n_exp

        S_corrupt = memory_patterns{k};

        %% corrupt

        % choose random neurons
        idx_neuron_randomized = randperm(n_neuron);
        idx_neuron_corrupted = idx_neuron_randomized(1:number_of_corrupted_bits);

        % corrupt by turn -1 to +1 and +1 to -1
        S_corrupt(idx_neuron_corrupted) = - S_corrupt(idx_neuron_corrupted);

        %% recall
        N_steps = 100; % maximal steps.
        for i = 1:N_steps
            S_corrupt = sgn(W * S_corrupt);
            if all(S_corrupt == memory_patterns{k},'all')
                f_error_neuron(k,j) = 0;
                break;
            end
        end

        % after N steps, calculate the number of error neurons
        if i == N_steps
            f_error_neuron(k,j) = sum(S_corrupt ~= memory_patterns{k})/n_neuron;
        end

    end

end

% the process of recall
f_error_neuron_flatted = reshape(f_error_neuron, [], 1);
f_error_neuron_mean = mean(f_error_neuron_flatted);
f_error_neuron_SEM = std(f_error_neuron_flatted) / sqrt(n_exp);

end
function [fraction_of_perfect_recall,fraction_of_errors_mean,fraction_of_errors_mean_std] = corrupt_and_recall(W, n_neuron, n_exp, memory_patterns, fraction_of_corrupted_bits)

number_of_corrupted_bits = int32(fraction_of_corrupted_bits * n_neuron);
number_of_perfect_recall = 0;
fraction_of_errors_each_exp = zeros(1,n_exp);
for j = 1:n_exp
    
    % corrupt
    S_corrupt = memory_patterns{1}; % choose a random pattern
    temp = randperm(n_neuron);
    temp_2 = temp(1:number_of_corrupted_bits);
    S_corrupt(temp_2) = - S_corrupt(temp_2);
    
    % recall    
    N_steps = 100; % use 100 as the max steps.
    for i = 1:N_steps
        S_corrupt = sgn(W * S_corrupt);
        if all(S_corrupt == memory_patterns{1},'all')
            number_of_perfect_recall = number_of_perfect_recall + 1;
            fraction_of_errors_each_exp(j) = 0;
            break;
        end
    end
    
    if i == N_steps
        fraction_of_errors_each_exp(j) = sum(S_corrupt ~= memory_patterns{1})/n_neuron;
    end
    
end
fraction_of_perfect_recall = number_of_perfect_recall/n_exp;
fraction_of_errors_mean = mean(fraction_of_errors_each_exp);
fraction_of_errors_mean_std = std(fraction_of_errors_each_exp);
end
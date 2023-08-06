function ratio = recall_all_pattern(W, n_neuron, n_exp, memory_patterns, fraction_of_corrupted_bits)
rng(123);
number_of_corrupted_bits = int32(fraction_of_corrupted_bits * n_neuron);
P = length(memory_patterns);
P_recall = zeros(P,1);
for k = 1:P
    number_of_perfect_recall = 0;
    S_corrupt = memory_patterns{k}; % choose a random pattern
    for j = 1:n_exp
        % corrupt
        temp = randperm(500);
        temp_2 = temp(1:number_of_corrupted_bits);
        S_corrupt(temp_2) = - S_corrupt(temp_2);
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
    fraction_of_perfect_recall = number_of_perfect_recall/n_exp;
    if fraction_of_perfect_recall >= 0.8
        P_recall(k) = 1;
    end
end
ratio = sum(P_recall)/P;
end
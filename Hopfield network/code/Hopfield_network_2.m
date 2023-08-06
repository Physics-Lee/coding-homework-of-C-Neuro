clc;clear;close all;
global W N N_exp memory_pattern

% set up
N = 500; % number of neurons
fraction_of_corrupted_bit = 0.3; % a const
P_range = 10:10:100;
fraction_of_errors = zeros(size(P_range));
for idx = 1:length(P_range)
    P = P_range(idx); % number of patterns
    S = randi([0, 1], [N*P, 1])*2 - 1; % neurons
    memory_pattern = cell(P, 1); % patterns
    for i = 1:P
        memory_pattern{i} = S((i-1)*N+1:i*N);
    end

    % calculate the weight matrix
    W = zeros(N,N);
    for i = 1:N
        for j = i+1:N
            for k = 1:P
                W(i,j) = W(i,j) + 1/N*memory_pattern{k}(i)*memory_pattern{k}(j);
            end
        end
    end
    W = W + W';

    % corrupt and recall
    N_exp = 100;
    [fraction_of_perfect_recall(idx),fraction_of_errors(idx)] = corrupt_and_recall(fraction_of_corrupted_bit);
end

plot(P_range, fraction_of_errors);
xlabel('P');
ylabel('fraction of errors');
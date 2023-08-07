clc;clear;close all;
global W N N_exp memory_pattern

% set up
N = 500; % number of neurons
fraction_of_corrupted_bit = 0.3; % a const
P_range = 1:1:100;
ratio = zeros(size(P_range));
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
    N_exp = 1; % do many exps and calculate the average
    ratio(idx) = recall_all_pattern(fraction_of_corrupted_bit);
end

figure;
plot(P_range/N, 1 - ratio);
xlabel('P/N');
ylabel('fraction of all pattern can not be recalled');
title(['N = ' num2str(N) '; fraction of corrupted bit = ' num2str(fraction_of_corrupted_bit)]);
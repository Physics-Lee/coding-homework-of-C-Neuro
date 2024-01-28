% generate, corrupt and recall.
%
% Yixuan Li, 2024-01-28
%

function [f_error_pattern_mean,f_error_pattern_SEM,f_error_neuron_mean,f_error_neuron_SEM] = generate_corrupt_recall(N_neuron, N_pattern, N_exp, fraction_of_corrupted_bits)

% init
N_corrupted_bits = int32(fraction_of_corrupted_bits * N_neuron);
f_error_pattern = zeros(N_exp, 1);
f_error_neuron = zeros(N_exp, N_pattern);
Is_recalled = false(N_exp, N_pattern);
option_W = "palimpsest";

% loop to repeat exps
for j = 1:N_exp

    % generate patterns
    memory_patterns = generate_memory_patterns(N_neuron,N_pattern);

    % calculate the weight matrix
    switch option_W
        case "vanila"
            W = calculate_W_vectorized(memory_patterns);
        case "palimpsest"
            tau = 0.1;
            W = calculate_W_palimpsest_vectorized(memory_patterns,tau);
    end

    % loop to corrupt each pattern
    for k = 1:N_pattern

        % init
        pattern_now = memory_patterns{k};

        % corrupt
        pattern_now = corrupt_a_pattern(pattern_now,N_neuron,N_corrupted_bits);

        % recall
        N_max_steps = 100;
        for i = 1:N_max_steps
            pattern_now = sgn(W * pattern_now);
            if all(pattern_now == memory_patterns{k},'all')
                Is_recalled(j,k) = true;
                f_error_neuron(j,k) = 0;
                break;
            end
        end

        % after N steps, calculate the number of error neurons
        if i == N_max_steps
            f_error_neuron(j,k) = sum(pattern_now ~= memory_patterns{k})/N_neuron;
        end

    end

    % frequency of error pattern
    f_error_pattern(j,1) = 1 - sum(Is_recalled(j,:)) / N_pattern;

end

% calculate the mean and SEM of f error neuron
f_error_neuron_flatted = reshape(f_error_neuron, [], 1);
f_error_neuron_mean = mean(f_error_neuron_flatted);
f_error_neuron_SEM = std(f_error_neuron_flatted) / sqrt(N_exp);

% calculate the mean and SEM of f error pattern
f_error_pattern_mean = mean(f_error_pattern);
f_error_pattern_SEM = std(f_error_pattern) / sqrt(N_exp);

end
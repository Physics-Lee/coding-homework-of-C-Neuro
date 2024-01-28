% calculate the weight matrix for the palimpsest version
%
% Yixuan Li, 2024-01-28
%

function W = calculate_W_palimpsest_vectorized(memory_patterns, tau)

% Initialize
N_neuron = size(memory_patterns{1}, 1);
N_pattern = numel(memory_patterns);

% Precompute decay factors
decay_factors = exp(-(1:N_pattern) * tau / 2);

% Construct matrix M from memory patterns
M = zeros(N_neuron, N_pattern);
for k = 1:N_pattern
    % Apply decay factor to each pattern using broadcasting
    M(:, k) = memory_patterns{k} * decay_factors(k);
end

% Calculate weights using vectorized operations
W_upper = triu((M * M') / N_neuron, 1);

% Make W symmetric
W = W_upper + W_upper';

end

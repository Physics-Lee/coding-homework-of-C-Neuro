function W = calculate_W_vectorized(memory_patterns)

% Initialize
N_neuron = size(memory_patterns{1}, 1);
N_pattern = numel(memory_patterns);

% Construct matrix M from memory patterns
M = zeros(N_neuron, N_pattern);
for k = 1:N_pattern
    M(:, k) = memory_patterns{k};
end

% Calculate weights
W = (M * M') / N_neuron;

% Keep only the upper triangular part, excluding diagonal
W = triu(W, 1);

% Make W symmetric
W = W + W';

end
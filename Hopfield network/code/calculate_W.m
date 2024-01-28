% calculate the weight matrix
%
% Yixuan Li, 2024-01-28
%

function W = calculate_W(memory_patterns)

% init
N_neuron = size(memory_patterns{1}, 1);
N_pattern = numel(memory_patterns);
W = zeros(N_neuron,N_neuron);

% calculate
for i = 1:N_neuron
    for j = i+1:N_neuron
        for k = 1:N_pattern
            W(i,j) = W(i,j) + 1 / N_neuron * memory_patterns{k}(i) * memory_patterns{k}(j);
        end
    end
end
W = W + W';

end
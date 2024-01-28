% calculate the weight matrix
%
% Yixuan Li, 2024-01-28
%

function W = calculate_W(N_neuron,N_memory_pattern,memory_patterns)

W = zeros(N_neuron,N_neuron);
for i = 1:N_neuron
    for j = i+1:N_neuron
        for k = 1:N_memory_pattern
            W(i,j) = W(i,j) + 1/N_neuron*memory_patterns{k}(i)*memory_patterns{k}(j);
        end
    end
end
W = W + W';

end
function W = calculate_W(n_neuron,n_memory_pattern,memory_patterns)
% calculate the weight matrix
W = zeros(n_neuron,n_neuron);
for i = 1:n_neuron
    for j = i+1:n_neuron
        for k = 1:n_memory_pattern
            W(i,j) = W(i,j) + 1/n_neuron*memory_patterns{k}(i)*memory_patterns{k}(j);
        end
    end
end
W = W + W';
end
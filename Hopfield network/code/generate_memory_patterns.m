function memory_patterns = generate_memory_patterns(n_neuron,n_memory_pattern)
memory_patterns = cell(n_memory_pattern, 1);
for i = 1:n_memory_pattern
    memory_patterns{i} = randi([0, 1], [n_neuron, 1])*2 - 1; % generate +1 and -1 randomly
end
end
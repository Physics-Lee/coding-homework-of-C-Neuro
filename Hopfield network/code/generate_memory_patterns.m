% generate memory patterns as +1 or -1 randomly
%
% Yixuan Li, 2024-01-28
%

function memory_patterns = generate_memory_patterns(N_neuron,N_memory_pattern)

memory_patterns = cell(N_memory_pattern, 1);
for i = 1:N_memory_pattern
    memory_patterns{i} = randi([0, 1], [N_neuron, 1])*2 - 1; % generate +1 or -1 randomly
end

end
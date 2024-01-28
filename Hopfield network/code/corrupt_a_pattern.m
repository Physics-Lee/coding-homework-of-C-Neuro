% corrupt a pattern by turn -1 to +1 and +1 to -1
%
% Yixuan Li, 2024-01-28
%

function pattern_now = corrupt_a_pattern(pattern_now,N_neuron,N_corrupted_bits)

% choose random neurons
idx_neuron_randomized = randperm(N_neuron);
idx_neuron_corrupted = idx_neuron_randomized(1:N_corrupted_bits);

% corrupt by turn -1 to +1 and +1 to -1
pattern_now(idx_neuron_corrupted) = - pattern_now(idx_neuron_corrupted);

end
function Poisson_process_ext = generate_Poisson_process(nu_ext,t_max,N_neuron,C_ext)
% return a cell array, each element contains the arrival moment of the
% event of the Poisson process

% generate event counts
n_event = poissrnd(nu_ext * t_max, N_neuron, C_ext);

% using arrayfun to replace nested loops
func = @(x) round(random('Uniform', 0, t_max, 1, x), 1);
Poisson_process_ext = arrayfun(func, n_event, 'UniformOutput', false);

end
function Poisson_process_ext = generate_Poisson_process(nu_ext,t_max,N_neuron,C_ext)

% init
Poisson_process_ext = cell(N_neuron, C_ext);

% generate event counts
num_events = poissrnd(nu_ext * t_max, N_neuron, C_ext);

% mean_of_time_interval_ext of external neuron
mean_of_time_interval_ext = 1 / nu_ext;

% loop to process each neuron
for i = 1:N_neuron

    % lopp to process each external neuron 
    for j = 1:C_ext
        % event_times = cumsum(exprnd(mean_of_time_interval_ext, 1, num_events(i,j))); % generate event moments
        % Poisson_process_ext{i,j} = round(event_times, 1); % only preserve to 0.1
        Poisson_process_ext{i,j} = random('Uniform',0,t_max,N_neuron,1);
    end

end

end
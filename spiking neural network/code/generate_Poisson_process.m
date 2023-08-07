function event_times = generate_Poisson_process(nu_ext,T)
num_events = poissrnd(nu_ext*T);  % generate sequence of event counts
mean_of_time_interval = 1/nu_ext;  % mean inter-arrival time
event_times = cumsum(exprnd(mean_of_time_interval,1,num_events)); % generate event times
event_times = round(event_times,1); % only preserve to 0.1
end
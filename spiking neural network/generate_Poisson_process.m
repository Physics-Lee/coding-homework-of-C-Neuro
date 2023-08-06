function event_times = generate_Poisson_process(nu_ext,T)
num_events = poissrnd(nu_ext*T);  % generate sequence of event counts
mean_interval = 1/nu_ext;  % mean inter-arrival time
event_times = cumsum(exprnd(mean_interval,1,num_events));  % generate event times
event_times = roundn(event_times,-1);
end
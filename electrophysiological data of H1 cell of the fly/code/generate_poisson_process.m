% This function can generate a Poisson process
%
% Input:
% lambda: rate parameter of the Poisson process
% total_time: total time for which the process is simulated
%
% Yixuan Li, 2023-11-13

function t_events = generate_poisson_process(lambda, t_total)

% Estimate the number of events (a bit over the expected number to be safe)
estimated_events = ceil(lambda * t_total * 1.5);

% Generate a series of inter-arrival times
inter_arrival_times = exprnd(1/lambda, 1, estimated_events);

% Calculate the cumulative sum of the inter-arrival times
event_times_cumulative = cumsum(inter_arrival_times);

% Filter out the event times that exceed the total time
t_events = event_times_cumulative(event_times_cumulative < t_total);
t_events = t_events';

end
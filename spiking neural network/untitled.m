% Example data (10 trials, random spikes)
data = rand(10, 100) > 0.9;

figure; % Create a new figure
hold on; % Hold the plot so that subsequent lines are added to the same figure

% Loop through the trials
for trial = 1:size(data, 1)
    spike_times = find(data(trial, :)); % Find the spike times
    y = trial * ones(size(spike_times)); % Create a y value for this trial
    plot(spike_times, y, 'k.'); % Plot the spikes
end

xlabel('Time');
ylabel('Trial');
title('Raster Plot');

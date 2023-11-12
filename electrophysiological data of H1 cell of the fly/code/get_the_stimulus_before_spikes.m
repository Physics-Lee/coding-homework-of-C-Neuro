function s_before_spikes = get_the_stimulus_before_spikes(stim,fire_indices,frame_window)

% init
n_fire = length(fire_indices);
results = cell(n_fire, 1);

% loop to process each fire
for i = 1:n_fire
    start_idx = fire_indices(i) - frame_window;
    end_idx = fire_indices(i) - 1;

    if start_idx >= 1
        results{i} = stim(start_idx:end_idx);
    end
end

% Filter out segments that are not exactly 150 elements long
valid_segments = cellfun(@(x) length(x) == 150, results);
filtered_results = results(valid_segments);

% Concatenate valid segments into a matrix
concatenated_segments = cell2mat(filtered_results');

% Calculate the average of the concatenated segments
s_before_spikes = mean(concatenated_segments, 2);

end
function is_fire_all_new = make_rp_as_firing(is_fire_all)

[rows, cols] = size(is_fire_all);
spread_window = 10; % Number of elements to spread

% Create a matrix to shift by spread_window
shifted_matrix = [is_fire_all, zeros(rows, spread_window)];

% Shift by spread_window and take the maximum along a window
for i = 1:spread_window
    shifted_matrix = max(shifted_matrix, [zeros(rows, i), is_fire_all, zeros(rows, spread_window - i)]);
end

% Take the maximum with the original matrix to get the final result
is_fire_all_new = max(is_fire_all, shifted_matrix(:, 1:cols));

end
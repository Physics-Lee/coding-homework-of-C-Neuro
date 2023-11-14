function acf = auto_corr_manual(time_series, max_lag)
    % manual_autocorr_vectorized - Vectorized calculation of the autocorrelation
    %                              of a time series.
    %
    % Inputs:
    %   time_series - The input time series data (a vector).
    %   max_lag - The maximum lag for which autocorrelation is calculated.
    %
    % Outputs:
    %   acf - Autocorrelation coefficients up to max_lag.

    % Subtract the mean from the time series.
    time_series = time_series - mean(time_series);
    n = length(time_series);

    % Pre-allocate the autocorrelation array.
    acf = zeros(max_lag + 1, 1);

    % Calculate the variance of the time series.
    ts_variance = var(time_series);

    % Compute autocorrelation for each lag
    for lag = 0:max_lag
        % Create shifted version of time series
        shifted_ts = [zeros(lag, 1); time_series(1:end-lag)];

        % Compute autocorrelation for the given lag
        acf(lag + 1) = sum(time_series .* shifted_ts) / (n - lag);
    end

    % Normalize the autocorrelation sequence
    acf = acf / ts_variance;
end
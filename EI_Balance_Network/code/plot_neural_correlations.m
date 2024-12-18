function plot_neural_correlations(X)
    % X is a matrix of size (N_neurons x N_timepoints)
    % In your case: X is 500x10000
    % This function will:
    % 1) Compute the pairwise Pearson correlation across neurons and plot a heatmap.
    % 2) Compute autocorrelation for each neuron, then plot the mean + SEM across neurons.

    % Check dimensions
    [N, T] = size(X);
    if N ~= 500
        warning('Matrix rows do not equal 500. Proceeding anyway...');
    end
    if T ~= 10000
        warning('Matrix columns do not equal 10000. Proceeding anyway...');
    end

    %% 1. Pairwise Pearson correlation across neurons
    % Corr matrix: NxN
    C = corr(X'); % neurons as variables

    % plot
    figure('Name', 'Pairwise Neuron Correlation', 'NumberTitle', 'off');
    imagesc(C);
    colorbar;
    colormap('jet');
    axis square;
    title('Pairwise Neuron Pearson Correlation');
    xlabel('Neuron Index');
    ylabel('Neuron Index');
    % Optional: set caxis for better contrast
    % caxis([-1 1]);

    %% 2. Autocorrelation for each neuron
    % We'll compute full autocorr (symmetric about zero lag).
    ACF = zeros(N, 2*T-1); 
    for i = 1:N
        % xcorr with 'coeff' normalizes so that autocorr at lag 0 = 1
        ac = xcorr(X(i,:), 'coeff');
        ACF(i,:) = ac;
    end

    % Mean and SEM across neurons
    meanACF = mean(ACF,1);
    semACF = std(ACF,[],1)/sqrt(N);

    % Define time lags
    % xcorr returns lags from -(T-1) to (T-1)
    lags = -(T-1):(T-1);

    % Since ACF is even, we only need to plot non-negative lags (0 to T-1)
    zeroLagIndex = T; % index corresponding to lag = 0
    posLags = lags(zeroLagIndex:end);        % from 0 to T-1
    posMeanACF = meanACF(zeroLagIndex:end);
    posSemACF = semACF(zeroLagIndex:end);

    %% 3. Plot the mean autocorrelation function with SEM for non-negative lags
    figure('Name', 'Mean Autocorrelation (Right Half)', 'NumberTitle', 'off');
    hold on;
    errorbar(posLags, posMeanACF, posSemACF, 'b-', 'LineWidth', 2);
    xlabel('Lag (tau)');
    ylabel('Autocorrelation (r)');
    title('Mean Autocorrelation with SEM (Non-negative Lags)');
    hold off;
end
function test_Poisson_process(isi)

%% Plot the histogram of inter-spike intervals
figure;
bin_length = 0.01; % s
t_start = 0.00;
t_end = 0.7;
edges = [t_start t_start:bin_length:t_end t_end]; % s
histogram(isi,edges,'Normalization','pdf');
[y_data, bin_edges] = histcounts(isi, edges(2:end-1), 'Normalization', 'pdf');
title('Histogram of Inter-Spike Intervals');
xlabel('Interval (seconds)');
ylabel('pdf');
hold on;
set_semilogy;
% set_linearlinear;
[slope,intercept] = add_linear_fit(isi, edges);

%% calculate the lambda (if u use isi > 0.02, they will be similar)

% lambda_method_1
lambda_method_1 = - slope;
fprintf('lambda (method 1): %.4f\n', lambda_method_1);

% lambda_method_2
lambda_method_2 = exp(intercept);
fprintf('lambda (method 2): %.4f\n', lambda_method_2);

% lambda_method_3
lambda_method_3 = 1 / mean(isi);
fprintf('lambda (method 3): %.4f\n', lambda_method_3);

% check pdf
integral = sum(y_data) * (bin_edges(2) - bin_edges(1));
if abs(integral - 1) < 10^(-4)
    fprintf('The integral of pdf == 1\n');
    fprintf('Checking succeeds\n');
else
    fprintf('The integral of pdf != 1\n');
    fprintf('Checking fails\n');
end

end
clc;
clear;
close all;

% Constants
tau = 1e-2; % s
tau_adapt = 0.2; % s
range_of_I_e = 1 + [0.001:0.001:0.01, 0.01:0.01:1]; % no dimension
J_adapt_values = [0, 0.1, 0.5, 1]; % Different J_adapt values

% Initialize results cell array
f_theory = cell(length(J_adapt_values), 1);

% Calculate
for i = 1:length(J_adapt_values)
    J_adapt = J_adapt_values(i);
    f_theory{i} = numerical_solution_of_algebraic_equation(tau, tau_adapt, J_adapt, range_of_I_e);
end

%% Plot
figure;
hold on;

% Loop through each J_adapt value
for i = 1:length(J_adapt_values)
    plot(range_of_I_e, f_theory{i}, 'DisplayName', sprintf('J_{adapt} = %.2f', J_adapt_values(i)));
end

% label, title, legend, lim
xlabel('I_e (no dimension)');
ylabel('f_{theory} (Hz)');
title('f_{theory} for different J_{adapt} values');
legend('show');
xlim([0.9,max(range_of_I_e)]);

hold off;
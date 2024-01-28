clc;clear;close all;

% paras
N = 500;
P = 0:1:15;
tau = 0.1;

% calculate
P_error_pattern = 1 - 1/2*N.*(1-erf(sqrt(N*tau)./exp(P*tau)));

% plot
figure;
plot(N,P_error_pattern,'black-o');
xlabel("N_{neuron}");
ylabel("P(error pattern)");
title("Analyze Result of the Palimpsest");
ylim([0 1]);

% plot
figure;
plot(tau,P_error_pattern,'black-o');
xlabel("tau");
ylabel("P(error pattern)");
title("Analyze Result of the Palimpsest");
ylim([0 1]);

% plot
figure;
plot(P/N,P_error_pattern,'black-o');
xlabel("N_{pattern}/N_{neuron}");
ylabel("P(error pattern)");
title("Analyze Result of the Palimpsest");
ylim([0 1]);
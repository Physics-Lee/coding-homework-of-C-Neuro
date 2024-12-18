function plot_mean_r(time, rE_record, rI_record, wEE, wIE, wEI, wII, c_out)

% Plot average firing rates
avg_rE = mean(rE_record, 1);
avg_rI = mean(rI_record, 1);

figure;
plot(time, avg_rE, 'LineWidth', 2);
hold on;
plot(time, avg_rI, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Average Firing Rate');
legend('E Population', 'I Population');
title('E-I Balanced Network Firing Rates');
subtitle(sprintf('wEE = %.2f; wIE = %.2f; wEI = %.2f; wII = %.2f; beta_E = %.2f; beta_I = %.2f', wEE, wIE, wEI, wII, c_out, c_out * 0.8));
grid on;

 end
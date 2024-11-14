function plot_theta_u(theta, u)

% Plot the results
figure('Position', [100, 100, 800, 400]);

% Plot the neuronal activity as a function of angle
subplot(1, 2, 1);
plot(theta, u, 'o-');
xlabel('Neuron Preferred Angle \theta');
ylabel('Activity Level u(\theta)');
title('Neuronal Activity Distribution');
xlim([0, 2 * pi]);
xticks(0:pi/2:2*pi);
xticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});

% Plot the neuronal activity in polar coordinates
subplot(1, 2, 2, polaraxes);
polarplot(theta, u, 'o-');
title('Neuronal Activity Polar Plot');
set(gca, 'ThetaZeroLocation', 'top', 'ThetaDir', 'clockwise');

% Adjust layout
sgtitle('Ring Network Model Simulation');

end
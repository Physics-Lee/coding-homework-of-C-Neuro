% plot

% normal
figure;
plot(g_range,mean_firing_rate,'black-o');

xlabel('g');
ylabel('mean firing rate');
title('normal axis');
legend(['ratio = ' num2str(ratio_of_nu)]);

% semilogy
figure;
semilogy(g_range,mean_firing_rate,'black-o');

xlabel('g');
ylabel('mean firing rate');
title('semilogy');
legend(['ratio = ' num2str(ratio_of_nu)]);

% loglog
figure;
loglog(g_range,mean_firing_rate,'black-o');

xlabel('g');
ylabel('mean firing rate');
title('loglog');
legend(['ratio = ' num2str(ratio_of_nu)]);
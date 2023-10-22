tau = 20; % ms
tau_r = 2; % ms
I = 1:0.1:100;
f_without_refractory = 1./(tau.*log(1+1./(I-1)));
f_with_refractory = 1./(tau.*log(1+1./(I-1))+tau_r);
plot(I,f_without_refractory);
hold on;
plot(I,f_with_refractory);
xlabel('$\tilde{I}$ (no dimension)','Interpreter','latex');
ylabel('f (kHz)');
legend('without \tau_r','with \tau_r');
title(['\tau = ' num2str(tau) ' ms' '    \tau_r = ' num2str(tau_r) ' ms']);
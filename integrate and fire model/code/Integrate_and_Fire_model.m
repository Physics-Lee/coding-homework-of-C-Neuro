clc;clear;close all;
tau = 20; % ms
tau_r = 40; % ms
t_max = 100; % ms
omega = 0.2; % 1/ms=kHz
sample_frequency = 1000; % Hz

%% switch
option = input("Do you want to draw the analytic solution of 1.2 or 1.3? Enter 2 for problem 1.2 and 3 for problem 1.3.\n");
switch option
    case 2
        I = 2;
        V = @(t) I*(1-exp(-t/tau)); % question 1.2
    case 3
        I = (1+omega^2*tau^2)^(1/2) + 1;
        V = @(t)(I/(1+tau^2*omega^2))*(-exp(-t/tau)+cos(omega*t)+(omega*tau)*sin(omega*t)); % question 1.3
    otherwise
        error("Invalid option selected. Please enter 2 for problem 1.2 or 3 for problem 1.3.");
end

%% without threshold
t = 0:1/sample_frequency:t_max;
plot(t,V(t),'red');
hold on;

%% threshold
T = fzero(@(t) V(t) - 1, 0); % Find the time when V(t) = 1
count = 1;
number_of_period = 0;
for t = 0:1/sample_frequency:t_max
    
    t_temp = t - T * number_of_period;
    
    if V(t_temp) >= 1 % reset V
        number_of_period = number_of_period + 1;
        t_temp = t - T * number_of_period;
    end
    
    membrane_voltage_2(count) = V(t_temp);
    count = count + 1;
    
end
t = 0:1/sample_frequency:t_max;
plot(t,membrane_voltage_2,'blue');

%% threshold + refractory period
count = 1;
number_of_period = 0;
for t = 0:1/sample_frequency:t_max
    
    t_temp = t - T * number_of_period;
    
    if V(t_temp) >= 1  % reset V
        number_of_period = number_of_period + 1;
        if number_of_period == 1
            T = t;
        end
        t_temp = t - T * number_of_period;
        t_refractory = t + tau_r;
        for i = t:1/sample_frequency:t_refractory % refractory
            membrane_voltage_3(count) = 0;
            count = count + 1;
        end
    end
    
    membrane_voltage_3(count) = V(t_temp);
    count = count + 1;
    
end
t = 0:1/sample_frequency:1/sample_frequency*(length(membrane_voltage_3) - 1);
plot(t,membrane_voltage_3,'magenta--');

xlabel('t(ms)');
ylabel('V tilde');
title(['I tilde = ' num2str(I) '    \omega = ' num2str(omega) ' kHz' '    \tau = ' num2str(tau) ' ms' '    \tau_r = ' num2str(tau_r) ' ms' '    T = ' num2str(T) ' ms']);
xlim([0 t_max]);

%% find peaks
[peaks_2,locations_2] = findpeaks(membrane_voltage_2);
locations_2 = locations_2*1/sample_frequency;
scatter(locations_2,peaks_2);

[peaks_3,locations_3] = findpeaks(membrane_voltage_3(1:length(membrane_voltage_2)));
locations_3 = locations_3*1/sample_frequency;
scatter(locations_3,peaks_3);

frequency_exogenous = omega*1000/(2*pi); % for 1.3
frequency_simulation_without_refractory = 1000/t_max*length(peaks_2);
frequency_simulation_with_refractory = 1000/t_max*length(peaks_3);

legend('no threshold', 'threshold', 'threshold + refractory period', 'peak 1', 'peak 2');
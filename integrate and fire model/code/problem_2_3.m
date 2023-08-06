clc;clear;close all;

%% set parameter
K = 10000; % dimensionless
K_excitatory = 0.8*K;
K_inhibitory = 0.2*K;

tau = 20; % ms
r_0 = 3; % r_0 must have the dimension of current. % We need r_0 > I_c
I_c = 1; % I_c must have the dimension of current.
ratio_J_I_c = 10000;
J = I_c*ratio_J_I_c;
omega_weight_excitatory = 1/K*J; % dimensionless
omega_weight_inhibitory = 1/K*J*4; % dimensionless

t_max = 100; % ms
delta_t = 0.1; % ms % 我们认为：在这一小段时间里，I_e是恒定的
number_of_piece = t_max/delta_t; % dimensionless
sample_frequency = 10000; % Hz

sigma_square = 1; % (mA)^2*s
varience_of_xi = sigma_square/(delta_t*10^(-3)); % (mA)^2
dB_sigma_square = 10*(log(varience_of_xi)/log(10));
hold on;

%% simulate V_dimensionless by thousands of piecewise function
count = 1;
V_dimensionless_1 = zeros(1,t_max*sample_frequency);
V_dimensionless_2 = zeros(1,t_max*sample_frequency);
number_of_period = 0;
flag = 0;
count_fire = 0;
for i = 1:number_of_piece
    
    % without threshold
    xi_excitatory = wgn(K_excitatory,1,dB_sigma_square);
    xi_inhibitory = wgn(K_inhibitory,1,dB_sigma_square);
    I_external = (K_excitatory*omega_weight_excitatory*r_0-K_inhibitory*omega_weight_inhibitory*r_0) + (omega_weight_excitatory*sum(xi_excitatory)-omega_weight_inhibitory*sum(xi_inhibitory));
    I_dimensionless = I_external/I_c;
    
    if i == 1
        V_dimensionless_1_0 = 0;
        for t = 0:1/sample_frequency:delta_t
            V_dimensionless_1(count) = (V_dimensionless_1_0 - I_dimensionless)*exp(-t/tau) + I_dimensionless;
            V_dimensionless_2(count) = V_dimensionless_1(count); % 第一次肯定不会直接突破阈值1
            count = count + 1;
        end
    else
        V_dimensionless_1_0 = V_dimensionless_1(count-1);
        V_dimensionless_2_0 = V_dimensionless_2(count-1);
        for t = 0 + 1/sample_frequency:1/sample_frequency:delta_t
            V_dimensionless_1(count) = (V_dimensionless_1_0 - I_dimensionless)*exp(-t/tau) + I_dimensionless;
            if flag == 0
                V_dimensionless_2(count) = (V_dimensionless_2_0 - I_dimensionless)*exp(-t/tau) + I_dimensionless;
                if V_dimensionless_2(count) >= 1
                    count_fire = count_fire + 1;
                    flag = 1;
                    V_dimensionless_2(count) = 0;
                    t_0 = t;
                end
            end
            if flag == 1
                V_dimensionless_2_0 = V_dimensionless_2(count);
                V_dimensionless_2(count) = (V_dimensionless_2_0 - I_dimensionless)*exp(-(t-t_0)/tau) + I_dimensionless;
            end
            count = count + 1;
        end
        flag = 0;
    end    
end
t = 0:1/sample_frequency:t_max;
plot(t,V_dimensionless_1,'red');
plot(t,V_dimensionless_2,'blue');
legend('without threshold','with threshold');

%% title
xlabel('t(ms)');
ylabel('V tilde');
title(['    J/I_c = ' num2str(ratio_J_I_c) '    count of fire = ' num2str(count_fire)]);
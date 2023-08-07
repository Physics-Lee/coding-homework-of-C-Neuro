clc;clear;close all;

%% set parameter
K = 1000; % dimensionless
t_max = 100; % ms
delta_t = 0.1; % ms % 我们认为：在这一小段时间里，I_e是恒定的
number_of_piece = t_max/delta_t; % dimensionless
m = K; % m*n means m samples and n channels/moments
n = number_of_piece; % m*n means m samples and n channels/moments

tau = 20; % ms
omega_weight = 1/K; % dimensionless
r_0 = 3; % r_0 must have the dimension of current. % We need r_0 > I_c
I_c = 1; % I_c must have the dimension of current.
sample_frequency = 10000; % Hz

sigma_square = 1; % (mA)^2*s
varience_of_xi = sigma_square/(delta_t*10^(-3)); % (mA)^2
cov_of_2_xi = 0.5 * varience_of_xi;
dB_sigma_square = 10*(log(varience_of_xi)/log(10)); % 0 is 0 dBW, which is equal to 1W.
xi_0 = wgn(m,1,dB_sigma_square);
xi_0_normalized = xi_0/(varience_of_xi)^(1/2);
xi_all_you_need = wgn_positive_correlation(xi_0_normalized,m,n,varience_of_xi,cov_of_2_xi);
hold on;

%% simulate V_dimensionless by thousands of piecewise function
count = 1;
V_dimensionless_1 = zeros(1,t_max*sample_frequency);
V_dimensionless_2 = zeros(1,t_max*sample_frequency);
number_of_period = 0;
flag = 0;
for i = 1:number_of_piece
    
    % without threshold
    xi  = xi_all_you_need(:,i);
    I_e = K*omega_weight*r_0 + omega_weight*sum(xi);
    I_dimensionless = I_e/I_c;
    
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

%% title
xlabel('t(ms)');
ylabel('V tilde');
title(['K = ' num2str(K)]);
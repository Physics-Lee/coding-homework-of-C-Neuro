clc;clear;close all;

%% E-E
J0 = 1;
u0 = 3;
N = 10;

tau = 1;
dt = 0.01;
t_max = 10;
sigma = 0.1;

[t_all,v] = EEStimulate(u0, J0, N, sigma, dt, t_max, tau);
plot(t_all,v)
xlabel('t');
ylabel('v');
title(strcat('J0=',num2str(J0),' u0=',num2str(u0),' N=',num2str(N)));

%% E-I
Je = 1; Ji = 4;
ne = 0.8; ni = 0.2;
u0 = 3;
N = 100;
I_0 = 1;

tau = 1;
dt = 0.01;
t_max = 100;
sigma = 0.1;

[t_all, v] = EIStimulate(u0, Je, Ji, ne, ni, N, sigma, dt, t_max, tau, I_0);
figure(2)
plot(t_all,v)
xlabel('t');
ylabel('v');
title(strcat('Je=',num2str(Je),' Ji=',num2str(Ji),' N=',num2str(N),' I_0=',num2str(I_0)));
hold on;

[peaks,locations] = findpeaks(v);
locations = locations*dt;
mask = peaks >= 1;
peaks = peaks(mask);
locations = locations(mask);
scatter(locations,peaks);

n = 10;
intervals = 0:t_max/n:t_max;
firing_rate = histcounts(locations, intervals)/(t_max/n);
fprintf('Fano Factor is %f\n',var(firing_rate)/mean(firing_rate));
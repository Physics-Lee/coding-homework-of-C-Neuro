clear;clc;close all;

%% constant 
% I_e and t_max
I_e = 84.6; % nA
t_max = 100; % ms
range_of_t = [0,t_max]; % ms

% basic
C_m = 10; % nF/mm^2
g_K = 0.36; % mS/mm^2
g_Na = 1.2; % mS/mm^2
g_L = 0.003; % mS/mm^2
E_K = -77; % mV
E_Na = 50; % mV
E_L = -54.387; % mV

% alpha and beta
Alpha_n = @(V) (0.01.*(V+55))./(1-exp(-0.1.*(V+55)));
Beta_n = @(V) 0.125.*exp(-0.0125.*(V+65));
Alpha_m = @(V) (0.1.*(V+40))./(1-exp(-0.1.*(V+40)));
Beta_m = @(V) 4.*exp(-0.0556.*(V+65));
Alpha_h = @(V) 0.07.*exp(-0.05.*(V+65));
Beta_h = @(V) 1./(1+exp(-0.1.*(V+35)));

%% use ode45 to solve ODEs
% 4-variable-1-order linear ODEs, where y(1) y(2) y(3) y(4) represents V n m h   
Hodgkin_Huxley_ODEs = @(t,y)...       
    [(1./C_m).*(10^3*(-g_K.*(y(2).^4).*(y(1)-E_K)-g_Na.*(y(3).^3).*y(4).*(y(1)-E_Na)-g_L.*(y(1)-E_L))+I_e); % *10^3 will convert μA to nA
    Alpha_n(y(1)).*(1-y(2))-Beta_n(y(1)).*y(2);
    Alpha_m(y(1)).*(1-y(3))-Beta_m(y(1)).*y(3);
    Alpha_h(y(1)).*(1-y(4))-Beta_h(y(1)).*y(4)];

% initial value of y
y_0 = [-64.9964 0.3177 0.0530 0.5960]; % [-64.9964 0.3177 0.0530 0.5960] is the value of [V n m h] when Ie = 0 nA and the system enters steady state.

% ode45
[t,y] = ode45(Hodgkin_Huxley_ODEs,range_of_t,y_0); % core

% find peaks
[Vmax,tmax] = findpeaks(y(:,1),t,'MinPeakProminence',1);
[Vmin,tmin] = findpeaks(-y(:,1),t,'MinPeakProminence',1);
Vmin = -Vmin;

% plot V
figure;
subplot(2,1,1);
plot(t,y(:,1),'black');
hold on;
scatter(tmax,Vmax,'blueo');
scatter(tmin,Vmin,'redo');
xlabel('t (ms)');
ylabel('V (mV)');
title(['I_e = ' num2str(I_e) ' nA'])
legend('V','Vmax','Vmin');

% plot n m h
subplot(2,1,2);
plot(t,y(:,2),'blue');
hold on;
plot(t,y(:,3),'green');
plot(t,y(:,4),'red');
legend('n','m','h');
xlabel('t (ms)');
ylabel('Probability');
title(['I_e = ' num2str(I_e) ' nA'])

%% frequency-I_e
prompt = "Do you want to draw the graph of frequency-Ie?" + newline + "1: Yes" + newline + "2: No \n";
flag = input(prompt);
switch flag
    case 1
        count = 0;
        range_of_I_e = 100:10:700;
        T = zeros(1,length(range_of_I_e));
        f = zeros(1,length(range_of_I_e));
        range_of_t = [0,t_max];
        for I_e = range_of_I_e
            count = count+1;
            
            % ODE
            Hodgkin_Huxley_ODEs = @(t,y)...
                [(1./C_m).*(10^3*(-g_K.*(y(2).^4).*(y(1)-E_K)-g_Na.*(y(3).^3).*y(4).*(y(1)-E_Na)-g_L.*(y(1)-E_L))+I_e);
                Alpha_n(y(1)).*(1-y(2))-Beta_n(y(1)).*y(2);
                Alpha_m(y(1)).*(1-y(3))-Beta_m(y(1)).*y(3);
                Alpha_h(y(1)).*(1-y(4))-Beta_h(y(1)).*y(4)];
            
            % initial value of y
            y_0 = [-64.9964 0.3177 0.0530 0.5960]; % [-64.9964 0.3177 0.0530 0.5960] is the value of [V n m h] when Ie = 0 nA and the system enters steady state.
            
            % ode45
            [t,y] = ode45(Hodgkin_Huxley_ODEs,range_of_t,y_0);
            
            % find peaks
            [~,tmax] = findpeaks(y(:,1),t,'MinPeakProminence',1);
            trial = 5; % only_use_1_trial_to_estimate
            T(count) = tmax(trial) - tmax(trial - 1);
            f(count) = 1 / T(count);
            
        end
        I_e = range_of_I_e;
        figure;
        plot(I_e,f,'black');
        xlabel('Ie (nA）');
        ylabel('f (kHz）');
        title('f vs Ie')
    case 0
end

%% phase graph
prompt = "Do you want to draw the phase graph?" + newline + "1: Yes" + newline + "2: No \n";
flag = input(prompt);
switch flag
    case 1
        figure;
        V = y(:,1);
        n = y(:,2);
        plot(V,n);
        xlabel('V (mV）');
        ylabel('n (no dimension）');
        title('2D graph');
        
        m = y(:,3);
        figure;
        plot3(V,n,m);
        xlabel('V (mV）');
        ylabel('n (no dimension）');
        zlabel('m (no dimension）');
        title('3D graph');
    case 0
end

% video-lize the image
prompt = "Do you want to video-lize the phase graph?" + newline + "1: Yes" + newline + "2: No \n";
flag = input(prompt);
switch flag
    case 1
        figure;
        number_of_point_drawed_at_one_time = 100;
        for i = 1:number_of_point_drawed_at_one_time:length(V) - number_of_point_drawed_at_one_time
            plot(V(i:i+number_of_point_drawed_at_one_time),n(i:i+number_of_point_drawed_at_one_time));
            hold on;
            pause(0.5)
        end
        xlabel('V (mV）');
        ylabel('n (no dimension）');
        title('2D graph');
        
        figure;
        number_of_point_drawed_at_one_time = 100;
        for i = 1:number_of_point_drawed_at_one_time:length(V) - number_of_point_drawed_at_one_time
            plot3(V(i:i+number_of_point_drawed_at_one_time),...
                n(i:i+number_of_point_drawed_at_one_time),...
                m(i:i+number_of_point_drawed_at_one_time));
            hold on;
            pause(0.5)
        end
        xlabel('V (mV）');
        ylabel('n (no dimension）');
        zlabel('m (no dimension）');
        title('3D graph');
    case 0
end
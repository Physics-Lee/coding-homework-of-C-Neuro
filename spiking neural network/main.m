clear;close all;

%% set up

% const
tau = 20; % ms, time constant of each neuron
V_threshold = 20; % mV, voltage threshold of neuron firing
V_reset = 10; % mV, voltage of resting potential
tau_rp = 2; % ms, refraction period
D = 1.8; % ms, time delay for the transition of electrical signal
J = 0.2; % mV, connect strength of the synapse

% number of neurons
N = 1000; % number of all neurons
N_E = 0.8*N; % number of excitory neurons
N_I = 0.2*N; % number of inhibitory neurons

% connections of a neuron
epsilon = 0.1;
C_E = epsilon * N_E;
C_I = epsilon * N_I;
C_ext = C_E;

nu_thr = (V_threshold - 0) / (J*C_E*tau); % 1/ms
ratio_of_nu = 1; % 0 1 2
nu_ext = ratio_of_nu * nu_thr;

g_range = 1:10;
mean_firing_rate = zeros(1,length(g_range));
count = 0;

% loop to explore the effect of different g
for g = g_range

    % count
    count = count + 1;

    % set J
    J_ext = J;
    J_EE = J;
    J_IE = J;
    J_EI = -g*J;
    J_II = -g*J;

    t_max = 100; % ms
    Poisson_process_ext = cell(N, C_ext); % 1000*80 Poisson processes
    for i = 1:N
        for j = 1:C_ext
            Poisson_process_ext{i,j} = generate_Poisson_process(nu_ext,t_max);
        end
    end

    E_id = randi([1, N_E],[N,C_E]);
    I_id = randi([N_E+1, N],[N,C_I]);

    dt = 0.1; % ms
    t_all = 0:dt:t_max;
    V = zeros(N,length(t_all) - 1 + 2);
    flag_fire = zeros(N,length(t_all) - 1);
    for tt = 1:tau_rp/dt
        V(:,tt) = V_reset;
    end

    for tt = tau_rp/dt:length(t_all) - 1
        for i = 1:N_E

            dV = 0;

            if tt > tau_rp/dt && sum(flag_fire(i,tt-tau_rp/dt:tt)) ~= 0
                V(i,tt+1) = V_reset;
                continue;
            end

            for j = 1:C_ext
                if sum(Poisson_process_ext{i,j} == (t_all(tt)-D)) == 1
                    dV = dV + J_ext * 1;
                end
            end

            for j = 1:C_E
                if flag_fire(E_id(i,j),tt-D/dt) == 1
                    dV = dV + J_EE * 1;
                end
            end

            for j = 1:C_I
                if flag_fire(I_id(i,j),tt-D/dt) == 1
                    dV = dV + J_EI * 1;
                end
            end

            V(i,tt+1) = V(i,tt) + dV;

            if V(i,tt+1) > V_threshold
                flag_fire(i,tt + 1) = 1;
            end
            
            if V(i,tt+1) == 0
                a = 1;
            end

        end

        for i = N_E+1:N

            dV = 0;

            if tt > tau_rp/dt && sum(flag_fire(i,tt-tau_rp/dt:tt)) ~= 0
                V(i,tt+1) = V_reset;
                continue;
            end

            for j = 1:C_ext
                if sum(Poisson_process_ext{i,j} == (t_all(tt)-D)) == 1
                    dV = dV + J_ext * 1;
                end
            end

            for j = 1:C_E
                if flag_fire(E_id(i,j),tt-D/dt) == 1
                    dV = dV + J_IE * 1;
                end
            end

            for j = 1:C_I
                if flag_fire(I_id(i,j),tt-D/dt) == 1
                    dV = dV + J_II * 1;
                end
            end

            V(i,tt+1) = V(i,tt) + dV;

            if V(i,tt+1) > V_threshold
                flag_fire(i,tt + 1) = 1;
            end

        end
    end
    firing_rate = sum(flag_fire,2)/(t_max*0.001);
    mean_firing_rate(count) = mean(firing_rate);
end

%% plot

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
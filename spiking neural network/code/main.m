clc;clear;close all;

%% set up

% range of g
g_range = [1,2];

% const
tau = 20; % ms, time constant of each neuron
V_threshold = 20; % mV, voltage threshold of neuron firing
V_reset = 10; % mV, voltage of resting potential
tau_rp = 2; % ms, refraction period
D = 1.8; % ms, time delay for the transition of electrical signal
J = 0.5; % mV, connect strength of the synapse
t_max = 1000; % ms

% number of neurons
N = 1000; % number of all neurons
N_E = 0.8*N; % number of excitory neurons
N_I = 0.2*N; % number of inhibitory neurons

% connections of a neuron
epsilon = 0.1;
C_E = epsilon * N_E;
C_I = epsilon * N_I;
C_ext = C_E;

% 1~N_E are E neurons, N_E+1~N are I neurons
E_id = randi([1, N_E],[N,C_E]); % i_th row is the idx of E neuron connected to neuron i
I_id = randi([N_E+1, N],[N,C_I]); % i_th row is the idx of I neuron connected to neuron i

% speed of Poisson Process
nu_thr = (V_threshold - 0) / (J*C_E*tau); % 1/ms % I think this formula is wrong!
ratio_of_nu = 1; % 0 1 2
nu_ext = ratio_of_nu * nu_thr;

% init
mean_firing_rate = zeros(1,length(g_range));
count = 0;

%% loop to explore the effect of different g
for g = g_range

    % count
    count = count + 1;

    % set J
    J_ext = J;
    J_EE = J; % from E to E, positive
    J_IE = J; % from E to I, positive
    J_EI = -g*J; % from I to E, negative
    J_II = -g*J; % from I to I, negative

    Poisson_process_ext = cell(N, C_ext); % N*C_ext Poisson processes
    for i = 1:N
        for j = 1:C_ext
            Poisson_process_ext{i,j} = generate_Poisson_process(nu_ext,t_max);
        end
    end

    dt = 0.1; % ms
    t_all = 0:dt:t_max;
    V = zeros(N,length(t_all) - 1 + 2);
    flag_fire = zeros(N,length(t_all) - 1);

    % init
    for idx_t = 1:tau_rp/dt + 1
        V(:,idx_t) = V_reset;
    end

    for idx_t = tau_rp/dt + 1:length(t_all) - 1

        % loop to process E neurons
        for i = 1:N_E

            % reset dV
            dV = 0;

            % if a neuron is in its refractory period
            if sum(flag_fire(i,idx_t-tau_rp/dt:idx_t)) ~= 0
                V(i,idx_t+1) = V_reset;
                continue;
            end

            % loop to see how many ext neurons are firing at (t_all(idx_t)-D)
            for j = 1:C_ext
                if sum(Poisson_process_ext{i,j} == (t_all(idx_t)-D)) == 1
                    dV = dV + J_ext * 1;
                end
            end

            % loop to see how many E neurons are firing at (t_all(idx_t)-D)
            for j = 1:C_E
                if flag_fire(E_id(i,j),idx_t-D/dt) == 1 % E_id(i,j) represent all E neuron connected to neuron i
                    dV = dV + J_EE * 1;
                end
            end

            % loop to see how many I neurons are firing at (t_all(idx_t)-D)
            for j = 1:C_I
                if flag_fire(I_id(i,j),idx_t-D/dt) == 1
                    dV = dV + J_EI * 1;
                end
            end

            % calculate V(i,idx_t+1)
            V(i,idx_t+1) = (1 - dt/tau) * V(i,idx_t) + dV;

            % if fire
            if V(i,idx_t+1) > V_threshold
                flag_fire(i,idx_t + 1) = 1;
            end

        end

        % loop to process I neurons
        for i = N_E+1:N

            % reset dV
            dV = 0;

            % if a neuron is in its refractory period
            if sum(flag_fire(i,idx_t-tau_rp/dt:idx_t)) ~= 0
                V(i,idx_t+1) = V_reset;
                continue;
            end

            % loop to see how many ext neurons are firing at (t_all(idx_t)-D)
            for j = 1:C_ext
                if sum(Poisson_process_ext{i,j} == (t_all(idx_t)-D)) == 1
                    dV = dV + J_ext * 1;
                end
            end

            % loop to see how many E neurons are firing at (t_all(idx_t)-D)
            for j = 1:C_E
                if flag_fire(E_id(i,j),idx_t-D/dt) == 1
                    dV = dV + J_IE * 1;
                end
            end

            % loop to see how many I neurons are firing at (t_all(idx_t)-D)
            for j = 1:C_I
                if flag_fire(I_id(i,j),idx_t-D/dt) == 1
                    dV = dV + J_II * 1;
                end
            end

            % calculate V(i,idx_t+1)
            V(i,idx_t+1) = (1 - dt/tau) * V(i,idx_t) + dV;

            % if fire
            if V(i,idx_t+1) > V_threshold
                flag_fire(i,idx_t + 1) = 1;
            end

        end
    end

    firing_rate = sum(flag_fire,2)/(t_max*0.001);
    mean_firing_rate(count) = mean(firing_rate);


    %% imshow flag_fire

    % draw
    imagesc(flag_fire);
    colormap(bone);
    colorbar;

    % lim
    clim([0 1]);
    
    % label
    xlabel('t (ms)');
    xticks(0:length(flag_fire)/10:length(flag_fire));
    xticklabels( (0:length(flag_fire)/10:length(flag_fire)) / 10);
    ylabel('neuron ID');
    title(sprintf('fire moment; g = %0.1f',g));

    % save
    folder_path = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\spiking neural network\result\g';
    file_name = sprintf('fire moment; g = %.1f.png',g);
    save_and_close_v2(folder_path,file_name);

    %% imshow V

    % draw
    imagesc(V);
    colormap(parula);
    colorbar;

    % lim
    clim([10 20]);

    % label
    xlabel('t (ms)');
    xticks(0:length(flag_fire)/10:length(flag_fire)-1);
    xticklabels( (0:length(flag_fire)/10:length(flag_fire)-1) / 10);
    ylabel('neuron ID');
    title(sprintf('V; g = %0.1f',g));

    % save
    folder_path = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\spiking neural network\result\g';
    file_name = sprintf('V; g = %.1f.png',g);
    save_and_close_v2(folder_path,file_name);

end

%% plot

% % normal
% figure;
% plot(g_range,mean_firing_rate,'black-o');
% 
% xlabel('g');
% ylabel('mean firing rate');
% title('normal axis');
% legend(['ratio = ' num2str(ratio_of_nu)]);
% 
% % semilogy
% figure;
% semilogy(g_range,mean_firing_rate,'black-o');
% 
% xlabel('g');
% ylabel('mean firing rate');
% title('semilogy');
% legend(['ratio = ' num2str(ratio_of_nu)]);
% 
% % loglog
% figure;
% loglog(g_range,mean_firing_rate,'black-o');
% 
% xlabel('g');
% ylabel('mean firing rate');
% title('loglog');
% legend(['ratio = ' num2str(ratio_of_nu)]);

function save_and_close(folder_path,file_name,ext_str)
full_path = fullfile(folder_path,file_name);
saveas(gcf,full_path,ext_str);
close;
end

function save_and_close_v2(folder_path,file_name)
full_path = fullfile(folder_path,file_name);
saveas(gcf,full_path);
close;
end
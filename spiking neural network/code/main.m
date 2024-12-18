clc;clear;close all;

%% set up

% range of g
g_range = 0:5:15;

% const
tau = 20; % ms, time constant of each neuron
V_threshold = 20; % mV, voltage threshold of neuron firing
V_reset = 10; % mV, voltage of resting potential
tau_rp = 2; % ms, refraction period
D = 1.8; % ms, time delay for the transition of electrical signal
J = 0.2; % mV, synapse weight
J_ext = J; % from ext
J_from_E = J; % from E

% time
t_max = 1200; % ms
dt = 0.1; % ms
t_all = 0:dt:t_max;

% number of neurons
N_neuron = 1000; % number of all neurons
N_E = 0.8*N_neuron; % number of excitory neurons
N_I = 0.2*N_neuron; % number of inhibitory neurons

% connections of a neuron
epsilon = 0.1;
C_E = epsilon * N_E;
C_I = epsilon * N_I;
C_ext = C_E;

% 1~N_E are E neurons, N_E+1~N are I neurons
E_id = randi([1, N_E],[N_neuron,C_E]); % i_th row is the idx of E neuron connected to neuron i
I_id = randi([N_E+1, N_neuron],[N_neuron,C_I]); % i_th row is the idx of I neuron connected to neuron i

% speed of Poisson Process
nu_thr = (V_threshold - 0) / (J*C_E*tau); % 1/ms % I think this formula is wrong!
ratio_of_nu = 1; % 0 1 2
nu_ext = ratio_of_nu * nu_thr; % 1/ms

% init
mean_firing_rate = zeros(1,length(g_range));
count = 0;

%% loop to explore the effect of different g
for g = g_range

    %% init

    % the only difference of g
    J_from_I = -g*J; % from I

    % init
    V = zeros(N_neuron,length(t_all) - 1);
    is_fire_all = zeros(N_neuron,length(t_all) - 1);

    % count
    count = count + 1;

    %% generate Poisson process for ext neurons
    % Poisson_process_ext = generate_Poisson_process(nu_ext,t_max,N_neuron,C_ext);

    %% calculate V

    % set the first tau_rp period to V reset
    V(:,1:tau_rp/dt) = V_reset;
    V(:,tau_rp/dt + 1) = random('Uniform',10,20,N_neuron,1);

    % loop to process each time step
    for idx_t = tau_rp/dt + 1:length(t_all) - 1

        % loop to process E neurons
        for idx_neuron = 1:N_neuron

            % calculate dV
            [dV,is_fire_all,is_rp] = calculate_dV(idx_neuron,is_fire_all,E_id,I_id,J_from_E,J_from_I,idx_t,tau_rp,dt,t_all,D,C_ext,C_E,C_I,nu_ext);

            % if the neuron is still in the refractory period
            if is_rp
                V(idx_neuron,idx_t+1) = V_reset;
                continue;
            end

            % calculate V at the next time step
            V(idx_neuron,idx_t+1) = (1 - dt/tau) * V(idx_neuron,idx_t) + dV;

            % if fire
            if V(idx_neuron,idx_t+1) > V_threshold
                is_fire_all(idx_neuron,idx_t + 1) = 1;
            end

        end
    end

    firing_rate = sum(is_fire_all,2)/(t_max*0.001);
    mean_firing_rate(count) = mean(firing_rate);

    %% plot the heat map of fire moments

    % plot
    % is_fire_all_new = make_rp_as_firing(is_fire_all);
    heat_map_of_fire(is_fire_all,t_max,dt,g);
    set(gcf, 'Position', get(0, 'Screensize'));

    % save
    % folder_path = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\spiking neural network\result\temp';
    % if ~isfolder(folder_path)
    %     mkdir(folder_path)
    % end
    % file_name = sprintf('fire moment; g = %.1f.png',g);
    % save_and_not_close_v2(folder_path,file_name);
    % file_name = sprintf('fire moment; g = %.1f.fig',g);
    % save_and_not_close_v2(folder_path,file_name);

    % %% plot the heat map of V
    % 
    % % plot
    % heat_map_of_V(V,t_max,dt,g);
    % 
    % % save
    % folder_path = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\spiking neural network\result\temp';
    % file_name = sprintf('V; g = %.1f.png',g);
    % save_and_not_close_v2(folder_path,file_name);
    % file_name = sprintf('V; g = %.1f.fig',g);
    % save_and_close_v2(folder_path,file_name);

end
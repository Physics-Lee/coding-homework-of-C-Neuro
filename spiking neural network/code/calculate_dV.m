function [dV,V,flag_fire] = calculate_dV(idx_neuron,V,flag_fire,Poisson_process_ext,E_id,I_id,J_from_E,J_from_I)

% reset dV
dV = 0;

% if a neuron is in its refractory period
if sum(flag_fire(idx_neuron,idx_t-tau_rp/dt:idx_t)) ~= 0
    V(idx_neuron,idx_t+1) = V_reset;
    return;
end

% loop to see how many ext neurons are firing at (t_all(idx_t)-D)
for j = 1:C_ext
    if sum(Poisson_process_ext{idx_neuron,j} == (t_all(idx_t)-D)) == 1
        dV = dV + J_ext * 1;
    end
end

% loop to see how many E neurons are firing at (t_all(idx_t)-D)
for j = 1:C_E
    idx_neuron_connected = E_id(idx_neuron,j);
    if flag_fire(idx_neuron_connected,idx_t-D/dt) == 1 % E_id(i,j) represent all E neuron connected to neuron i
        dV = dV + J_EE * 1;
    end
end

% loop to see how many I neurons are firing at (t_all(idx_t)-D)
for j = 1:C_I
    idx_neuron_connected = I_id(idx_neuron,j);
    if flag_fire(idx_neuron_connected,idx_t-D/dt) == 1
        dV = dV + J_EI * 1;
    end
end

end
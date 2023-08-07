function [dV,is_fire_all,is_rp] = calculate_dV(idx_neuron,is_fire_all,Poisson_process_ext,E_id,I_id,J_from_E,J_from_I,idx_t,tau_rp,dt,t_all,D,C_ext,C_E,C_I)

% init
dV = 0;
dV_from_ext = 0;
dV_from_E = 0;
dV_from_I = 0;
is_rp = false;

% if a neuron is in its refractory period
if sum(is_fire_all(idx_neuron,idx_t-tau_rp/dt:idx_t)) ~= 0
    is_rp = true;
    return;
end

% see how many ext neurons are firing at (t_all(idx_t)-D)
firing_neurons = cellfun(@(x) sum(x == (t_all(idx_t) - D)) == 1, Poisson_process_ext(idx_neuron, :));
dV_from_ext = dV_from_ext + J_from_E * sum(firing_neurons);

% loop to see how many E neurons are firing at (t_all(idx_t)-D)
for j = 1:C_E
    idx_neuron_connected = E_id(idx_neuron,j);
    if is_fire_all(idx_neuron_connected,idx_t-D/dt) == 1 % E_id(i,j) represent all E neuron connected to neuron i
        dV_from_E = dV_from_E + J_from_E * 1;
    end
end

% loop to see how many I neurons are firing at (t_all(idx_t)-D)
for j = 1:C_I
    idx_neuron_connected = I_id(idx_neuron,j);
    if is_fire_all(idx_neuron_connected,idx_t-D/dt) == 1
        dV_from_I = dV_from_I + J_from_I * 1;
    end
end

dV = dV_from_ext + dV_from_E + dV_from_I;
if dV > 10
    why;
end

end
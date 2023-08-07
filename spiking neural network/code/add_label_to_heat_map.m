function add_label_to_heat_map(t_max,dt)
xlabel('t (ms)');
xticks(0:t_max/dt/10:t_max/dt);
xticklabels( (0:t_max/dt/10:t_max/dt) / 10);
ylabel('neuron ID');
end
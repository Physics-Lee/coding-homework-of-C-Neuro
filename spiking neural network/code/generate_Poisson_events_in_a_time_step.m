function n_fire = generate_Poisson_events_in_a_time_step(rate,dt,C_ext)
P_fire = rate * dt;
n_fire = sum(rand(1,C_ext) < P_fire);
end
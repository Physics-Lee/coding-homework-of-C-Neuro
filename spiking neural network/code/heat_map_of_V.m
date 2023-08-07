function heat_map_of_V(V,t_max,dt,g)

% draw
figure;
imagesc(V);
colormap(parula);

% lim
colorbar;
clim([10 20]);

% label
add_label_to_heat_map(t_max,dt)
title(sprintf('V; g = %0.1f',g));

end
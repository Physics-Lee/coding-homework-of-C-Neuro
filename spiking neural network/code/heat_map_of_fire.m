function heat_map_of_fire(is_fire_all,t_max,dt,g)

% draw
figure;
imagesc(is_fire_all);
colormap(bone);

% label
add_label_to_heat_map(t_max,dt)
title(sprintf('fire moment; g = %0.1f',g));

end
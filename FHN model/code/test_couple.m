function test_couple(y)

% Unpack variables
V_1 = y(:,1);
w_1 = y(:,2);
V_2 = y(:,3);
w_2 = y(:,4);

%
figure;
hold on;
axis equal;
xlabel('V');
ylabel('w');
title("red for neuron 1 and blue for neuron 2")

n_points_one_time = 100;
for i = 1:n_points_one_time:size(y,1) - n_points_one_time
    plot(V_1(i:i+n_points_one_time),w_1(i:i+n_points_one_time),'red');
    pause(0.2);
    plot(V_2(i:i+n_points_one_time),w_2(i:i+n_points_one_time),'blue');
    pause(0.5);
end

end
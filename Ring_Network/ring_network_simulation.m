function is_convergent = ring_network_simulation(J0_range, J1_range, activation_func)
% Parameters setup
N = 36;  % Number of neurons
theta = linspace(0, 2 * pi * (N-1) / N, N)';  % Neuron preferred angles (add 1 to include 2*pi)
I_0 = 1;  % Uniform external input
I_1 = 0;  % Feature-specific external input strength
theta_0 = pi;  % Center of external stimulus
max_iterations = 10^4;  % Maximum number of iterations
tolerance = 1e-4;  % Convergence threshold

% Initialize results matrix to record convergence
is_convergent = zeros(length(J0_range), length(J1_range));

% Outer loop for grid search over J_0 and J_1
for idx_J0 = 1:length(J0_range)
    for idx_J1 = 1:length(J1_range)
        % Current values of J_0 and J_1
        J_0 = J0_range(idx_J0);
        J_1 = J1_range(idx_J1);

        % Construct the weight matrix W
        W = zeros(N, N);
        for i = 1:N
            for j = 1:N
                W(i, j) = (J_0 + J_1 * cos(theta(i) - theta(j))) / N;
            end
        end

        % Compute the external input I
        I = I_0 + I_1 * cos(theta - theta_0);

        % Initialize the neuronal states u
        rng(100);
        % u = rand(N, 1);
        u = initializing_u(N, 'Cos');

        % Iteratively update the neuronal states
        converged = false;
        for iteration = 1:max_iterations
            u_prev = u;
            u_input = W * u + I;

            % Apply the chosen activation function
            u = apply_activation(u_input, activation_func);
            [~, max_index] = max(u);

            % Check for convergence
            if norm(u - u_prev) / N < tolerance && max_index == 19 && max(u) - min(u) > 1e0 %% the last 2 conds are for maintaining the bump
                converged = true;
                % plot_theta_u(theta, u)
                break;
            end
        end

        % Record the convergence result (1 for converged, 0 for not converged)
        is_convergent(idx_J0, idx_J1) = converged;
    end
end

% Display the convergence results as a heatmap
figure;
imagesc(J1_range, J0_range, is_convergent);
colormap(gray);
colorbar;
xlabel('J_1');
ylabel('J_0');
title(['Convergence Results for Different J_0 and J_1 Values with ', activation_func, ' Activation']);
set(gca, 'YDir', 'normal');  % Flip the Y-axis for better visualization

end
function u = initializing_u(N, init_method)
switch init_method
    case 'Uniform'
        u = rand(N, 1);
    case 'Gaussian'
        mu = 0;
        sigma = 0.1;
        u = mu + sigma * randn(N, 1);
    case 'Cos'
        theta = linspace(0, 2 * pi * (N-1) / N, N)';
        theta_0 = pi;
        u = 100 * (1 + 2 * cos(theta - theta_0));
        u = max(0, u);
    case 'Gaussian_v2'
        theta = linspace(0, 2 * pi * (N-1) / N, N)';
        theta_0 = pi / 2; % Center of the Gaussian in angle space
        sigma = pi / 10; % Adjust the spread of the Gaussian in radians
        % Wrap-around Gaussian using minimum distance in circular space
        u = 100 * exp(- 0.5 * (min(abs(theta - theta_0), 2 * pi - abs(theta - theta_0)) / sigma).^2);
    case 'Linear'
        u_min = 0; % Starting value of the linear gradient
        u_max = 50; % Ending value of the linear gradient
        u = linspace(u_min, u_max, N)'; % Linear spacing from u_min to u_max
    case "zeros"
        u = zeros(N, 1);
    case "ones"
        u = ones(N, 1);
end
end
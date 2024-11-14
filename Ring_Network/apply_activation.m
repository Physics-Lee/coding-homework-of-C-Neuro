function u_activated = apply_activation(u, activation_func)
% Helper function to apply the specified activation function
switch activation_func
    case 'ReLU'
        u_activated = max(0, u);
    case 'sigmoid'
        u_activated = 1 ./ (1 + exp(-u));
    case 'tanh'
        u_activated = tanh(u);
    case 'none'
        u_activated = u;  % No activation, output is same as input
    otherwise
        error('Unknown activation function. Choose ReLU, sigmoid, or tanh.');
end
end
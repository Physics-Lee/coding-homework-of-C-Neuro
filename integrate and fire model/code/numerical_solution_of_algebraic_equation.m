% Input: s for tau, tau_a.
%
% output: Hz for frequency.
%
% 2023-10-21, Yixuan Li
%

function f = numerical_solution_of_algebraic_equation(tau,tau_a,J_a,range_of_I_e)

% Initialize T solutions
T_solutions = zeros(size(range_of_I_e));

% Loop through each I_e value to solve for T
for i = 1:length(range_of_I_e)
    I_e = range_of_I_e(i);

    % Define the equation as an anonymous function
    eqn = @(T) -1 + I_e * (1 - exp(-T / tau)) ...
        + (-J_a) * (1 / (1 - exp(-T / tau_a))) * (tau_a / (tau_a - tau)) * (exp(-T / tau_a) - exp(-T / tau));

    % Initial guess for T
    T_initial_guess = 0.1; % s

    % Solve for T using fzero
    T_solution = fzero(eqn, T_initial_guess);

    % Store T solution
    T_solutions(i) = T_solution;
end

% calculate f
f = 1./T_solutions;

end
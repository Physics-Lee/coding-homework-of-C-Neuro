clc;clear;close all;

syms t tau
f = exp(-t); % Example function
g = sin(t);  % Another example function

f_sub = subs(f, t, tau);    % Substituting t with tau in f
g_sub = subs(g, t, t-tau);  % Substituting t with t-tau in g

conv_integral = int(f_sub * g_sub, tau, 0, Inf);
figure;
fplot(conv_integral, [0, 100]);

% conv_result = vpa(conv_integral);

%%
% Define the time vector
t = linspace(0, 100, 100000); % Adjust range and resolution as needed

% Evaluate the functions
f_t = exp(-t);   % Replace with your function
g_t = sin(t);    % Replace with your function

% Perform numerical convolution
conv_result = conv(f_t, g_t, 'same'); % 'same' keeps the size of the output same as input

% Plot the result
figure;
plot(t, conv_result);
xlabel('Time');
ylabel('Convolution Result');
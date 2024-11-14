clc; clear; close all;

% Define the range for J_0 and J_1
% J0_range = -30:+1:+5;
% J1_range = -5:+1:+30;

J0_range = -5:0.1:+2;
J1_range = -1:0.1:+6;

% J0_range = -23.68:-0.001:-23.71;
% J1_range = 32.06:+0.001:+32.09;

% J0_range = -10:1:10;
% J1_range = -10:1:10;

% For reproducing
% rng(100);

% Run with ReLU activation
is_convergent_ReLU = ring_network_simulation(J0_range, J1_range, 'ReLU');

% Run with ReLU activation
% is_convergent_none = ring_network_simulation(J0_range, J1_range, 'none');

% Run with sigmoid activation
% is_convergent_sigmoid = ring_network_simulation(J0_range, J1_range, 'sigmoid');

% Run with tanh activation
% is_convergent_tanh = ring_network_simulation(J0_range, J1_range, 'tanh');
% FitzHugh Nagumo model， ODEs from http://www.scholarpedia.org/article/FitzHugh-Nagumo_model
%
% Yixuan Li, 2024-01-25
%

clear;clc;close all;

%% parameters
I = 0;
a = -0.5;
b = 0.1;
c = 0.1;

%% use ode45 to solve ODEs

% paras
t_max = 1000;
t_range = [0,t_max];
y_0 = [0 0.1];

% y(1), y(2) stand for V, w
[t,y] = ode45(@(t, y) FitzHugh_Nagumo_model_v1(t, y, a, b, c, I),t_range,y_0);

%% plot

step = 0.1; % para
range = 2; % para
[V,w] = meshgrid(- range:step:range,-range:step:range); 
V_derivative = - V.^3 + (a+1).*V.^2 - a.*V - w + I;
w_derivative = b.*V - c.*w;

V_derivative_syms = @(V,w) - V.^3 + (a+1).*V.^2 - a.*V - w + I;
w_derivative_syms = @(V,w) b*V - c*w;

plot_FHN(t, y, y_0, V, w, V_derivative, w_derivative, V_derivative_syms, w_derivative_syms);

% stability of (0,0)
[tau, delta, discriminant, lambda_1, lambda_2, stability_str] = analyze_stability_of_fixed_point(a,b,c);
title(stability_str);
% FitzHugh Nagumo model， ODEs from http://www.scholarpedia.org/article/FitzHugh-Nagumo_model
%
% Yixuan Li, 2024-01-25
%

clear;clc;close all;

%% parameters
I = 0.5;
a = 1;
b = 1;
c = 1;

%% use ode45 to solve ODEs

% paras
t_max = 1000;
y_0 = [0 0];

% y(1), y(2) stand for V, w
FitzHugh_Nagumo_model_2 = @(t,y)...
    [-y(1).^3+(a+1).*y(1).^2-a.*y(1)-y(2)+I;...
    b.*y(1)-c.*y(2);];
range_of_t = [0,t_max];
[t,y] = ode45(FitzHugh_Nagumo_model_2,range_of_t,y_0);

%% plot

step = 0.1; % para
range = 2; % para
[V,w] = meshgrid(- range:step:range,-range:step:range); 
V_derivative = - V.^3 + (a+1).*V.^2 - a.*V - w + I;
w_derivative = b.*V - c.*w;

V_derivative_syms = @(V,w) - V.^3 + (a+1).*V.^2 - a.*V - w + I;
w_derivative_syms = @(V,w) b*V - c*w;

plot_FHN(t, y, V, w, V_derivative, w_derivative, V_derivative_syms, w_derivative_syms);

%% stability of the fixed point
[lambda_1,lambda_2] = analyze_stability_of_fixed_point(a,b,c);
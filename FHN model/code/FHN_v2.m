% FitzHugh Nagumo model， ODEs from https://en.wikipedia.org/wiki/FitzHugh-Nagumo_model
%
% Yixuan Li, 2024-01-25
%

clear;clc;close all;

%% parameters
I = 0.5;
a = 0;
b = 0;
tau = 12;

%% use ode45 to solve ODEs

% paras
t_max = 1000;
y_0 = [0 0];

% y(1), y(2) stand for V, w
FitzHugh_Nagumo_model_1 = @(t,y)...
    [-y(1).^3/3+y(1)-y(2)+I;...
    1./tau.*(+y(1)-b.*y(2)+a);];
range_of_t = [0,t_max];
[t,y] = ode45(FitzHugh_Nagumo_model_1,range_of_t,y_0);

%% V-t and w-t
figure(1)
plot(t,y(:,1),'blue');
hold on;
plot(t,y(:,2),'red');
xlabel('t');
ylabel('V or w');
legend('V','w');

%% plot

step = 0.1;
V_range = 2.5;
[V,w] = meshgrid(-V_range:step:V_range,-1:step:2);
V_derivative = -1/3*V.^3 + V - w + I;
w_derivative = 1/tau * (V + a - b*w);

V_derivative_syms = @(V,w) -1/3 * V^3 + V - w + I;
w_derivative_syms = @(V,w) 1/tau * ( V + a - b * w);

plot_FHN(t, y, V, w, V_derivative, w_derivative, V_derivative_syms, w_derivative_syms);
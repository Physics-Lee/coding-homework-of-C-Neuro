clear;clc;close all;

%% constant
I = 0.5; % I=0的时候，不能形成周期图像。
a = 0.7;
b = 0.7;
t_0 = 12;

%% use ode45 to solve ODEs
% 2-variable-1-order linear ODEs, y(1) y(2)分别代表V w
FitzHugh_Nagumo_model_1 = @(t,y)...
    [-y(1).^3/3+y(1)-y(2)+I;...
    1./t_0.*(+y(1)-b.*y(2)+a);];
range_of_t = [0,1000];
y_0 = [-0.2 -1]; % you can change y_0 to have a little fun
[t,y] = ode45(FitzHugh_Nagumo_model_1,range_of_t,y_0);

%% V-t and w-t
figure(1)
plot(t,y(:,1),'blue');
hold on;
plot(t,y(:,2),'red');
xlabel('t');
ylabel('V or w');
legend('V','w');

%% phase space
% draw V-w
figure(2)
plot(y(:,1),y(:,2),'black'); % below ranges all come from the size of the limit cycle
hold on;
axis equal;

% draw vector field
V_range = 2.5; % V_range comes from the size of limit cycle
step = 0.1; % empirical
[x_1,y_1] = meshgrid(-V_range:step:V_range,-1:step:2); % x_1代表V，y_1代表w
V_derivative = -1/3*x_1.^3 + x_1 - y_1 + I;
w_derivative = 1/t_0 * (x_1 + a - b*y_1);
quiver(x_1,y_1,V_derivative,w_derivative,'blue');e

% draw nullclines by ploting implicit function
V_derivative_syms = @(V,w) -1/3*V^3 + V - w + I;
w_derivative_syms = @(V,w) 1/t_0 * ( V + a - b * w);
fimplicit(V_derivative_syms,[-2.2 2.2],'green');
fimplicit(w_derivative_syms,[-1.5 2.0],'red');
xlabel('V');
ylabel('w');

% legend
legend('w-V，即二元一阶线性ODE组的解在相空间中的图像,在此情况下为limit cycle',...
    'vector filed，向量横坐标为dV/dt，向量纵坐标为dw/dt',...
    'V-nullcline，即dV/dt=0，即向量横坐标为0',...
    'w-nullcline，即dw/dt=0，即向量纵坐标为0');
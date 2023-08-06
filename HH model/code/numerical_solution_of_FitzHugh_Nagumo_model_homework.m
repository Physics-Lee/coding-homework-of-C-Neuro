clear;clc;close all;

%% constant
I = 0;
a = 1;
b = 0.01;
c = 0.01;
%% analysis
tau = - ( a + c );
delta = a * c + b;
parabola = tau^2 - 4 * delta;
lamda_1 = (tau + parabola^(1/2))/2;
lamda_2 = (tau - parabola^(1/2))/2;

%% use ode45 to solve ODEs
% 2-variable-1-order linear ODEs, y(1) y(2)分别代表V w
FitzHugh_Nagumo_model_2 = @(t,y)...
    [-y(1).^3+(a+1).*y(1).^2-a.*y(1)-y(2)+I;...
    b.*y(1)-c.*y(2);];
range_of_t = [0,1000];
y_0 = [1.5 10]; % you can change y_0 to have a little fun
[t,y] = ode45(FitzHugh_Nagumo_model_2,range_of_t,y_0);

% 画V-t图和w-t图
figure(1)
plot(t,y(:,1),'blue');
hold on;
plot(t,y(:,2),'red');
xlabel('t');
ylabel('V or w');
legend('V','w');

% draw V-w
figure(2)
plot(y(:,1),y(:,2),'black'); % below ranges all come from the size of the limit cycle
hold on;
axis equal;

% draw vector field
step = 0.1; % empirical
range = 5;
[x_1,y_1] = meshgrid(- range:step:range,-range:step:range); % x_1代表V，y_1代表w
V_derivative = - x_1.^3 + (a+1).*x_1.^2 - a.*x_1 - y_1 + I;
w_derivative = b.*x_1 - c.*y_1;
quiver(x_1,y_1,V_derivative,w_derivative,'blue');

% draw nullclines
V_derivative_syms = @(V,w) - V.^3 + (a+1).*V.^2 - a.*V - w + I;
w_derivative_syms = @(V,w) b*V - c*w;
range = 7;
fimplicit(V_derivative_syms,[-range range],'green');
fimplicit(w_derivative_syms,[-range range],'red');
xlabel('V');
ylabel('w');

% legend
legend('w-V，即二元一阶线性ODE组的解在相空间中的图像,在此情况下为limit cycle',...
    'vector filed，向量横坐标为dV/dt，向量纵坐标为dw/dt',...
    'V-nullcline，即dV/dt=0，即向量横坐标为0',...
    'w-nullcline，即dw/dt=0，即向量纵坐标为0');
function plot_FHN(t, y, x_1, y_1, V_derivative, w_derivative, V_derivative_syms, w_derivative_syms)

% plot V-t and w-t
figure;
plot(t,y(:,1),'blue');
hold on;
plot(t,y(:,2),'red');
xlabel('t');
ylabel('V or w');
legend('V','w');

% plot V-w
figure;
plot(y(:,1),y(:,2),'black');
hold on;
axis equal;

% draw vector field
quiver(x_1,y_1,V_derivative,w_derivative,'blue');

% draw nullclines
range = 7;
fimplicit(V_derivative_syms,[-range range],'green');
fimplicit(w_derivative_syms,[-range range],'red');
xlabel('V');
ylabel('w');

% legend
legend('phase trajectory of V-w',...
    '(dV/dt,dw/dt)',...
    'dV/dt=0',...
    'dw/dt=0');

end
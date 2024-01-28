function dydt = FitzHugh_Nagumo_model_v1(t, y, a, b, c, I)

% Unpack variables
V = y(1);
w = y(2);

% Define the system of differential equations
dVdt = V * (a - V) * (V - 1) - w + I;
dwdt = b * V - c * w;

% Pack variables
dydt = [dVdt; dwdt];

end
function dy_dt = FitzHugh_Nagumo_model_v1_coupled(t, y, a, b, c, I, g)

% Unpack variables
V_1 = y(1);
w_1 = y(2);
V_2 = y(3);
w_2 = y(4);

% Write differential equations
dV1_dt = V_1 * (a - V_1) * (V_1 - 1) - w_1 + I + g * (V_2 - V_1);
dw1_dt = b * V_1 - c * w_1;
dV2_dt = V_2 * (a - V_2) * (V_2 - 1) - w_2 + I + g * (V_1 - V_2);
dw2_dt = b * V_2 - c * w_2;

% Pack variables
dy_dt = [dV1_dt; dw1_dt; dV2_dt; dw2_dt];

end
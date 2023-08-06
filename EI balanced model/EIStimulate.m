function [t_all,v] = EIStimulate(u0, Je, Ji, ne, ni, N, sigma, dt, t, tau, I_0)

we = Je/sqrt(N); wi = Ji/sqrt(N);

t_all = 0:dt:t;
v = t_all*0;

for i = 1:length(t_all)-1
    
    ie = 0; ii = 0;
    
    for j = 1:N*ne
        ie = ie + ReLU(u0 + sigma/sqrt(dt) * randn(1));
    end
    ie = ie * we;
    
    for j = 1:N*ni
        ii = ii + ReLU(u0 + sigma/sqrt(dt) * randn(1));
    end
    ii = ii * wi;
    
    if v(i) >= 1
        v(i+1) = 0;
    else
        v(i+1) = v(i) + (ie - ii + I_0 - v(i)) * dt / tau;
    end
    
end

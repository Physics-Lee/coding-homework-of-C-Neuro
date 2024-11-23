function [t_all,v] = EEStimulate(u0, J0, N, sigma, dt, t_max, tau)

w = J0/N;
t_all = 0:dt:t_max;
v = t_all*0;

for i = 1:length(t_all) - 1
    
    ie = 0;
    
    for j = 1:N
        ie = ie + ReLU(u0 + sigma/sqrt(dt) * randn(1));
    end
    
    ie = ie * w;
    
    if v(i) >= 1
        v(i+1) = 0;
    else
        v(i+1) = v(i) + (ie - v(i)) * dt / tau;
    end
    
end

function y = sgn(x)
    y = sign(x);
    y(y == 0) = 1; % set sign of zero to 1
end
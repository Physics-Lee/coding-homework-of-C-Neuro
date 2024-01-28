% custom sign, where sgn(0) = 1.
%
% Yixuan Li, 2024-01-28
%

function y = sgn(x)

y = sign(x);
y(y == 0) = 1; % set sign of zero to 1

end
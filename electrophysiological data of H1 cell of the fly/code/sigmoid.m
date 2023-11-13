function y = sigmoid(x)

% Limit the range of x to prevent overflow
x = max(min(x, 700), -700);

% Compute the sigmoid function
y = 1 ./ (1 + exp(-x));

end
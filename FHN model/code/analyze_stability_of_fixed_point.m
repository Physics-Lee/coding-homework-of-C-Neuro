function [lambda_1,lambda_2] = analyze_stability_of_fixed_point(a,b,c)
tau = - ( a + c );
delta = a * c + b;
discriminant = tau^2 - 4 * delta;
lambda_1 = (tau + discriminant^(1/2))/2;
lambda_2 = (tau - discriminant^(1/2))/2;
end
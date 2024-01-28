function [tau, delta, discriminant, lambda_1, lambda_2, stability_str] = analyze_stability_of_fixed_point(a,b,c)

% calculate
tau = - ( a + c );
delta = a * c + b;
discriminant = tau^2 - 4 * delta;
lambda_1 = (tau + discriminant^(1/2))/2;
lambda_2 = (tau - discriminant^(1/2))/2;

% disp
fprintf('tau = %f\n', tau);
fprintf('delta = %f\n', delta);
fprintf('discriminant = %f\n', discriminant);
fprintf('lambda_1 = %f + %fi\n', real(lambda_1), imag(lambda_1));
fprintf('lambda_2 = %f + %fi\n', real(lambda_2), imag(lambda_2));

% decide
if delta < 0
    stability_str = "Saddle";
elseif delta > 0
    if tau > 0
        if discriminant > 0
            stability_str = "Direct Unstable";
        elseif discriminant < 0
            stability_str = "Spiral Unstable";
        end
    elseif tau < 0
        if discriminant > 0
            stability_str = "Direct Stable";
        elseif discriminant < 0
            stability_str = "Spiral Stable";
        end
    end
end

if ~exist('stability_str', 'var')
    stability_str = "Stability could not be determined";
end

disp(stability_str);

end
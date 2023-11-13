function result = RMSE(r_real,r_predict)

result = sqrt(sum((r_predict - r_real).^2) / length(r_real));

end
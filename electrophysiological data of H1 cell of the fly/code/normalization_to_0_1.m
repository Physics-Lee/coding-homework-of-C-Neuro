function y = normalization_to_0_1(x)

y = (x - min(x))./(max(x) - min(x));

end
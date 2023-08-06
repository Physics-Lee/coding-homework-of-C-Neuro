function xi_all_you_need = generate_Gaussian_white_noise_with_positive_correlation(xi_0_normalized,m,n,varience_of_xi,cov_of_2_xi)
mu = zeros(1,n);
cov_square = ones(n,n)*cov_of_2_xi + eye(n,n)*(varience_of_xi-cov_of_2_xi);
R = chol(cov_square);
xi_all_you_need = repmat(mu,m,1) + [xi_0_normalized randn(m,n-1)]*R;
end
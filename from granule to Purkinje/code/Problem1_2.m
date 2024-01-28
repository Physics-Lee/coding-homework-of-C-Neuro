N = 40;
M = 10;

for K=1:M

    % init
    P = 1;

    % loop to calculate
    for i=0:N-1
        P = P * (1 - i/nchoosek(M,K));
    end
    scatter(K,P)
    hold on
    P = 1;
end


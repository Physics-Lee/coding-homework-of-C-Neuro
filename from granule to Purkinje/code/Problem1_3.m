N = 40;
M = 10;

fid=fopen('1-3.txt','wt');

for K=1:4

    % init
    P = 1;

    % loop to calculate
    for i=0:N-1
        P=P*(1 - i/nchoosek(M,K) );
    end
    fprintf(fid,'K=%d P=%d\n',K,P);
end

fclose(fid);
function [Z,obj] = Z_ALM(G,E,C)
% solve:
% min     x'Ax - b'x
% s.t.    x'1 = 1, x >= 0
% paras:
% mu    - mu > 0
% beta  - 1 < beta < 2
%
NITER = 50;
THRESHOLD = 1e-5;
mu=0.1;
rho=1.1;

[n,m] = size(G);
sigma = ones(m,C);
Z1 = zeros(m,C);
P = initfcm(m,C);
cnt = 0;

for iter = 1:NITER
    V = G*P -E;
    for i = 1:m
        zz(i,:) = P(i,:) - (sigma(i,:)+V(i,:))/mu;
        Z1(i,:) =  EProjSimplex(zz(i,:));
    end
    Z = Z1;
    P = (-G'*Z+mu*Z+sigma)/mu;
%    P{iter}= P;
    sigma = sigma + mu*(Z - P);
    mu = rho*mu;
    obj(iter)=norm(Z - P,'fro').^2;%
    
    if obj(iter) < THRESHOLD
        if cnt >= 5
            break;
        else
            cnt = cnt + 1;
        end
    else
        cnt = 0;
    end    
end
end


function [result_FKM,sumtime_FKM,obj_FCM] = run_FKM(X,Y)
% X: n*d data matrix
% fcm clustering
tic
m = 1.2; %ģ��Ȩֵָ��
% double��Double precision array
%X = full(X);
%X =(double(X));
num = size(X,1);
%X = X-repmat(mean(X),[num,1]);
% if min(Y) == 0 
% Y = Y + 1;
% end
c = length(unique(Y));
[n,d] = size(X);
%% Initialize the  matrix U n*c U1=1,U>=0
U = rand(n,c);
U = U./repmat(sum(U,2),1,c);
r = 2/(m-1);
thresh = 10^-8;
ITER = 50;
obj_fcm = zeros(ITER,1);
fprintf('This is  FKM \n');
for iter = 1:ITER
    % kcm discrete
    Um = U.^m;
    V = Um'*X./repmat(sum(Um)',1,d);
    dist = L2_distance_11(X',V');
    U = 1./((dist.^r.*repmat(sum((1./dist).^r,2),1,c)));
    obj_fcm(iter) = sum(sum(U.^m.*dist));
    
    if iter>2
        obj_diff = abs(obj_fcm(iter-1)-obj_fcm(iter))/obj_fcm(iter-1);
        if obj_diff < thresh
            break;
        end
    end
end
obj_FCM = obj_fcm(iter);
[~,output] = max(U,[],2);
result_FKM = ClusteringMeasure_new(Y,output);
sumtime_FKM = toc;
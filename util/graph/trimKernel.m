function [w]=trimKernel(K,opts)
% 
% A - n by d data matrix
% 


% A = A';
[n] = size(K, 1);
s = opts.kNN;
w = zeros(n, n);

val = zeros(n,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = max(K,[],2);
    tep = (pos(:,i)-1)*n+[1:n]';
    K(tep) = 1e-60;
end
ind = (pos-1)*n+repmat([1:n]',1,s);

w([ind]) = [val];
w = sparse(w);

w = (w+w')/2;
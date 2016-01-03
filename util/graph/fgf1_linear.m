function [w]=fgf1_linear(A,opts)
% 
% A - n by d data matrix
% 

sigma = optSigma(A);
options.KernelType = 'Linear';
options.t = sigma; % width parameter for Gaussian kernel

% A = A';
[n d] = size(A);
s = opts.kNN;
w = zeros(n, n);

Sim = constructKernel(A,A,options);
val = zeros(n,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = max(Sim,[],2);
    tep = (pos(:,i)-1)*n+[1:n]';
    Sim(tep) = 1e-60;
end
ind = (pos-1)*n+repmat([1:n]',1,s);

w([ind]) = [val];
w = sparse(w);

w = (w+w')/2;
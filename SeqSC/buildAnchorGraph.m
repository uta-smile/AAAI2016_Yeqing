function [Z, feaSum] = buildAnchorGraph(data, marks, opts)

nSmp = size(data, 1);
r = opts.r;
p = opts.p;

% Z construction
D = EuDist2(data,marks,0);

if isfield(opts,'sigma')
    sigma = opts.sigma;
else
    sigma = mean(mean(D));
end

dump = zeros(nSmp, r);
idx = dump;
for i = 1:r
    [dump(:,i),idx(:,i)] = min(D,[],2);
    temp = (idx(:,i)-1)*nSmp+[1:nSmp]';
    D(temp) = 1e100; 
end

dump = exp(-dump/(2*sigma^2));
sumD = sum(dump,2);
Gsdx = bsxfun(@rdivide,dump,sumD);
Gidx = repmat([1:nSmp]',1,r);
Gjdx = idx;
Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),nSmp,p);

% Graph decomposition
feaSum = full(sqrt(sum(Z,1)));
feaSum = max(feaSum, 1e-12);
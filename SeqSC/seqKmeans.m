function [centers, asgn] = seqKmeans(centers, asgn, data)

centers = centers';
data = data';
% centers d by k
% asgn k by 1
% data d by n

n = size(data, 2);
asgn = double(asgn);

bb = sum(centers.^2,1); % 1 by k

for i = 1:n,
    X = data(:, i); % d by 1
    ab = X'*centers; % 1 by k
    D = bb - 2*ab; % 1 by k
    [val,label] = min(D,[],2); % assign samples to the nearest centers
    asgn(label) = asgn(label) + 1;
    eta = 1/asgn(label);
    centers(:, label) = (1-eta)*centers(:, label) + eta*X;
    bb(label) = sum(centers(:, label).^2);
end

centers = centers';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Z] = AnchorGraph(X, Anchor, s)
%
% function [Z] = AnchorGraph(X, Anchor, s)
% 
% Written by Wei Liu (wliu@ee.columbia.edu)
% Input:
% X = nXdim input data 
% Anchor = mXdim anchor points (m<<n)
% s = number of nearest anchors
% Output:
% Z = Anchor graph
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n,dim] = size(X);
m = size(Anchor,1);


%% get Z
Z = zeros(n,m);
Dis = sqdist(X',Anchor');
clear X;
clear Anchor;

val = zeros(n,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = min(Dis,[],2);
    tep = (pos(:,i)-1)*n+[1:n]';
    Dis(tep) = 1e60; 
end
clear Dis;
clear tep;

sigma = mean(val(:,s).^0.5);
val = exp(-val/(1/1*sigma^2));
val = repmat(sum(val,2).^-1,1,s).*val; %% normalize
tep = (pos-1)*n+repmat([1:n]',1,s);
Z([tep]) = [val];
Z = sparse(Z);
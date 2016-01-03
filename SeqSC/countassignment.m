function [asgn] = countassignment(IDX, nCenter)

asgn = zeros(nCenter, 1);
for i = 1:nCenter,
    asgn(i) = (sum(IDX == i));
end
asgn = int32(asgn);
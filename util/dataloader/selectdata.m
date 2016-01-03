function [data] = selectdata(files, meta, subIdx)

npb = meta.npb;
% nb = length(files);
nSmp = meta.n;

mask = false(nSmp, 1);
mask(subIdx) = true;

% nSubSmp = length(subIdx);
% data = zeros(nSubSmp, meta.d);

k = 1; 
for i = 1:length(files),
    start = (i-1)*npb+1;
    stop = min((i)*npb, nSmp);
    nIns = sum(mask(start:stop));
    if nIns > 0,
        raw = load(files{i});
        if k == 1,
            % initialization, for 
            data = raw.data(mask(start:stop), :);
        else
            data(k:k+nIns-1, :) = raw.data(mask(start:stop), :);
        end
        k = k + nIns;
    end
end


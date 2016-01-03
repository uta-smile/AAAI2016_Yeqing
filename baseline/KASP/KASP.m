function [labels, runtime] = KASP(data, nc, options)


if ~exist('options', 'dir'),
    options = struct;
end

if ~isfield(options, 'dbname'),
    options.dbname = 'unknown';
end

if ~isfield(options, 'num_centroids'),
    options.num_centroids = 500;
end

if ~isfield(options, 'kNN'),
    options.kNN = 50;
end

runtime = [];

% Step 1: run k-means to get small susbets
ticID = tic;
[NNlabels, centroids] = litekmeans(data, options.num_centroids, 'MaxIter', 200, 'Replicates', 20);
runtime(end+1) = toc(ticID);

% Step 2: Run spectral clustering on centroids
[cen_labels, scruntime] = funcSC(centroids, nc, options);
runtime = [runtime, scruntime];

% Step 3: Recover labels
ticID = tic;
labels = cen_labels(NNlabels);
runtime(end+1) = toc(ticID);
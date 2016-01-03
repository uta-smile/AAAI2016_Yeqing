function [labels, runtime] = funcESCG(data, options)
% 
% function [labels, runtime] = funcESCG(data, options)
% 
% data: n*d feature matrix
% nc: cluster number
% 
% Labels: n*1 label vector
% 

runtime = [];

if ~isfield(options, 'kNN'),
    options.kNN = 50;
end

dbname = options.dbname;

simpath = 'sim';
if ~exist(simpath, 'dir'),
    mkdir(simpath);
end
fn = sprintf('%s_%dNN_int%d_sim.mat', dbname, options.kNN, options.int);
fn = fullfile(simpath, fn);

if ~exist(fn, 'file'),
    ticID = tic;
    opts.kNN = options.kNN;
    opts.kNNdelta = opts.kNN;
    opts.alpha = 1;
    opts.quiet = 1;

    fprintf('building weights ... \n');

    %if ~issparse(data),
    %    [W]=fgf1(data,opts);
        [W] = gen_nn_gaussian_sim(data, opts.kNN, 500);
    %else
    %    [W]=fgf1_linear(data,opts);
    %end


    runtime(end+1) = toc(ticID);
    save(fn, 'W', 'runtime');
else
    fprintf('loading weights ... \n');
    load(fn);
end


fprintf('Clustering ... \n');
ticID = tic;
if strcmp(options.algo, 'ESCG'),
    embed = escg(W, options);
else
    embed = escg(W, options);
    
    % t: number of iterations for ESCG-R
    niter = 10;
    
    for i=2:niter
        options.embed = embed;
        embed = escg(W, options);
    end
end
runtime(end+1) = toc(ticID);

% run kmeans to get preditions
ticID = tic;
labels = litekmeans(embed, options.k, 'MaxIter', 200, 'Replicates', 20);
runtime(end+1) = toc(ticID);


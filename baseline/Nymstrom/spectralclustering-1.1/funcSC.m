function [labels, runtime] = funcSC(data, nc, options)
% 
% function [labels, runtime] = funcSC(data, nc, options)
% 
% data: n*d feature matrix
% nc: cluster number
% 
% Labels: n*1 label vector
% 

if ~exist('options', 'var'),
    options = struct;
end

if ~isfield(options, 'dbname'),
    options.dbname = 'unknown';
end

if ~isfield(options, 'kNN'),
    options.kNN = 50;
end

runtime = [];

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
        %[W]=fgf1(data,opts);
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
[labels, evd_time, kmeans_time, total_time] = sc(W, 0, nc, false);
runtime(end+1) = evd_time;
runtime(end+1) = kmeans_time;
runtime(end+1) = total_time;



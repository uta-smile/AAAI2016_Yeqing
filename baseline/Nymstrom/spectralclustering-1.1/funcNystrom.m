function [labels, runtime] = funcNystrom(data, nc, options)
% 
% function [labels, runtime] = funcSC(data, nc, options)
% 
% data: n*d feature matrix
% nc: cluster number
% 
% Labels: n*1 label vector
% 

if ~exist('options', 'dir'),
    options = struct;
end

if ~isfield(options, 'dbname'),
    options.dbname = 'unknown';
end

if ~isfield(options, 'num_samples'),
    options.num_samples = 200;
end

runtime = [];

fprintf('Clustering ... \n');
ticID = tic;
sigma = optSigma(data);
runtime(end+1) = toc(ticID);
[labels, evd_time, kmeans_time, total_time] = nystrom(data, options.num_samples, sigma, nc);
runtime(end+1) = evd_time;
runtime(end+1) = kmeans_time;
runtime(end+1) = total_time;



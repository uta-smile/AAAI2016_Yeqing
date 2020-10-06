function [data, labels, K] = load_ILSVRC2013(numClass, numPerClass)

datapath = 'L:\Users\yeqingli\UTA\Projects\Clustering\datasets\ImageNet(ILSVRC2013)\allfeat';

load(fullfile(datapath, 'solution.mat'));

labels = solution;
cls = unique(labels);
K = length(cls);

data = {};
% feat = {'decafCentre', 'gistPadding', 'lbp', 'line_hists', 'sparse_sift', ...
%         'geo_map8x8', 'hog2x2', 'lbphf', 'ssim'};
% feat = {...%'decafCentre', 'gistPadding', 'lbp', 'line_hists', ...
%         'geo_map8x8', 'hog2x2', 'lbphf', 'ssim'};
feat = {'gistPadding', 'lbp', 'line_hists', 'sparse_sift', ...
        'geo_map8x8', 'hog2x2', 'lbphf', 'ssim'};
for i = 1:length(feat),
    fn = sprintf('%s.mat', feat{i});
    fn = fullfile(datapath, fn);
    t = load(fn);    
    data{i} = t.data;
end

if numPerClass > 0,
    % Count number of data points in each class
    cnt = [];
    for i = 1:K,
        cnt(i) = sum(labels == cls(i));
    end
    
    % Find top k classes
    retcls = [];
    for i = 1:numClass,
        [~, retcls(i)] = max(cnt);
        cnt(retcls(i)) = 0;
    end
    
    % Select subsets
    allidx = [];
    for i=1:length(retcls),
        t = (labels == retcls(i));
        tidx = find(t, numPerClass);
        allidx = [allidx tidx];
    end
    
    labels = repmat(1:numClass, [numPerClass, 1]); labels = labels(:); 
    K = length(unique(labels));
    for i=1:length(data),
        data{i} = data{i}(allidx, :);
    end
end


function [labels] = loadlabels(files)

labels = [];
for i = 1:length(files),
    d = load(files{i}, 'labels');
    labels = [labels; d.labels];
end
% 
% Split the MNIST dataset into blocks and intervals. 
% 

outdir = 'MNIST';

if ~exist(outdir, 'dir'),
    mkdir(outdir);
end

raw = load('MNIST_pxl.mat');

n = length(raw.labels);

p = randperm(n);

npb = 5000; % #data per block
nblock = ceil(n/npb);

for i = 1:nblock,
    fprintf('block %d\n', i);
    start = (i-1)*npb+1;
    stop = min(i*npb, n);
    data = raw.data(p(start:stop), :);
    labels = raw.labels(p(start:stop));
    fn = fullfile(outdir, sprintf('MNIST_block%i.mat', i));
    save(fn, 'data', 'labels');
end


for i = 1:nblock,
    fprintf('Interval %d\n', i);
    start = (i-1)*npb+1;
    stop = min(i*npb, n);
    data = raw.data(p(1:stop), :);
    labels = raw.labels(p(1:stop));
    fn = fullfile(outdir, sprintf('MNIST_int%i.mat', i));
    save(fn, 'data', 'labels');
end

fn = fullfile(outdir, 'MNIST_meta');
save(fn, 'npb', 'n', 'nblock');


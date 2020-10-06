function [files, fmeta] = load_MNIST_files(datatype)
% 
% function [files, fmeta] = load_MNIST_files(datatype)
% Input:
%   datatype - 'block' or 'int'
% Output:
%   files - cell array of data file names
%   fmeta - string of meta data file name 
% 

switch datatype
    case 'block'
        fmt = 'MNIST_block%i.mat';
    case 'int'
        fmt = 'MNIST_int%i.mat';
    otherwise
        error('Unknown types');
end

nblock = 14;
files = cell(1, nblock);
for i = 1:nblock
    files{i} = sprintf(fmt, i);
end
fmeta = 'MNIST_meta.mat';
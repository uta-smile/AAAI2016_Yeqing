function [files, fmeta] = load_MNIST8m_files(datatype)
% 
% function [files, fmeta] = load_MNIST8m_files(datatype)
% Input:
%   datatype - 'block' or 'int'
% Output:
%   files - cell array of data file names
%   fmeta - string of meta data file name 
% 

dbname = 'mnist8m';

switch datatype
    case 'block'
        fmt = '%s_block%i.mat';
    case 'int'
        fmt = '%s_int%i.mat';
    otherwise
        error('Unknown types');
end

nblock = 100;
files = cell(1, nblock);
for i = 1:nblock
    files{i} = sprintf(fmt, dbname, i);
end
fmeta = sprintf('%s_meta.mat', dbname);
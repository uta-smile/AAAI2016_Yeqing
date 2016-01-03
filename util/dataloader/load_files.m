function [files, fmeta, dbname] = load_files(dbID, datatype)

switch dbID
    case 1
        [files, fmeta] = load_MNIST_files(datatype);
        dbname = 'MNIST';
    case 2
        [files, fmeta] = load_RCV1_files(datatype);
        dbname = 'RCV1';
    case 3
        [files, fmeta] = load_MNIST8m_files(datatype);
        dbname = 'MNIST8m';
%===================================================================
    otherwise
        error('Invalid DB ID');
end
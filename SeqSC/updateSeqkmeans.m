function [centers, asgn] = updateSeqkmeans(centers, asgn, files, fld)

for i = 1:length(files),
    t = load(files{i}, fld);
    [centers, asgn] = seqKmeans(centers, asgn, t.(fld));
end







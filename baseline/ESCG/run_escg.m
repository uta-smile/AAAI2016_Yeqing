clear options
% d: number of supernodes
options.d = 50;
% k: number of clusters
% options.k = 3;
options.k = 18;
% W: adjacency matrix
embed = escg(W, options);

% run kmeans to get preditions
pred = litekmeans(embed, options.k, 'MaxIter', 200, 'Replicates', 20);



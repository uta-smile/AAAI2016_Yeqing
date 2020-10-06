function sigma = optSigma(X)
    N = size(X,1);
    if N <= 5000,
        dist = EuDist2(X,X); 
    else
        subidx = randperm(N, 5000);
        Xsub = X(subidx, :);
        dist = EuDist2(Xsub, Xsub);
        N = 5000;
    end
    dist = reshape(dist,1,N*N);
    sigma = median(dist);
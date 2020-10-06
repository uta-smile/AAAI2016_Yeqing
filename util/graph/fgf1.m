function [w]=fgf1(A,opts,NNIdxs)

%w=fgf(A,opts,NNIdxs)
%implementation of self-tuning 
%weight matrix construction
%using the tstools nearest neighbor searcher
%opts.kNN is the number of neighbors
%opts.alpha is a universal scaling factor
%opts.kNNdelta specifies which nearest neighbor determines the local scale
%w is forced to be symmetric by averaging with its adjoint.
%if NNIdxs is specified, uses these instead of nnn-search.
%NNIdxs should be N x opts.kNN




[N dim]=size(A);

if isfield(opts,'quiet')
    if opts.quiet==1
        quiet=1;
    else
        quiet=0;
    end
else
    quiet=0;
end

if isfield(opts,'single');
    singlesingle=1;
else
    singlesingle=0;
end



if isfield(opts,'NNcoordinates')
    if length(opts.NNcoordinates)>0
        NNcoordinates=opts.NNcoordinates;
        coarse=1;
    else
        coarse=0;
        NNcoordinates=[1:dim];
    end
else
    coarse=0;
    NNcoordinates=[1:dim];
end


if nargin==2
    atria=nn_prepare(A(:,NNcoordinates));
    NNIdxs=zeros(N,opts.kNN); 
    NNDist=zeros(N,opts.kNN);
    ccount=1;
    if quiet==0,
        ceil(N/2000)
    end
    for zz=1:ceil(N/2000)
        if ccount+2000>N;
        cdiff=N-ccount;
        ccount=N;
        else
            cdiff=2000;
            ccount=ccount+2000;
        end
        if quiet==0
            zz
        end
        [NNIdxs(ccount-cdiff:ccount,:) NNDist(ccount-cdiff:ccount,:)]=nn_search(A(:,NNcoordinates),atria,A(ccount-cdiff:ccount,NNcoordinates),opts.kNN);
    end                               

    if coarse==1
        for k=1:N
            for j=1:opts.kNN
                NNDist(k,j)=norm(A(k,:)-A(NNIdxs(k,j),:));
            end
        end
    end
else
    sws=size(NNIdxs,2);%search window size

    NNDist=zeros(N,sws);
    for k=1:N
        if quiet==0
           if mod(k,2000)==1
               k
           end
        end
        for j=1:sws
            NNDist(k,j)=norm(A(k,:)-A(NNIdxs(k,j),:));
        end
    end
    if opts.kNN<sws
        
        [ju juu]=sort(NNDist,2);
        for s=1:N
            NNDist(s,1:opts.kNN)=NNDist(s,juu(s,1:opts.kNN));
            NNIdxs(s,1:opts.kNN)=NNIdxs(s,juu(s,1:opts.kNN));
        end
        NNDist=NNDist(:,1:opts.kNN);
        NNIdxs=NNIdxs(:,1:opts.kNN);
    end   
end


if opts.kNNdelta>0
    if opts.kNNdelta>opts.kNN
        sigma=ones(size(NNDist,1),1)';
    else
        sigma=NNDist(:,opts.kNNdelta)';
    end
else
    sigma=inf(size(NNDist,1),1)';
end



sigma = mean(sigma);
sigma_sqr = sigma^2;
sigma_sqr = 3*sigma^2; % 12%


% sigma_sqr = 1;
% sigma_sqr = 0.5; % 12%
% sigma_sqr = 0.25;
% sigma_sqr = 1.5;


% disp(sigma_sqr);
sigma = sqrt(sigma_sqr);


% pause(2)


idx=1;idxi=[];idxj=[];idxi(opts.kNN*N) = int16(0);idxj(opts.kNN*N) = int16(0);entries=zeros(1,opts.kNN*N);
for lk = 1:N
    idxi(idx:idx+opts.kNN-1)=lk;
    idxj(idx:idx+opts.kNN-1)=NNIdxs(lk,:);
    
    % exponential function
    entries(idx:idx+opts.kNN-1)= exp(-(NNDist(lk,:).^2)./(opts.alpha*sigma^2));
    
    idx=idx+opts.kNN;
end



w=sparse(idxi,idxj,entries,N,N);
if singlesingle==1
    w=single(w);
end

w=(w+w')/2;
% w=max(w, w');


end

        


function runESCG

dbstop if error
addpath(genpath('.'))

for dbID = 1
    [files, fmeta, dbname] = load_files(dbID, 'int');
    meta = load(fmeta);
    truth = loadlabels(files);

    nc = length(unique(truth));

    outpath = 'output';
    if ~exist(outpath, 'dir'),
        mkdir(outpath);
    end

    % d: number of supernodes
    % options.d = 30; % MNIST
    options.d = 200; % RCV1 
    % k: number of clusters
    options.k = nc;
    options.dbname = dbname;
    options.algo = 'ESCG';
    % options.algo = 'ESCG_r';
    options.kNN = 50; 

    %===================================================================
    % Experiment
    %***** Bipartite clustering compute all results
    [mFBase mP mR mNMI mRI mPrt mAC mTime] = deal([]);
    mRuntime = {};
    maxiter = 1; 
    for j = 1:length(files),  % enumerate number of blocks 
        load(files{j}, 'data', 'labels');
        gnd = labels;
        if min(gnd) ==0, gnd = gnd + 1; end
        for i = 1:maxiter,
            i
            tidID = tic;
            options.int = j;
            [res, runtime] = funcESCG(data, options);
            if min(res) ==0, res = res + 1; end
            elapseTime = toc(tidID)
            runtime
            %figure(2); plot(obj); title('Objective function values (BiSC)')
            res = bestMap(gnd,res);
            AC = length(find(gnd == res))/length(gnd)
            MIhat = MutualInfo(gnd,res)
            [purityprt] = purity(res, gnd , nc)
            %[mynmi] = nmi(gnd, res)
            [~, mynmi] = compute_nmi(gnd, res)
            [ARI]=RandIndex(gnd,res)
            [Fmeasure,Precision, Recall] = compute_f(res, gnd)

            [mFBase(j, i) mP(j, i) mR(j, i) mNMI(j, i)...
                mRI(j, i) mPrt(j, i) mAC(j, i) mTime(j, i), mRuntime{j}(i, :)] = ...
            deal(Fmeasure,Precision, Recall, mynmi, ARI, purityprt, AC, elapseTime, runtime);
        end

        fn = fullfile(outpath, sprintf('ESCG_%s.mat', dbname));
        save(fn, 'mFBase', 'mP', 'mR', 'mNMI', 'mRI', 'mPrt', 'mAC', 'mTime', 'mRuntime');
    end

end


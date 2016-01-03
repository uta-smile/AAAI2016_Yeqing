function runSeqSC

dbstop if error
addpath(genpath('.'))

for dbID = 1
    [files, fmeta, dbname] = load_files(dbID, 'block');
    meta = load(fmeta);
    truth = loadlabels(files);

    nc = length(unique(truth));

    outpath = 'output';
    if ~exist(outpath, 'dir'),
        mkdir(outpath);
    end

    opts.p = 200;
    % opts.p = 400;
    opts.r = 5;
    opts.kmMaxIter = 30;
    opts.kmNumRep = 5;
    opts.maxWghtIter = 50;
    opts.nSubSmp = opts.p*20;
    opts.thresh = 1e-6;
    opts.kertype = 'Gaussian';
    % opts.kertype = 'Linear'; % for long feature
    opts.useSeqKM = true;
    opts.useSeqKMLabel = true;
    % opts.mode = 'kmeans';
    opts.mode = 'random';

    % rand('twister',5489) 

    %===================================================================
    % Experiment
    %***** Bipartite clustering compute all results
    [mFBase mP mR mNMI mRI mPrt mAC mTime] = deal([]);
    maxiter = 1; 
    if min(truth) ==0, truth = truth + 1; end
    % for j = 1  % enumerate number of blocks 
    for j = 1:3:length(files)  % enumerate number of blocks 
        stop = min(meta.npb*j, length(truth));
        gnd = truth(1:stop);
        fprintf('====== SeqSC on %d blocks =======\n', j);
        for i = 1:maxiter,
            i
            tidID = tic;
            [res, markslbl, marks, runtime] = SeqSC(files(1:j), nc, meta, opts);
            runtime
            if min(res) ==0, res = res + 1; end
            elapseTime = toc(tidID)
            %figure(2); plot(obj); title('Objective function values (BiSC)')
            res = bestMap(gnd,res);
            AC = length(find(gnd == res))/length(gnd)
            MIhat = MutualInfo(gnd,res)
            [purityprt] = purity(res, gnd , nc)
            %[mynmi] = nmi(gnd, res)
            [~, mynmi] = compute_nmi(gnd, res)
            [ARI]=RandIndex(gnd,res)
            %[Fmeasure,Precision, Recall] = compute_f(res, gnd)
            [Fmeasure,Precision, Recall] = deal(0,0,0);

            [mFBase(j, i) mP(j, i) mR(j, i) mNMI(j, i)...
                mRI(j, i) mPrt(j, i) mAC(j, i) mTime(j, i)] = ...
            deal(Fmeasure,Precision, Recall, mynmi, ARI, purityprt, AC, elapseTime);
        end

        fn = fullfile(outpath, sprintf('SeqSC_%s_%s.mat', opts.mode, dbname));
        save(fn, 'mFBase', 'mP', 'mR', 'mNMI', 'mRI', 'mPrt', 'mAC', 'mTime');
    end

end


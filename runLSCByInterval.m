function runLSCByInterval

dbstop if error
addpath(genpath('.'))

for dbID = 1
    [files, fmeta, dbname] = load_files(dbID, 'int');
    truth = loadlabels(files(1:3));

    nc = length(unique(truth));

    outpath = 'output';
    if ~exist(outpath, 'dir'),
        mkdir(outpath);
    end

    % data = double(T{4}(1:3:end, :));
    % gnd = gnd(1:3:end);
    % clear T

    opts.p = 200;
    % opts.p = 400;
    opts.r = 5;
    opts.kmNumRep = 5;
    opts.kmMaxIter = 30;
    opts.maxWghtIter = 50;
    opts.thresh = 1e-6;
    opts.kertype = 'Gaussian';
    % if dbID == 2,
    %     opts.kertype = 'Linear';
    % end
    % rand('twister',5489) 


    disp(['===================== ' dbname ' ========================']);
    %===================================================================
    % Experiment
    %***** Bipartite clustering compute all results
    [mFBase mP mR mNMI mRI mPrt mAC mTime] = deal([]);
    maxiter = 5; 
    for j = 1:length(files),  % enumerate number of blocks 
        load(files{j}, 'data', 'labels');
        gnd = labels;
        if min(gnd) ==0, gnd = gnd + 1; end
        for i = 1:maxiter,
            i
            tidID = tic;
            [res] = LSC(data, nc, opts);
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
            [Fmeasure,Precision, Recall] = compute_f(res, gnd)

            [mFBase(j, i) mP(j, i) mR(j, i) mNMI(j, i)...
                mRI(j, i) mPrt(j, i) mAC(j, i) mTime(j, i)] = ...
            deal(Fmeasure,Precision, Recall, mynmi, ARI, purityprt, AC, elapseTime);
        end

        fn = fullfile(outpath, sprintf('LSC_%s.mat', dbname));
        save(fn, 'mFBase', 'mP', 'mR', 'mNMI', 'mRI', 'mPrt', 'mAC', 'mTime');
    end

end


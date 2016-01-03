
close all

linestyles = cellstr(char('-',':','-.','--','-',':','-.','--','-',':','-',':',...
'-.','--','-',':','-.','--','-',':','-.'));

n = length(linestyles);
MarkerEdgeColors=hsv(n); % n is the number of different items you have
Markers=['o','x','+','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'];

% [...]

for i=1:n
    styles{i} = [linestyles{i} Markers(i)];
    % 'Color',MarkerEdgeColors(i,:);
end

algo = {'LSC', 'ESCG', 'SeqSC_random', 'KASP', 'Nystrom'};
% algo = {'SeqSC_random', 'SeqSC_kmeans_RR', 'SeqSC_kmeans_SR', 'SeqSC_kmeans_RS', 'SeqSC_kmeans_SS'};
dbs = {'MNIST'};
% dbs = {'MNIST8m'};
% dbs = {'RCV1'};

% flds = {'mAC','mFBase','mNMI','mP','mPrt','mR','mRI','mTime'};
flds = {'mAC', 'mNMI','mPrt','mRI','mFBase','mTime'};

outpath = 'output';

for i = 1:length(dbs),
    disp([dbs{i} '================================']);
    for j = 1:length(algo),
        %disp([algo{j} '-------------------------']);
        fn = fullfile(outpath, sprintf('%s_%s.mat', algo{j}, dbs{i}));
        if ~exist(fn, 'file'), continue; end
        t = load(fn);
        ret = [];
        disp([algo{j} flds]);
        %fprintf([algo{j} '\t']);
        ret = 1:size(t.(flds{1}), 1);
        ret = ret(:);
        for k = 1:length(flds)-1,
            ret = [ret mean(t.(flds{k}),2)];
            %fprintf('%.4f\t', mean(t.(flds{k}),2));
            
            figure(i*100+k); hold on; title(flds{k})
            plot(ret(:, 1), ret(:, end), styles{j}, 'Color',MarkerEdgeColors(j,:));
            ylim([0 1]);
            legend(algo);
        end
        disp(ret)
        fprintf('%.2f\n', mean(t.mTime,2))
        ret = [ret mean(t.mTime,2)];
        figure(i*100+size(ret, 2)); hold on; title('Running time')
        plot(ret(:, 1), ret(:, end), styles{j}, 'Color',MarkerEdgeColors(j,:));
        legend(algo);
        set(gca,'yscale','log')
    end    
    
    
    hold off;
end


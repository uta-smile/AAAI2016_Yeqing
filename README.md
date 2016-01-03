# Sequential Spectral Clustering (seqsc)

Repository for Sequential Spectral Clustering. 

**Reference**
> Yeqing Li, Junzhou Huang, Wei Liu, “Scalable Sequential Spectral Clustering”, AAAI Conference on Artificial Intelligence (AAAI), 2016.

## Download Data and Preprocessing 

First download the data using the following script.
```bash
cd data
./get_data.sh
```

Then, split the data into blocks and intervals, which is required for the experiment. Run the following MatLab script in the MatLab console.
```
mainSplitMNIST
```

More data can be downloaded from: http://mldata.org/

## Experiments

First, in the MatLab console, run **``initPath.m"** to add the scripts to the path.
Then, run the following scripts for the experiments

+ **runSC.m**: SC is the spectral clustering on normalized Laplacian (Ng
et al. 2002). We use the implementation that is available online (Chen et al. 2011).
+ **runKASP**: KASP is proposed in (Yan, Huang, and Jordan 2009) and is an approximate spectral clustering algorithm based on K-Means. We implement this algorithm using MatLab for fair comparison.
+ **runNystromSC.m**: Nystrom (Fowlkes et al. 2004) uses Nystr ̈om transform to
approximate the eigenfunction problem. We use the implementation that is available online (Chen et al. 2011). 
+ **runLSCByInterval.m**: LSC (Chen and Cai 2011) is a Landmark-based spectral clustering algorithm. We download the MatLab code from
the authors’ website.
- **runESCG.m**: ESCG (Liu et al. 2013a) uses shortest path algorithm to  generate bipartite graph. We download the Matlab code from the authors’ website 
- **runSeqSC.m**: SeqSC is the proposed algorithm.

**Note**: The script *update.sh* can be used to clean all the intermediate results and the output mat files.





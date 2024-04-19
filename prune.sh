#!/bin/bash
set -e
set -u
set -o pipefail

# script to prune variants in Linkage Disequilibrium (correlation coefficient > 0.05) using plink2
# can be parallelized: e.g. bash prune.sh 1 9 & bash prune.sh 10 22 &
# to run the script for chr 1-9 and chr 10-22 in parallel

start_chr=$1
end_chr=$2

# Loop over input start and end chromosomes
for ((chr = $start_chr; chr <= $end_chr; chr++))
do
    # LD pruning using --indep-pairwise
    plink2 --bfile WES_c${chr}_snps_qc_pass --maf 0.05 --geno 0.1 --indep-pairwise 1000kb 1 0.05 --out chr${chr}

    # Extract pruned SNPs using --extract and output to prunned directory
    plink2 --extract chr${chr}.prune.in --bfile WES_c${chr}_snps_qc_pass --make-bed --out ./prunned/chr${chr}_pruned
done
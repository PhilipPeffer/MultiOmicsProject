#!/bin/bash
set -e
set -u
set -o pipefail

# script to merge the LD-pruned plink files created for each chromosome using prune.sh script

# Create the output file
>merge_list.txt

# Loop over each chromosome
for chr in {1..22};
do
    # Append pruned file paths to the merge list
     echo "chr${chr}_pruned" >> merge_list.txt
done

# Also include chrX
echo "chrX_pruned" >> merge_list.txt

# Merge the new plink files into a single file with all chromosomes (1-22 & X)
plink2 --bfile chr1_pruned --pmerge-list "$merge_list" bfile --make-bed --out WES_allChr_snps_pruned
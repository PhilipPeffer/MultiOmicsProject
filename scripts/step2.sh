#!/bin/bash
set -e
set -u
set -o pipefail

# repeat REGENIE step 2 (test each variant for association with each phenotype) for each chromosome
# (chr22 excluded as the steps were run on chr22 independently first to verify everything working as intended)
chromosomes=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 X)

for i in "${chromosomes[@]}"
do    
    regenie \
        --step 2 \
        --bed /home/jupyter/gcs/ukb/plink/olink/chr${i}_olink \  #file containing genotype data for each patient for variants located in the genes on the chr that encode for the olink proteins
        --covarFile /home/jupyter/gcs/ukb/regenie/covariates.txt \  #file containing covariates data for each patient
        --phenoFile /home/jupyter/gcs/ukb/regenie/phenos/chr${i}_phenos.txt \  #file containing protein levels for each patient, but only for genes located on the chr
        --bsize 400 \  #genotype block size
        --qt \  #specify quantitative traits (not categorical)
        --minMAC 1 \  #specify minimum minor allele count of 1 (default is 5)
        --threads 126 \  #number of computational threads to use
        --pred /home/jupyter/gcs/ukb/regenie/gwas_allOthers/step1/chr${i}_fit_pred.list \  #file output from step 1 that contains the names of the phenotypes and their corresponding prediction file name
        --gz \  #compress output
        --out /home/jupyter/gcs/ukb/regenie/gwas_allOthers/step2/chr${i}prots/chr${i}_assoc  #output file prefix
done

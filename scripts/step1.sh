#!/bin/bash
set -e
set -u
set -o pipefail

# repeat REGENIE step 1 (build whole genome regression models for each phenotype) for each chromosome
# (chr22 excluded as the steps were run on chr22 independently first to verify everything working as intended)
for chr in {1..21}
do
    regenie \
      --step 1 \
      --bed ~/gcs/ukb/plink/prunned/HWE/WES_allChr_snps_pruned2 \  #input genetic data file
      --covarFile ~/gcs/ukb/regenie/covariates.txt \  #file containing covariates data for each patient
      --phenoFile ~/gcs/ukb/regenie/phenos/chr${chr}_phenos.txt \  #file containing protein levels for each patient, but only for genes located on the chr
      --bsize 1000 \  #size of genotype blocks (model is fit on blocks of variants)
      --threads 126 \  #number of computational threads to use
      --lowmem \  #low memory mode - write to temporary files as too large to store everything in RAM
      --lowmem-prefix ~/gcs/ukb/regenie/gwas_allOthers/step1/tmpdir/regenie_tmp_preds \  #temp file prefix
      --out ~/gcs/ukb/regenie/gwas_allOthers/step1/chr${chr}_fit  #output file prefix
done

# also repeat for chrX
regenie \
  --step 1 \
  --bed ~/gcs/ukb/plink/prunned/HWE/WES_allChr_snps_pruned2 \
  --covarFile ~/gcs/ukb/regenie/covariates.txt \
  --phenoFile ~/gcs/ukb/regenie/phenos/chrX_phenos.txt \
  --bsize 1000 \
  --threads 126 \
  --lowmem \
  --lowmem-prefix ~/gcs/ukb/regenie/gwas_allOthers/step1/tmpdir/regenie_tmp_preds \
  --out ~/gcs/ukb/regenie/gwas_allOthers/step1/chrX_fit
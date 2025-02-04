#!/bin/bash
set -e
set -u
set -o pipefail

# from pruned variants,
# exclude variants wildly out of HWE contained in
# the files excludeHWE_auto and excludeHWE_x
plink2 --bfile ~/gcs/ukb/plink/prunned/WES_allChr_snps_pruned \
    --exclude ~/gcs/ukb/regenie/gwas_allOthers/excludeHWE_x \
    --make-bed --out ~/gcs/ukb/plink/prunned/HWE/WES_allChr_snps_pruned1
    
plink2 --bfile ~/gcs/ukb/plink/prunned/HWE/WES_allChr_snps_pruned1 \
    --exclude ~/gcs/ukb/regenie/gwas_allOthers/excludeHWE_auto \
    --make-bed --out ~/gcs/ukb/plink/prunned/HWE/WES_allChr_snps_pruned2

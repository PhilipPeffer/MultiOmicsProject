#!/bin/bash
set -e
set -u
set -o pipefail

# Loop over chromosomes 1-22
for chr in {1..22}
do
    # exclude variants not found in olink protein encoding genes
    # remove patients that withdrew from the study
    plink2 --bfile ~/gcs/ukb/plink/WES_c${chr}_snps_qc_pass \
        --extract ~/olink_variants.txt \
        --remove ~/gcs/ukb/plink/olink/widraw.txt \
        --geno 0.7 \
        --make-bed --out ~/gcs/ukb/plink/olink/chr${chr}_olink
done

# Also do the same for chrX
plink2 --bfile ~/gcs/ukb/plink/WES_cX_snps_qc_pass \
    --extract ~/olink_variants.txt \
    --remove ~/gcs/ukb/plink/olink/widraw.txt \
    --geno 0.7 \
    --make-bed --out ~/gcs/ukb/plink/olink/chrX_olink
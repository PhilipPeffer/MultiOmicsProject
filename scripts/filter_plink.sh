#!/bin/bash
set -e
set -u
set -o pipefail

# create a file for each chromosome containing the list or variants located in genes on that
# chromosome that encode olink panel proteins

# Loop over chromosomes 1-22
for chr in {1..21}
do
    # extract the unique variant IDs from the plink variant info file for the chromosome and save to a temp file
    cut -f 2 ~/gcs/ukb/plink/olink/chr${chr}_olink.bim | sort | uniq > temp.txt
    # filter for only those variants located in the '470k_coding.tsv' file (protein coding gene variants) and save to file
    grep -wF --file=temp.txt ~/470k_coding.tsv > ~/annot_by_chromosome/second_run/chr${chr}_olink.txt
done

# Also do the same for chrX
cut -f 2 ~/gcs/ukb/plink/olink/chrX_olink.bim | sort | uniq > temp.txt
grep -wF --file=temp.txt ~/470k_coding.tsv > ~/annot_by_chromosome/second_run/chrX_olink.txt

rm temp.txt
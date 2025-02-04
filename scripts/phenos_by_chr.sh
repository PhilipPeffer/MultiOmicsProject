#!/bin/bash
set -e
set -u
set -o pipefail

# create a file for the specified chr (1st argument) with the patient protein levels for each gene on that chr
# format as REGENIE phenoFile (FID and IID columns)
# (also create a file for the specified chr listing all protein-coding gene symbols located on the chr
# and a file listing the gene symbols of all olink protein coding genes located on the chr)

variants="$HOME/470k_coding.tsv"  # file containing all protein coding variants in all 470K ukbb subjects
genes="$HOME/olink_genes.txt"     # file containing gene symbols of the ~3000 proteins in olink
phenotypes="$HOME/gcs/ukb/regenie/phenotype_bin.txt"  # file containing olink panel protein levels for ~50K ukbb subjects

# extract the list of all unique gene symbols found on 'chr' from the annotation file
sed -nr "s/^chr$1:.*\"symbol\":\"([^\"]+)\".*/\1/p" "$variants" | sort | uniq > ./phenos/chr$1_genes.txt

# extract the set of olink gene symbols from the list of all 'chr' gene symbols
grep -xF --file="$genes" ./phenos/chr$1_genes.txt > ./phenos/chr$1_olink_genes.txt

# prepare the gene symbols by adding ^ at the start and _rint at the end,
# to match the phenotype file naming convention, and save to temp file
sed 's/^/\^/;s/$/_rint/' ./phenos/chr$1_olink_genes.txt > temp$1.txt

# Extract the subject protein levels for the 'chr' olink proteins
# Extracts the first line of the phenotypes file (which contains column headers).
# Searches for column names (gene names) listed in temp$1.txt within that first line.
# Extracts the corresponding column numbers.
# Formats the column numbers into a comma-separated list.
# Stores this list in the cols variable.
# This list of column numbers (cols) will be used to extract the protein levels for the chr genes from the phenotypes file.
cols=$(sed '1!d;s/\t/\n/g' "$phenotypes" | grep -inf temp$1.txt | sed 's/:.*$//' | tr '\n' ',' | sed 's/,$//')

# add FID and IID columns and output to file
cut -f 1,2,"$cols" "$phenotypes" > ./phenos/chr$1_phenos.txt

# remove temp file
rm -f temp$1.txt
#!/bin/bash
set -e
set -u
set -o pipefail

# from the file containing all protein coding variants in the ~470k UKBB subjects, select
# only the variants that are in the ~3000 genes that encode for proteins in the olink panel
# output the list of variants to a text file

variants="$HOME/470k_coding.tsv"  # file containing all protein coding variants in all 470K ukbb subjects
genes="$HOME/npx_genes.csv"      # file containing gene symbols of the ~3000 proteins in olink

# remove header line
# some genes in the file are separated by '_' instead of '\n'. Separate these by newline instead
# output to file
grep -v "^x$" "$genes" | sed 's/_/\n/g' > "$HOME/olink_genes.txt"

# format each gene for more specific matching in variants file and save to temp file
sed -E 's/([^_]+)/"symbol":"\1"/g' "$HOME/olink_genes.txt" > temp.txt

# grep the variant lines containing the gene symbol and output variant IDs to file
grep -F --file=temp.txt "$variants" | cut -f 3 > olink_variants.txt

# remove temp file
rm temp.txt
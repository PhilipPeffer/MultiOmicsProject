#!/bin/bash
set -e
set -u
set -o pipefail

# Extract the top 10 most strongly associated variants for a given REGENIE phenotype association file (1st argument)

header=$(grep "^CHROM" $1)

file=$(echo "$1")
name=$(basename -s .regenie $file)
name="${name}_top10"

echo $header > $name

grep -v "^CHROM" $1 | sort -g -k12,12 -r | head -n10 >> $name
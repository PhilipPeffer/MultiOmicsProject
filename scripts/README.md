## Order of script execution / processing

Note: Due to time/cost constraints, trans-chromosomal associations were not tested (e.g. variants on Chr22 were only tested for association with levels of proteins encoded by genes 
on Chr22). This means that regulatory effects of gene variants on proteins encoded by genes on other chromosomes cannot be explored from the generated ExWAS results. However, 
cis-coding sequence effects (gene variant effects on the levels of the protein encoded by the same gene) were the focus of this study.

### Prepared patient genotype/variant files for regenie step 1 using plink

1. ‘prune.sh’ - filtered out variants in linkage disequilibrium (LD), as well as variants with minor allele frequencies (MAF) < 5%, and missingness > 10%
2. ‘merge.sh’ - merged the 23 pruned plink files into a single file for use with REGENIE
3. ‘HWE_filter.sh’ - excluded variants wildly out of Hardy-Weinberg Equilibrium (HWE)

### Prepared patient genotype/variant files for regenie step 2 using plink

4. ‘filter_olink.sh’ - generated list of variants located in genes that encode olink panel proteins
5. ‘extract_olink.sh’ - from the patient genotype data (plink files), filtered out variants not in the ‘olink_variants.txt’ list.
   Also removed patients that withdrew from the study, and variants with missingness > 70%
7. ‘filter_plink.sh’ - created a list of olink panel protein-encoding gene variants for each chr. 

### Prepared covariate and phenotype files

7. ‘export_regenie.ipynb’ - reformatted and exported Hail covariate and phenotype tables for use with REGENIE
8. ‘phenos_by_chr2.sh’ - created a file for each chr listing all genes on the chr, and separated the patient phenotype protein levels by chr

### Tested Regenie steps 1 & 2 on Chr22

9. ‘gwas_verif.ipynb’ - verified Chr22 ExWAS results before running REGENIE on all other chr

### Performed Regenie step 1 on all other Chr

10. ‘step1.sh’ - performed Regenie step 1 for each Chr (excluding Chr22). For each Chr, fit a whole genome linear regression model for each included phenotype
    (levels of each olink protein encoded by a gene on that Chr)

### Performed Regenie step 2 on all other Chr

11. ‘step2.sh’ - performed Regenie step 2 for each Chr (excluding Chr22). For each Chr, using the models created in step 1, tested each variant located on the Chr
    for association with each included phenotype (levels of each olink protein encoded by a gene on that Chr)

### Post-processing (merged all results into a single table and added annotations)

12. ‘top10.sh’ - extracted the top 10 most strongly associated variants for a given REGENIE phenotype association file
13. ‘merge.ipynb’ - for each chr, concatenatde the REGENIE variant association tables for each phenotype into a single table and merged with gene/variant annotations

### Analysis

14. ‘LoF_analysis_olinkAnnot_v2.ipynb’ - analysis of potential error modes / batch effects
15. ‘LoF_analysis_allChr_QC_v1.ipynb’ - final analysis notebook examining LOFTEE predicted loss-of-function variants (pLoFs) compared to true observed LoFs

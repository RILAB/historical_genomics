## Obtaining NAM progeny SNP effect sizes

### Trait or residual/error phenotype data:

- Obtained from Wallace et al. (2014) [supporting dataset 3] (http://journals.plos.org/plosgenetics/article/asset?unique&id=info:doi/10.1371/journal.pgen.1004845.s008)
- Uploaded to farm in directory:
```
/group/jrigrp4/Justin_Kate/NAM_GWAS/
```

### Genotype data from GBS 2.7 v.3.b of B73 reference genome:
-  I obtained the data from [PANZEA](http://mirrors.iplantcollaborative.org/browse/iplant/home/shared/panzea/genotypes/GBS/v27/AllZeaGBSv2.7_publicSamples_imputedV3b_agpv3.hmp.gz) **NB** this data also contains metadata which is important for pulling out samples/individuals in steps 3-4 

- Sort the genotype file with:

```
run_pipeline.pl -Xmx64g -SortGenotypeFilePlugin -inputFile AllZeaGBSv2.7_publicSamples_imputedV3b_agpv3.hmp.gz -outputFile sortedGBS -fileType Hapmap
```

- Use this script to make a list of the genotypes that you want:
```
rm(list=ls())
library(data.table)

GBS <- read.csv("AllZeaGBSv2.7_public.csv", header=T)
dt <- data.table(GBS)

# Subset out NAM or Ames - here is an example with Ames - NAM is NAM - check the metadata/csv file first
dt.1 <- subset(dt, Project == "2010 Ames Lines")
dt.2 <- subset(dt, Project == "AMES Inbreds")
dt.3 <- subset(dt, Project == "Ames282")

dt <- rbind(dt.1, dt.2, dt.3)
# Get only the unique runs for now by row - we can go back and judge later if this is a problem
# i.e. perhaps quality might be an issue
setkey(dt, "DNASample")
dt.u <- unique(dt, by = "DNASample")

# Generate just a .txt of the actual GBS name for Tassel to include/exclude

keep_list <- subset(dt.u, select = "FullName")

write.table(keep_list, "keep_list.txt")

write.csv(keep_list, "keep_list.csv")
```


- Based on list pulled from R-script, pull genotypes of the NAM kids out - should be about 5000 - and export this as VCF
```
run_pipeline.pl -Xmx64g -fork1 -h sortedGBS.hmp.txt -includeTaxaInfile keep_list.txt -export -exportType VCF -runfork1

```

- With vcf file open vcftools (this is my local path) and keep only biallelic loci **NB** this is the only criteria I used to filter the data:

```
gzip*.vcf

~/bin/vcftools_0.1.12b/bin/vcftools --gzvcf sorted_NAM_children.vcf.gz --min-alleles 2 --max-alleles 2 --recode --out biallelic_NAM_children
```
- Some awk and sed scripts to clean up the names of the NAM children so that it will match Wallace's names

```
#This cuts header
sed '11q;d' biallelic_NAM_children.recode.vcf > header.vcf

#This cuts lines BEFORE header
sed '1,10!d' biallelic_NAM_children.recode.vcf > first.vcf

#This cuts lines below the header
sed -e '1,11d' biallelic_NAM_children.recode.vcf > last.vcf

# transpose the header and awk and transpose again - give it the proper naming
cat header.vcf | tr '\t' '\n'| awk -F":" '{print $1}'| tr '\n' '\t' > middle.vcf

# Middle has no line ending so add one
sed -i -e '$a\' middle.vcf

# Put it all back together, this is our new vcf file
cat first.vcf middle.vcf last.vcf > GWAS_NAM.vcf

# Convert this to plink
~/bin/vcftools_0.1.12b/bin/vcftools --vcf GWAS_NAM.vcf --plink --out GWAS_NAM_plk

```

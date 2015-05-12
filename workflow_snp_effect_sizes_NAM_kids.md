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
- Next, we need to put get the 0,1,2 file format for the linear model (also known as GWAS) but must do it by chromosome. You can do this with plink, with the --recode AD format - but it creates duplicate columns (but keeps the marker headers). I opted for the --recode 12 flag option. This creates both map and ped files. Use the ped file for joining to the trait residuals. **NB** 0 = NA, 1 = first allele (I think minor), 2 = second allele (I think major).

```
plink --file GWAS_NAM_plk --chr 10 --recode 12 --out AD_NAM_KIDS_chr10
plink --file GWAS_NAM_plk --chr 1 --recode 12 --out AD_NAM_KIDS_chr1
plink --file GWAS_NAM_plk --chr 2 --recode 12 --out AD_NAM_KIDS_chr2
plink --file GWAS_NAM_plk --chr 3 --recode 12 --out AD_NAM_KIDS_chr3
plink --file GWAS_NAM_plk --chr 4 --recode 12 --out AD_NAM_KIDS_chr4
plink --file GWAS_NAM_plk --chr 5 --recode 12 --out AD_NAM_KIDS_chr5
plink --file GWAS_NAM_plk --chr 6 --recode 12 --out AD_NAM_KIDS_chr6
plink --file GWAS_NAM_plk --chr 7 --recode 12 --out AD_NAM_KIDS_chr7
plink --file GWAS_NAM_plk --chr 8 --recode 12 --out AD_NAM_KIDS_chr8
plink --file GWAS_NAM_plk --chr 9 --recode 12 --out AD_NAM_KIDS_chr9
```

- In case you want to run with the --recode AD options, run these (better for indexing downstream). 
```
# this eliminates every second column
for file in *.raw
do
        echo "$file: " $(awk '{for(i=1;i<=NF;i=i+2){printf "%s ", $i}{printf "%s", RS}}' $file > unique$file)
done

# this cuts the second and third column which are not useful

for file in unique*
do
        echo "$file: " $(cut -d" " -f -1,4- $file > cut2$file)
done

```

## Linear modeling with R

- We need to eliminate massive numbers of SNPs, and there are too many to do forward stepwise on initially. So we will run a set of non-nested, i.e. not comparable models first. Basically:

- Y ~ SNP1
- Y ~ SNP2
- .
- .
- .
- Y ~ SNP<sub>n</sub>


We will also impute the missing genotypes first - I've just provided a toy example here.
```
rm(list=ls())
set.seed(3428)
n = 50

# Make a bunch of factors for SNPs -just doing 5 not 500k
seq1 <- seq(0,2, by = 1)
seq2 <- seq(0,1, by = 1)
seq7 <- seq(1,2, by = 1)
seq4 <- seq(0,2, by = 2)
seq5 <- rep(0, by = n)
seq6 <- rep(1, by = n)
seq3 <- rep(2, by = n)


SNP1 <- sample(seq4, size = n, replace=TRUE)
SNP2 <- sample(seq1, size = n, replace=TRUE)
SNP3 <- sample(seq3, size = n, replace=TRUE)
SNP4 <- sample(seq1, size = n, replace=TRUE)
SNP5 <- sample(seq2, size = n, replace=TRUE)
SNP6 <- sample(seq1, size = n, replace=TRUE)
SNP7 <- sample(seq4, size = n, replace=TRUE)
SNP8 <- sample(seq1, size = n, replace=TRUE)
SNP9 <- sample(seq2, size = n, replace=TRUE)
SNP10 <- sample(seq4, size = n, replace=TRUE)
SNP11 <- seq5
SNP12 <- seq6
SNP13 <- seq7
SNP14 <- seq5
SNP15 <- seq6
SNP16 <- seq7
SNP17 <- seq5
SNP18 <- seq6
SNP19 <- seq7

# Normally (we assume) distributed residuals by chromosome by trait in the NAM kids
Y <- rnorm(n)

# make a data.frame of just the SNPs
SNPs <- data.frame(SNP1,SNP2,SNP3,SNP4,SNP5,SNP6,SNP7,SNP8,SNP9,SNP10, SNP11, SNP12, SNP13,
	SNP14, SNP15, SNP16, SNP17, SNP18, SNP19)

# Add random NAs based on n, save for the first col
SNPs[-1] <- lapply(SNPs[-1], function(x) { x[sample(c(1:n), floor(n/10))] <- NA ; x })


# My example data
df <- data.frame(Y, SNPs)
print(df)

# Impute the missing genotypes coarsely - it's NAM so not HWE

for(i in 2:ncol(df)){
print(i)
probs<-c()
probs[1]<-length(which(df[,i]==0))/length(which(is.na(df[,i])==F))
probs[2]<-length(which(df[,i]==1))/length(which(is.na(df[,i])==F))
probs[3]<-length(which(df[,i]==2))/length(which(is.na(df[,i])==F))
print(probs)
replace <- sample(c(0,1,2),length(which(is.na(df[,i])==T)),replace=T,prob=probs)
df[which(is.na(df[,i])==T),i] <- replace
}

# All the NAs are now filled

print(df)

# Throw out columns with no variance, reducing the array size

df <- Filter(function(x)(length(unique(x))>1), df)


# Define empty vectors of stuff we want to keep from the single GLM or goddamn GWAS (stupid acronymn) 
# summaries


intercept <- NULL
effect.size <- NULL
probability <- NULL
SNP.names <- NULL

# Fit single SNPs to chrom residuals, and pull out diagnostics of interest
for(j in 2:ncol(df)){
	print(j)
	intercept[j] <- coef(summary(lm(df$Y ~ df[,j])))[1]
	effect.size[j] <- coef(summary(lm(df$Y ~ df[,j])))[2]
	probability[j] <- coef(summary(lm(df$Y ~ df[,j])))[8]
	SNP.names[j] <- colnames(df[j])
}

SNP.names <- as.character(SNP.names)

# Bind the vectors
results <- data.frame(SNP.names,intercept, effect.size, probability, stringsAsFactors = FALSE)


# Establish a cutoff - I chose multiple Bonnferroni because it's insane, but here is a toy example
# of not bonnferroni but some BS value
sig.results <- subset(results, probability <= 0.3)

print(sig.results)

x <- as.vector(sig.results$SNP.names)

# Now use the vector of names to pull stuff out of the larger array
new.df <- df[,colnames(df) %in% x]

# Add Y back in to the new array

new.df <- data.frame(Y, new.df)

# Stepwise
min.model = lm(Y ~ 1, data=df)
 
biggest.model <- formula(lm(Y~., df))
 
fwd.model <- step(min.model, direction = 'forward', scope = biggest.model)
```

# YOU NOW HAVE EFFECT SIZES OF SNPs that contribute most to each trait of interest (we may need to consider binning). NOW MORE SCRIPTS.

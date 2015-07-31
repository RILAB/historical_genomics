# Relatively hacky way to get a Bayenv file by Individual

Cut up your heterotic group's vcf header and metadata, and then the data in the vcf.

```bash
sed '1,11!d' input.vcf > output1.vcf
sed -e '1,11d' input > output2.vcf
```

Choose every 25th SNP, this ought to minimize LD between SNPs on a chromosome
```bash
sed -n '1p;0~25p' output2.vcf > output_lessLD.vcf

cat firstpart.vcf output_lessLD.vcf > cluster_reducedLD.vcf
```

Using a bash loop declare your list of named individuals (example below - you can make this file in vim - will provide script later):

```bash

declare -a arr=("05-397" "05-438" "12E" "207" "22612" "25-046" "3042" "3102-23" "3167B" "32311C-A" "33-16")

for i in "${arr[@]}"
do
        echo "$i: "$(~/bin/vcftools_0.1.12b/bin/vcftools --vcf final.vcf --indv $i --recode --out forfrq$i)
done
```

- Copy these small vcfs to a new directory

- Calculate frequencies of each vcf file, produces the 0,1 counts, plus missing sites.

```bash
for file in *.vcf
do
        echo "$file: "$(~/bin/vcftools_0.1.12b/bin/vcftools --vcf $file --freq --out new$file)
done
```

- Next remove the header of all these files, because we'll move to R next.

```bash
for file in *.frq
do
        echo "$file: "$(tail -n+2 $file > noheader$file)
done
```

- Move these noheader files to a new directory and open R:

```R
rm(list=ls())
library(plyr)
library(stringr)
setwd("~/bayenv_test/by_ind/forfreqs/R_convert_to_bayenv")

files <- list.files("~/bayenv_test/by_ind/forfreqs/R_convert_to_bayenv", "*.frq", full.names = TRUE)


cluster.list <- lapply(files, function(cluster) {

        cluster <- read.table(cluster, header = FALSE,
        fill = TRUE, sep ="\t", row.names=NULL)

        major <- cluster[,5]
        minor <- cluster[,6]
        N_CHR <- cluster[,4]
        POS <- cluster[,2]
        CHROM <- cluster[,1]

        major <- str_replace(major, "C:", "")
        major <- str_replace(major, "A:", "")
        major <- str_replace(major, "T:", "")
        major <- str_replace(major, "G:", "")
        major <- str_replace(major, "N:", "")

        major<-as.numeric(major)
        major[is.na(major)] <- 0

        minor <- str_replace(minor, "C:", "")
        minor <- str_replace(minor, "A:", "")
        minor <- str_replace(minor, "T:", "")
        minor <- str_replace(minor, "G:", "")
        minor <- str_replace(minor, "N:", "")

        minor <- as.numeric(minor)

         minor[is.na(minor)] <- 0

        sfs.1 <- data.frame(N_CHR, major, minor, POS, CHROM)
         ind.major <- (sfs.1[,1] * sfs.1[,2])/2
        ind.major <- round(ind.major, digits = 0)

        ind.minor <- (sfs.1[,1] * sfs.1[,3])/2
        ind.minor <- round(ind.minor, digits = 0)

        df <- data.frame(ind.minor, ind.major)

        df.T <- t(df)

        df.T <- as.data.frame.table(df.T)

        x <- t(df.T[,3])

        pop.all.snps.counts <- t(x)

})

bayenv.df <- do.call(cbind, cluster.list)
bayenv.df <- data.frame(bayenv.df)
xx <- rowSums(bayenv.df)
bayenv.index <- data.frame(bayenv.df,xx)

#Create index of rows that sum to zero
y <- which(bayenv.index$xx ==0)
# And those major alleles below them (fixed)
z <- y + 1
# Combine vectors
zz <- c(y,z)

# Include only those loci that are not fixed for the major allele
new.df <- bayenv.df[!rownames(bayenv.df) %in% zz,]

bayenv.snps.mat <- as.matrix(new.df)
bayenv.snps.mat <- matrix(bayenv.snps.mat, ncol = ncol(bayenv.df), dimnames = NULL)

write.table(bayenv.snps.mat, "bayenv_SNPsfile", sep = "\t")
```
Now just clean up file with vim. Ready to run.

# Relatively hacky way to get a Bayenv file by Individual


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
setwd("~/bayenv_test/cluster1_tropical/forfreqs/R_covert_to_bayenv")

files <- list.files("~/bayenv_test/cluster1_tropical/forfreqs/R_covert_to_bayenv", "*.frq", full.names = TRUE)

length(files)

cluster.list <- lapply(files, function(cluster) {

        cluster <- read.table(cluster, header = FALSE,
        fill = TRUE, sep ="\t", row.names=NULL)

        major <- cluster[,5]
        minor <- cluster[,6]
        N_CHR <- cluster[,4]
        POS <- cluster[,2]
        CHROM <- cluster[,1]

        major <- str_replace(major, "C:1", "2")
        major <- str_replace(major, "A:1", "2")
        major <- str_replace(major, "T:1", "2")
        major <- str_replace(major, "G:1", "2")
        major <- str_replace(major, "C:0.5", "1")
        major <- str_replace(major, "C:0.5", "1")
        major <- str_replace(major, "A:0.5", "1")
        major <- str_replace(major, "T:0.5", "1")
        major <- str_replace(major, "G:0", "0")
        major <- str_replace(major, "A:0", "0")
        major <- str_replace(major, "T:0", "0")
        major <- str_replace(major, "G:0", "0")
        major <- str_replace(major, "N:", "")
        major <- str_replace(major, "C:-nan", "")
        major <- str_replace(major, "A:-nan", "")
        major <- str_replace(major, "G:-nan", "")
        major <- str_replace(major, "T:-nan", "")

        major<-as.numeric(major)
        major[is.na(major)] <- 3

        minor <- str_replace(minor, "C:1", "2")
        minor <- str_replace(minor, "A:1", "2")
        minor <- str_replace(minor, "T:1", "2")
        minor <- str_replace(minor, "G:1", "2")
        minor <- str_replace(minor, "C:0.5", "1")
        minor <- str_replace(minor, "A:0.5", "1")
        minor <- str_replace(minor, "T:0.5", "1")
        minor <- str_replace(minor, "G:0.5", "1")
        minor <- str_replace(minor, "C:0", "0")
        minor <- str_replace(minor, "A:0", "0")
        minor <- str_replace(minor, "T:0", "0")
        minor <- str_replace(minor, "G:0", "0")
        minor <- str_replace(minor, "N:", "")
        minor <- str_replace(minor, "C:-nan", "")
        minor <- str_replace(minor, "A:-nan", "")
        minor <- str_replace(minor, "G:-nan", "")
        minor <- str_replace(minor, "T:-nan", "")

        minor <- as.numeric(minor)

        minor[is.na(minor)] <- 3

        ind.major <- round(major, digits = 0)
        ind.minor <- round(minor, digits = 0)

        df <- data.frame(minor, major)

        df.T <- t(df)
        
        df.T <- as.data.frame.table(df.T)

        x <- t(df.T[,3])

        pop.all.snps.counts <- t(x)

})

#Create an index of names
index.file <- read.table("noheadernewallfrqCML421:81N4HABXX:2:250033097.recode.vcf.frq", header = FALSE,
        fill = TRUE, sep = "\t", row.names = NULL)
CHROM <- index.file[,1]
POS <- index.file[,2]

df.idx <- data.frame(CHROM, POS)
df.idx <- df.idx[rep(seq_len(nrow(df.idx)), each=2),]

bayenv.df <- do.call(cbind, cluster.list)
bayenv.df <- data.frame(df.idx,bayenv.df)
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

write.table(bayenv.snps.mat, "output", sep = "\t", row.names=FALSE, header=FALSE)
```
Now just clean up file with vim or unix (remove header, row names or index, etc). Ready to run as covariance matrix or the whole file.

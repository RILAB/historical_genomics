rm(list())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM/models/LeafAngle/SNPs_effects")

library(broom)
library(plyr)

load("chr10_SNPs.RData")
load("chr9_SNPs.RData")
load("chr8_SNPs.RData")
load("chr7_SNPs.RData")
load("chr6_SNPs.RData")
load("chr5_SNPs.RData")
load("chr4_SNPs.RData")
load("chr3_SNPs.RData")
load("chr2_SNPs.RData")
load("chr1_SNPs.RData")

chr10 <- tidy(model.10)
chr9 <- tidy(model.9)
chr8 <- tidy(model.8)
chr7 <- tidy(model.7)
chr6 <- tidy(model.6)
chr5 <- tidy(model.5)
chr4 <- tidy(model.4)
chr3 <- tidy(model.3)
chr2 <- tidy(model.2)
chr1 <- tidy(model.1)

# Make a list of our model dataframes
model.list <- list(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)

chr.list <- lapply(model.list, function(chr) {
  chr <- chr[-1,]
  chr <- subset(chr, p.value <= 0.05)
})

df <- ldply(chr.list, data.frame)

save(df, "SNP_effects_ordered.RData")

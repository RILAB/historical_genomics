rm(list=ls())

setwd("~/SNP_outputs")

library(broom)
library(stringr)
library(stringi)
library(plyr)

load("fwd.model_chr10tasselL_500_step.RData")
chr10 <- fwd.model
load("fwd.model_chr9tasselL_500_step.RData")
chr9 <- fwd.model
load("fwd.model_chr8tasselL_500_step.RData")
chr8 <- fwd.model
load("fwd.model_chr7tasselL_500_step.RData")
chr7 <- fwd.model
load("fwd.model_chr6tasselL_top500_step.RData")
chr6 <- fwd.model
load("fwd.model_chr5tasselL_500_step.RData")
chr5<- fwd.model
load("fwd.model_chr4tasselL_500_step.RData")
chr4 <- fwd.model
load("fwd.model_chr3tasselL_500_step.RData")
chr3 <- fwd.model
load("fwd.model_chr2tasselL_500_step.RData")
chr2 <- fwd.model
load("fwd.model_chr1tasselL_500_step.RData")
chr1 <- fwd.model


chr10 <- tidy(chr10)
chr9 <- tidy(chr9)
chr8 <- tidy(chr8)
chr7 <- tidy(chr7)
chr6 <- tidy(chr6)
chr5 <- tidy(chr5)
chr4 <- tidy(chr4)
chr3 <- tidy(chr3)
chr2 <- tidy(chr2)
chr1 <- tidy(chr1) 

# Make a list of our model dataframes
model.list <- list(chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10)

chr.list <- lapply(model.list, function(chr) {
  chr <- chr[-1,]
  terms<- chr$term
  terms <- stri_replace_first_fixed(terms, "_", "&")
  terms <- sub('.*&','',terms)
  terms <- str_replace(terms, "_A", "")
  terms <- str_replace(terms, "_T", "")
  terms <- str_replace(terms, "_G", "")
  terms <- str_replace(terms, "_C", "")
  basepairs <- as.numeric(terms)
  chr <- data.frame(chr, basepairs)
  chr <- chr[order(basepairs),]
  # Round a window to nearest 100000th or -5 for 10000th, etc 
  rounded <-round(chr$basepairs, -6)
  df <- data.frame(chr, rounded)
  # This next line is important change to - abs(df$estimate) for largest effect
  dd <- df[order(df$rounded + abs(df$p.value) ), ]
  pp<- dd[ !duplicated(dd$rounded), ]  
})

# Extract as one data.frame - this gives you an index of SNPs to refit an lm
df <- ldply(chr.list, data.frame)


snp.idx <- as.vector(df$term)
# Example if you want to do it by chromosome - e.g. chromosome 10, etc
df10 <- ldply(chr.list[10], data.frame)
df9 <- ldply(chr.list[9], data.frame)
df8 <- ldply(chr.list[8], data.frame)
df7 <- ldply(chr.list[7], data.frame)
df6 <- ldply(chr.list[6], data.frame)
df5 <- ldply(chr.list[5], data.frame)
df4 <- ldply(chr.list[4], data.frame)
df3 <- ldply(chr.list[3], data.frame)
df2 <- ldply(chr.list[2], data.frame)
df1 <- ldply(chr.list[1], data.frame)

# Pull out the indices
snp.idx10<- as.vector(df10$term)
snp.idx9<- as.vector(df9$term)
snp.idx8<- as.vector(df8$term)
snp.idx7<- as.vector(df7$term)
snp.idx6<- as.vector(df6$term)
snp.idx5<- as.vector(df5$term)
snp.idx4<- as.vector(df4$term)
snp.idx3<- as.vector(df3$term)
snp.idx2<- as.vector(df2$term)
snp.idx1<- as.vector(df1$term)

# Save all the indices, violating DRY all over the place
save(snp.idx10, file = "snp.idx10.RData")
save(snp.idx9, file = "snp.idx9.RData")
save(snp.idx8, file = "snp.idx8.RData")
save(snp.idx7, file = "snp.idx7.RData")
save(snp.idx6, file = "snp.idx6.RData")
save(snp.idx5, file = "snp.idx5.RData")
save(snp.idx4, file = "snp.idx4.RData")
save(snp.idx3, file = "snp.idx3.RData")
save(snp.idx2, file = "snp.idx2.RData")
save(snp.idx1, file = "snp.idx1.RData")

# Brief visualizations for the whole genome
barplot(df$estimate, col ="blue", ylab = "SNP Effect Size",
        main ="All Chromosomes Ordered", names.arg=df$term, cex.axis=0.5)

# Or by chromosome
par(mfrow = c(5,2))
barplot(df10$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 10")
barplot(df9$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 9")
barplot(df8$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 8")
barplot(df7$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 7")
barplot(df6$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 6")
barplot(df5$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 5")
barplot(df4$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 4")
barplot(df3$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 3")
barplot(df2$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 2")
barplot(df1$estimate, col = "red", ylab = "SNP Effect Size", main ="Chromosome 1")

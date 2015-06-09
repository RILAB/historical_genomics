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
  rounded <-round(chr$basepairs, -5)
  df <- data.frame(chr, rounded)
  dd <- df[order(df$rounded - abs(df$estimate) ), ]
  pp<-dd[ !duplicated(dd$rounded), ]  
})

df <- ldply(chr.list, data.frame)

barplot(df$estimate, col ="blue", ylab = "SNP Effect size",
  main ="All Chromosomes Ordered")

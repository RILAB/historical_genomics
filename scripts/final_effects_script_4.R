# Example following stepwise on single lms and pruning with chromosome 10 and Tassel Length

rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr10.raw.RData")
load("snp.idx10.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("TasselLength.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,11)]
df <- merge(trait, new.chr,  by.x = "Sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx10]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.10 <- lm(trait.vals ~., data=final.df)

summary(model.10)

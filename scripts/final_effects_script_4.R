rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr10.raw.RData")
load("snp.idx10.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,11)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx10]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.10 <- lm(trait.vals ~., data=final.df)

summary(model.10)

save(model.10, file = "chr10_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################
rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr9.raw.RData")
load("snp.idx9.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,10)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx9]

final.df <- data.frame( trait.vals , new.df)

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.9 <- lm(trait.vals ~., data=final.df)

summary(model.9)

save(model.9, file = "chr9_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################

rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr8.raw.RData")
load("snp.idx8.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,9)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx8]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.8 <- lm(trait.vals ~., data=final.df)

summary(model.8)

save(model.8, file = "chr8_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################
rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr7.raw.RData")
load("snp.idx7.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,8)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx7]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.7 <- lm(trait.vals ~., data=final.df)

summary(model.7)

save(model.7, file = "chr7_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################
rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr6.raw.RData")
load("snp.idx6.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,7)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx6]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.6 <- lm(trait.vals ~., data=final.df)

summary(model.6)

save(model.6, file = "chr6_SNPs.RData")

rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr5.raw.RData")
load("snp.idx5.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,6)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx5]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.5 <- lm(trait.vals ~., data=final.df)

summary(model.5)

save(model.5, file = "chr5_SNPs.RData")

rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr4.raw.RData")
load("snp.idx4.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,5)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx4]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.4 <- lm(trait.vals ~., data=final.df)

summary(model.4)

save(model.4, file = "chr4_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################


####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################
rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr3.raw.RData")
load("snp.idx3.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,4)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx3]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.3 <- lm(trait.vals ~., data=final.df)

summary(model.3)

save(model.3, file = "chr3_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################


####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################
rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr2.raw.RData")
load("snp.idx2.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)

rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,3)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx2]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.2 <- lm(trait.vals ~., data=final.df)

summary(model.2)

save(model.2, file = "chr2_SNPs.RData")

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################

####################CHROM_BY_CHROM_DUE_TO_MEMORY######################################
rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr1.raw.RData")
load("snp.idx1.RData")

dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome
traits <- read.table("LeafAngle.txt", header = TRUE, stringsAsFactors = FALSE)
rm(dt)

# Get the chromosome of interest
trait <- traits[,c(1,2)]
df <- merge(trait, new.chr,  by.x = "sample", by.y = "FID")

dim(df)

# In case we want to put the rownames back later following line 29
ind.names <- df[,1]
trait.vals <- df[,2]

new.df <- df[,colnames(df) %in% snp.idx1]

final.df <- data.frame( trait.vals , new.df)

dim(final.df)

model.1 <- lm(trait.vals ~., data=final.df)

summary(model.1)

save(model.1, file = "chr1_SNPs.RData")


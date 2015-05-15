rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7")

load("cut2uniqueAD_NAM_KIDS_chr10.raw.RData")

# These next 3 lines just ensure that there are no columns with NO variation to deal with
dim(dt)
new.chr10 <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr10)

# Need to decide on how to join cols from the NAM traits here, by chromosome

trait <- read.table("TasselLength.txt", header = TRUE, stringsAsFactors = FALSE)

# Get the chromosome of interest
# ALSO, might be really important, whether these SNPs are coded as factors or integers... factors might be better...
trait10 <- trait[,c(1,11)]
df <- merge(trait10, new.chr10, by.x = "Sample", by.y = "FID")

dim(df)

# Define empty vectors
intercept <- NULL
effect.size <- NULL
probability <- NULL
SNP.names <- NULL

# Fit single SNPs to chrom residuals, and pull out diagnostics of interest
for(j in 3:ncol(df)){
        print(j)
        intercept[j] <- coef(summary(lm(df$Chr10 ~ df[,j])))[1]
        effect.size[j] <- coef(summary(lm(df$Chr10 ~ df[,j])))[2]
        probability[j] <- coef(summary(lm(df$Chr10 ~ df[,j])))[8]
        SNP.names[j] <- colnames(df[j])
}
results <- data.frame(SNP.names,intercept, effect.size, probability, stringsAsFactors = FALSE)

# Remove those first two rows - as they are empty
results <- results[-1,]
results <- results[-1,]

# Alpha subset, p-values less than 0.01
sig.results <- subset(results, probability <= 0.01)

x <- as.vector(sig.results$SNP.names)
new.df <- df[,colnames(df) %in% x]

# Add the trait back into this data.frame
step.df <- data.frame(trait10, new.df)

# Remove the sample names for simplicity
step.df1 <- step.df[,-1]
# Stepwise
min.model = lm(Chr10 ~ 1, data  = step.df1)

biggest.model <- formula(lm(Chr10~., data = step.df1))

fwd.model <- step(min.model, direction = 'forward', scope = biggest.model)
summary(fwd.model)

save(fwd.model, "tasselL_chr10_effects.RData")

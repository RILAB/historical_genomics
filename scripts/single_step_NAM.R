rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr9.raw.RData")

# I have checked this - and it turns out that the imputation does add at least
dim(dt)
new.chr9 <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr9)

# Need to decide on how to join cols from the NAM traits here, by chromosome

trait <- read.table("TasselLength.txt", header = TRUE, stringsAsFactors = FALSE)

# Get the chromosome of interest
trait9 <- trait[,c(1,10)]
df <- merge(trait9, new.chr9, by.x = "Sample", by.y = "FID")

dim(df)

# Define empty vectors
intercept <- NULL
effect.size <- NULL
probability <- NULL
SNP.names <- NULL

# Fit single SNPs to chrom residuals, and pull out diagnostics of interest
for(j in 3:ncol(df)){
        print(j)
        intercept[j] <- coef(summary(lm(df$Chr9 ~ df[,j])))[1]
        effect.size[j] <- coef(summary(lm(df$Chr9 ~ df[,j])))[2]
        probability[j] <- coef(summary(lm(df$Chr9 ~ df[,j])))[8]
        SNP.names[j] <- colnames(df[j])
}
results <- data.frame(SNP.names,intercept, effect.size, probability, stringsAsFactors = FALSE)

# Remove that first row - as it is empty
results <- results[-1,]
results <- results[-1,]

# Establish some cut-offs that make sense
prob.adj.fdr <- p.adjust(results$probability, method = "fdr")
prob.adj.bonn <- p.adjust(results$probability, method = "bonferroni")
results <- data.frame(results, prob.adj.fdr, prob.adj.bonn)

# Alpha subset, going with fdr at 0.01, bonnferroni is a chainsaw.
sig.results <- subset(results, prob.adj.fdr<= 0.01)

x <- as.vector(sig.results$SNP.names)
new.df <- df[,colnames(df) %in% x]

x <- as.vector(sig.results$SNP.names)
new.df <- df[,colnames(df) %in% x]

# Add the trait back into this data.frame
step.df <- data.frame(trait9, new.df)

step.df1 <- step.df[,-1]
# Stepwise
min.model = lm(Chr9 ~ 1, data  = step.df1)

biggest.model <- formula(lm(Chr9~., data = step.df1))

fwd.model <- step(min.model, direction = 'forward', scope = biggest.model)
# Write it out
save(fwd.model,file= "fwd.model_chr9_tasselL_fdr01_step.RData")

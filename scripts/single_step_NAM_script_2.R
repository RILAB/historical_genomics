rm(list=ls())

setwd("/group/jrigrp4/Justin_Kate/GBS2.7/imputed_NAM")

load("cut2uniqueAD_NAM_KIDS_chr10.raw.RData")

# Just check to make sure that there are no factors that have empty levels
dim(dt)
new.chr <- Filter(function(x)(length(unique(x))>1), dt)
dim(new.chr)

# Need to decide on how to join cols from the NAM traits here, by chromosome

traits <- read.table("EarHeight.txt", header = TRUE, stringsAsFactors = FALSE)

# Get the chromosome of interest
trait <- traits[,c(1,11)]
df <- merge(trait, new.chr, by.x = "Sample", by.y = "FID")

dim(df)

# Define empty vectors
intercept <- NULL
effect.size <- NULL
probability <- NULL
SNP.names <- NULL

# Fit single SNPs to chrom residuals, and pull out diagnostics of interest
for(j in 3:ncol(df)){
        print(j)
        intercept[j] <- coef(summary(lm(df[,2] ~ df[,j])))[1]
        effect.size[j] <- coef(summary(lm(df[,2] ~ df[,j])))[2]
        probability[j] <- coef(summary(lm(df[,2] ~ df[,j])))[8]
        SNP.names[j] <- colnames(df[j])
}
results <- data.frame(SNP.names,intercept, effect.size, probability, stringsAsFactors = FALSE)

# Remove that first row - as it is empty
results <- results[-1,]
results <- results[-1,]

# Establish some cut-offs that make sense
prob.adj.bonn <- p.adjust(results$probability, method = "bonferroni")
results <- data.frame(results, prob.adj.bonn)

top <- results[order(results$prob.adj.bonn),]

sig.results <- top[1:500,]

x <- as.vector(sig.results$SNP.names)
new.df <- df[,colnames(df) %in% x]


# Add the trait back into this data.frame
step.df <- data.frame(df$Chr10, new.df)

# Stepwise
min.model = lm(df.Chr10 ~ 1, data  = step.df))

biggest.model <- formula(lm(df.Chr10~., data = step.df))

fwd.model <- step(min.model, direction = 'forward', scope = biggest.model)
# Write it out
save(fwd.model,file= "fwd.model_chr10_EarH_500_step.RData")

rm(list=ls())
library(devtools)
library(ggfortify)

snp.df <- read.table("SNPloadR", header=FALSE)
eigenvalues <- read.table("eigenvalueR")
pcs <- read.table("pcs.txt")
ames.idx <- read.table("temp_Ames.txt", header=FALSE)

pcs <- data.frame(ames.idx, pcs)
library(ggplot2)


# Scores plot of the first two principal components
scores = pcs

ggplot(data = scores, aes(x=V1.1, y=V2, label = rownames(scores))) +
    geom_hline(yintercept = 0, colour = "gray65") +
    geom_vline(xintercept = 0, colour = "gray65") +
    geom_text(colour = "steelblue", alpha = 0.8, size = 4)  


scores <- scores[,-1]
k <- kmeans(scores, 6, nstart=25, iter.max=100000)
autoplot(kmeans(scores, 6), data = scores)
library(RColorBrewer)
library(scales)
palette(alpha(brewer.pal(9,'Set1'), 0.5))
plot(scores, col=k$clust, pch=16)
ggplot(data=scores, aes(x=V1.1, y=V2)) +
geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_point(colour = k$clust, alpha = 0.6, size = 3) + 
  xlab("First principal component axis") + ylab("Second principal component axis")

# Make a new data.frame
df <- data.frame(ames.idx, k$cluster, scores)

# And divide the population clusters up
pop1 <- subset(df, k.cluster == 1)
pop1 <- pop1[,1]
pop2 <- subset(df, k.cluster == 2)
pop2 <- pop2[,1]
pop3 <- subset(df, k.cluster == 3)
pop3 <- pop3[,1]
pop4 <- subset(df, k.cluster == 4)
pop4 <- pop4[,1]
pop5 <- subset(df, k.cluster == 5)
pop5 <- pop5[,1]
pop6 <- subset(df, k.cluster == 6)
pop6 <- pop6[,1]

# Write these out for Bayenv

write.csv(pop1, file="cluster1.csv")
write.csv(pop2, file="cluster2.csv")
write.csv(pop3, file="cluster3.csv")
write.csv(pop4, file="cluster4.csv")
write.csv(pop5, file="cluster5.csv")
write.csv(pop6, file="cluster6.csv")

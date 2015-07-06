rm(list=ls())
library(plyr)
library(stringr)
setwd("~/bayenv_test")

files <- list.files("~/bayenv_test", "*.frq", full.names = TRUE)

cluster.list <- lapply(files, function(cluster) {

        cluster <- read.table(cluster, header = T,
        colClasses=c('factor', 'numeric', 'character', 'numeric', 'character', 'character'),
        fill = TRUE, sep ="\t", row.names=NULL)

        major <- cluster[,5]
        minor <- cluster[,6]
        N_CHR <- cluster[,4]
        POS <- cluster[,2]
        CHROM <- cluster[,1]
        
        major <- str_replace(major, "C:", "")
        major <- str_replace(major, "A:", "")
        major <- str_replace(major, "T:", "")
        major <- str_replace(major, "G:", "")
        major <- str_replace(major, "N:", "")

        major<-as.numeric(major)

        minor <- str_replace(minor, "C:", "")
        minor <- str_replace(minor, "A:", "")
        minor <- str_replace(minor, "T:", "")
        minor <- str_replace(minor, "G:", "")
        minor <- str_replace(minor, "N:", "")

        minor[is.na(minor)] <- 0
        minor <- as.numeric(minor)

        sfs <- data.frame(N_CHR, major, minor, POS, CHROM)
        #By chromosome subset round the positions to the nearest 100 thousandth bp
        rounded <- round(sfs$POS, -4)
        #Add this to the dataframe
        sfs <- data.frame(sfs, rounded)
        #And just choose the first value - not quite random, but it works for cov. creation
        sfs.1 <- sfs[!duplicated(sfs$rounded),]
        
        ind.major <- (sfs.1[,1] * sfs.1[,2])/2
        ind.major <- round(ind.major, digits = 0)

        ind.minor <- (sfs.1[,1] * sfs.1[,3])/2
        ind.minor <- round(ind.minor, digits = 0)

        df <- data.frame(ind.minor, ind.major)

        df.T <- t(df)

        df.T <- as.data.frame.table(df.T)

        x <- t(df.T[,3])

        pop.all.snps.counts <- t(x)
})

# Break them up
df1 <- ldply(cluster.list[1], data.frame)
df2 <- ldply(cluster.list[2], data.frame)
df3 <- ldply(cluster.list[3], data.frame)
df4 <- ldply(cluster.list[4], data.frame)
df5 <- ldply(cluster.list[5], data.frame)
df6 <- ldply(cluster.list[6], data.frame)
# Put them back together as a data.frame for bayenv

bayenv.df <- data.frame(df1, df2, df3, df4, df5, df6)
bayenv.snps.mat <- as.matrix(bayenv.df)
bayenv.snps.mat <- matrix(bayenv.snps.mat, ncol = ncol(bayenv.df), dimnames = NULL)


write.table(bayenv.snps.mat, "bayenv_SNPsfile_6clusters_less_LD", sep = "\t")

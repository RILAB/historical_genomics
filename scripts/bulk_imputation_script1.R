rm(list=ls())
setwd("/group/jrigrp4/Justin_Kate/GBS2.7")
library(data.table)

files <- list.files("/group/jrigrp4/Justin_Kate/GBS2.7", pattern = "cut2uniqueAD_NAM_KIDS_chr*")

lapply(files, function(x) {

dt <- fread(x, header = TRUE, na.strings = "NA", stringsAsFactors=TRUE)

dim(dt)

dt <- Filter(function(zz)(length(unique(zz))>1), dt)

dt <- data.frame(dt)

for(i in 2:ncol(dt))
        {
        print(i)
        probs<-c()
        probs[1]<-length(which(dt[,i]==0))/length(which(is.na(dt[,i])==F))
        probs[2]<-length(which(dt[,i]==1))/length(which(is.na(dt[,i])==F))
        probs[3]<-length(which(dt[,i]==2))/length(which(is.na(dt[,i])==F))
        replace <- sample(c(0,1,2),length(which(is.na(dt[,i])==T)),replace=T,prob=probs)
        dt[which(is.na(dt[,i])==T),i] <- replace
        }

        save(dt, file=paste(x, sep="", ".RData"))
})

rm(list=ls())

library(data.table)

zea.gbif <- read.csv(file = "Zea_GRIN.csv", header = T, stringsAsFactors=F)

amesHowie <- read.csv(file = "ameshowiejustames.csv", header = T, stringsAsFactors=F)


zea.gbif.T <- data.table(zea.gbif)
amesHowie.T <- data.table(amesHowie)
setkey(zea.gbif.T, accenumb)
setkey(amesHowie.T, accenumb)
zea.gbif.T[amesHowie.T, roll=T]

# Write out if you want - to check

# write.csv(new.T, "amesgbif.csv")

# Looks ok!
rm(list=ls())

library(data.table)

zea.gbif <- read.csv(file = "Zea_GRIN.csv", header = T, stringsAsFactors=F)

amesHowie <- read.csv(file = "ameshowiejustames.csv", header = T, stringsAsFactors=F)


zea.gbif.T <- data.table(zea.gbif)
amesHowie.T <- data.table(amesHowie)
setkey(zea.gbif.T, accenumb)
setkey(amesHowie.T, accenumb)

# Joins tables - GBIF on left, Howie's on right by accession number
new.T <- zea.gbif.T[amesHowie.T, roll=T]

# Write out if you want - to check

# write.csv(new.T, "amesgbif.csv")

# Looks ok!

# Make a smaller table or df of "useful fields" side by side with Howie's
# Accession numbers from GBIFs with Howie's, GBIF ancestry with Howie's parentage
# Year released with year released
useful.df <- data.frame(new.T$Seq, new.T$accenumb, new.T$Accesion.N, new.T$ancest,new.T$P1A, new.T$P2A, new.T$released, 
	new.T$Year.Rel, new.T$history, new.T$remarks,)
# Get an array of complete cases for Ames_howie.csv
# Note this isn't the complete list of things


amesH <- read.csv("Ames_howie.csv", header =T, stringsAsFactors = F)
amesGBS <- read.csv("AmesGBSlist.csv", header = T, stringsAsFactors = F)
# import the zea GRIN dataframe - includes more than just Zea mays

# load libraries
library(stringr)
library(data.table)


# Now start the joining of the two datasets based on inbred line and name

amesGBS.T <- data.table(amesGBS)
amesH.T <- data.table(amesH)
setkey(amesGBS.T, Inbred.name)
setkey(amesH.T, Inbred.Line)

new.T <- amesH.T[amesGBS.T, allow.cartesian=T]



new.DT <- subset(new.T, select = c(GBS.name..Sample.Flowcell.Lane.Well., 
                                   Inbred.Line, Accession, 
                                   Year.Rel, P1A, P2A, Ped_line, Pop.structure))

write.table(new.DT, "new.DT.txt",sep ="\t")
write.csv(new.DT, "new.DT.csv")
# Now join the GBS to new.T
# import the pedigree dataframe of interest
grin.all <- read.csv("GRIN.csv", header = T, stringsAsFactors = F)

# replace the spaces in GRIN 
accenumb <- grin.all$accenumb

accenumbPI <- str_replace(accenumb, "I ", "I")
accenumbMBG<- str_replace(accenumbPI, "S ", "S")
accenumbAmes <- str_replace(accenumbMBG, "s ", "s")
accenumbNSL <- str_replace(accenumbAmes, "L ", "L")

Accession <- accenumbNSL

grin.new <- data.frame(grin.all, Accession, stringsAsFactors = F)
# Now start the joining of the two datasets based on Accession

grinDT <- data.table(grin.new)
setkey(new.DT, Accession)
setkey(grinDT, Accession)

all.DT <- grinDT[new.DT, roll=T, allow.cartesian=T]

# New dataframe
all.DT <- subset(all.DT, select=c(Year.Rel, released, Accession, Inbred.Line, Inbred.name,
                                  GBS.name..Sample.Flowcell.Lane.Well., P1A, 
                                  P2A, ancest, history, Pop.structure, remarks))

write.table(all.DT, "all_DT.txt", sep = "\t")
write.csv(all.DT, "all_DT.csv")
# Get complete cases
compHowie.GRIN.GBS <- all.DT[complete.cases(all.DT),]




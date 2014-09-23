
# import the zea GRIN dataframe - includes more than just Zea mays
grin.all <- read.csv("GRIN.csv", header = T, stringsAsFactors = F)

# import the pedigree dataframe of interest
amesWyears <- read.csv("ames_withyears.csv", header = T, stringsAsFactors = F)


# load libraries
library(stringr)
library(data.table)

# replace the space in GRIN 
# accession number so that it matches pedigree csv Accesion.N or whatever field

accenumb <- grin.all$accenumb

accenumbPI <- str_replace(accenumb, "I ", "I")
accenumbMBG<- str_replace(accenumbPI, "S ", "S")
accenumbAmes <- str_replace(accenumbMBG, "s ", "s")
accenumbNSL <- str_replace(accenumbAmes, "L ", "L")

# Rename that new vector so that it matches pedigree files - 
# there still a few ones with weird spaces, can change later
Accesion.N <- accenumbNSL

# New dataframe
grin.new <- data.frame(grin.all, Accesion.N, stringsAsFactors = F)

# Now start the joining of the two datasets

zea.grin.T <- data.table(grin.new)
amesWyears.T <- data.table(amesWyears)
setkey(zea.grin.T, Accesion.N)
setkey(amesWyears.T, Accesion.N)

new.T <- zea.grin.T[amesWyears.T, roll=T]

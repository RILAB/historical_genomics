
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

accenumbKate <- accenumbNSL

grin.new <- data.frame(accenumbKate, grin.all)


str_replace(accenumb, )


# rename the GRIN field accenumb
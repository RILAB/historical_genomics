rm(list=ls())


library(rgbif)

####################################
#Get species key
####################################
key <- name_backbone(name = "Zea mays", kingdom = "plants")$speciesKey
key

#####################################################################################
# Number of Zea mays records using occ_count
######################################################################################

occ_count(taxonKey = 5290052)


####################################################################################
# Get all of the data with occ_search - I put limits here, because otherwise
# it takes a long time, i.e. if you put the count as the limit
# I also limited the fields in the second one - this is pretty straight up
# from the rgbif tutorial
####################################################################################


corn <- occ_search(taxonKey = key, return = "data", limit = 85099, 
                        fields="all")

corn <- occ_search(taxonKey = key, return = "data", limit = 100, 
                        fields=c("name", "latitude", "longitude", "country",
                                 "county", "locality", "occurrenceDate", "altitude"))


summary(corn)

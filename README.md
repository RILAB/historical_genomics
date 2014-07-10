historical_genomics
===================

## Pedigree Files

#### Ames_pedigrees352014.numbers
All of Howie's data.  This includes the "Jeff_Inbred_pedigree-Howie2.xlsx" datafile as well, and may include some duplicates.

#### Crop Sci Schaefer and Bernardo Suppl Table.numbers
Pedigree data from Minnesota inbreds, thanks to Rex Bernardo

#### CMLs-Information 1-539.CZ.20140312-2.xls
Pedigree data for CIMMYT CML lines

## Genotype Data

[GBS](http://www.panzea.org/lit/data_sets.html#genos) data from Ames and all Zea.

Probably not worth going back to 55K data.

Should be able to impute Hapmap3 on all of the GBS data where possible.

## Analysis strategy


#### BAYENV2

Run Beynv2 on data, similar to [van Heervaarden 2012](http://www.pnas.org/content/109/31/12420.abstract)

Improvements on 2012 paper:

* More loci
* Separate analyses within individual heterotic groups

Plan:

Run BAYENV2
Try Birth-death mapping approach as well

#### Genome Scan

Look for changes in diversity, Fst, iHS

Progress: 

* Basic diversity up and running currently across all Ames data

Plan:

* Need to get iHS, Fst working
* Run on imputed data
* split by time/heterotic group

#### Pedigree Analysis

Track IBD regions down pedigree.  Ask whether haplotypes are more common than expected given pedigree, compare to recombination rate.

Progress:

* Pedigree
* IBD done across all Ames
* HapMap3 imputation on Ames underway

Plan:

* More Pedigree data from Pioneer?
* Check/add to pedigree from relatedness data

More Pedigree GBIF/GRIN (mostly GRIN) stuff and table joins
-----------------------------------

## This is Kate joining big tables from GRIN to the smaller .csvs ["pedigree_files"] (https://github.com/RILAB/historical_genomics/tree/master/pedigree_files)

### Steps get data from GRIN and GBIF

1. Go to search plant germplasm [GRIN] (http://www.ars-grin.gov/npgs/searchgrin.html)
2. Click ["Download Data in FAO MPCD format"] (http://www.ars-grin.gov/~dbmuqs/cgi-bin/mcpd_gen.pl)
3. Searched for "Zea"
4. Obtained and downloaded over 45k of records - this is the [GRIN.csv] (https://github.com/RILAB/historical_genomics/blob/master/Zea_GRIN_now_with_better_data/GRIN.csv)
5. Steps to get the gbif data are explained in the first go around [here] (https://github.com/RILAB/historical_genomics/blob/master/gbif_zea/get_zea_records.R)
6. GBIF gives you 85k records, but is mostly __"trash-binny"__ and the accession numbers are weird

### Steps to join both tables

As an example: see [dataJoin.R] (https://github.com/RILAB/historical_genomics/blob/master/Zea_GRIN_now_with_better_data/dataJoin.R)

- This basically adds information on Year Released to a number of the accessions in the pedigree file
- I'll throw the rest of them up in a bit, the internet (satellite) is a tad slow and the .csvs from GRIN and GBIF are large

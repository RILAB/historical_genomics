Pedigree GBIF/GRIN stuff and table joins
-----------------------------------

## Some of the stuff I did here is not entirely reproducible (my bad), I'll note these steps here.

1. I took the 'Ames_Howie.csv' file and subsetted it to contain only Accession numbers with the name 'Ames#'
2. I added a space in excel (bad) to this .csv to a new column named accenumb so it would match the format output by GBIF, and actually __I just realized that this is combination of GBIF and GRIN files I merged back in July - eeeek - and did not even note down - more eeek__. Good news - both are 'gettable' again, will just have to re-merge and parse.
3. I read both csvs into R - the one from GBIF/GRIN and the new subsetted space added AmesHowie csv. 
4. Use handy data.table library in R to do table joins and made new dataframes, tables - renamed 'amesgbif.csv'.
	- That's basically just all of the data joined together side-by-side using accession numbers as the key
	- Howie's columns are title-cased (right side), gbif's are lower case to make it a bit easier (left side)

## Some things that are interesting to note or ask Howie about

1. GBIF/GRIN has some interesting fields that may clarify parentage and ancestry these are named:
	- ancest (mostly pedigree information)
	- othernumb (occasionally pedigree information in weird notation)
	- remarks (phenotypes on occasion, and other neat stuff)
	- history (parentage, ancestry, sometimes year released)
	- released (year released)

2. Some example accessions of interesting things in amesgbif.csv:
	- Ames22443 released in 1946 (according to gbif/GRIN - this is new information): parentage under gbif is 4-29(Silver King) x 46(N.W. Dent)4^4 
	- othernumb column for Ames22443 appears to contain __different pedigree?___ information which matches Howie's - just in a weird format
	- __Lots of GEMS/Ames inbreds with weird pedigree information in gbif ancest__ column, e.g. Ames27205 has CUBA164:S2008a-326-1-B
	- Remarks for Ames27205: 'A parent of GEMS-0052 is CUBA 164 which is PI 489361.  It is a Cuban accession that was identified as one of the LAMP (Latin American Maize Project) collections performing in the top 5%.'
	-There are more examples of this sort of thing, plus GBIF adds some more information on year released.

3. What is GEMS - what does this stand for?
	[Germplasm Enhancement of Maize](http://www.public.iastate.edu/~usda-gem/)

	


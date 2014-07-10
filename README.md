#Historical Genomics of US Maize

## Pedigree Files

**Ames_howie.csv**  
All of Howie's data.  This includes the "Jeff_Inbred_pedigree-Howie2.xlsx" datafile and "Ames_pedigrees352014" as well, and may include some duplicates.

**Minn.csv**  
Pedigree data from Minnesota inbreds, thanks to Rex Bernardo, from Chris Schaefer PhD thesis, original file is Crop Sci Schaefer and Bernardo Suppl Table.xls

**kernel_panel.csv**  
Panel from [Li et al. 2012](http://www.nature.com/ng/journal/v45/n1/full/ng.2484.html) with pedigree data.

**CML.csv**  
Pedigree data for CIMMYT CML lines. Original excel is CMLs-Information 1-539.CZ.20140312-2.xls

**ames_withyears.csv**  
Anne's efforts at getting years from GRIN, but their data is not so hot.

**ames_10neighbors.csv**  
10 closest neighbors based on IBS for Ames panel. Can use to cross-reference against pedigree. Data from [Romay 2013](http://genomebiology.com/2013/14/6/R55/)

## Genotype Data

[GBS](http://www.panzea.org/lit/data_sets.html#genos) data from Ames and all Zea.

Probably not worth going back to 55K data.

Should be able to impute Hapmap3 on all of the GBS data where possible.

Progress:

* Hapmap3 imputation underway

## Analysis strategy

#### BAYENV2

Run [Bayenv2](http://gcbias.org/bayenv/) on data, similar to [van Heervaarden 2012](http://www.pnas.org/content/109/31/12420.abstract)

Improvements on 2012 paper:

* More loci
* Separate analyses within individual heterotic groups

Plan:

* Run BAYENV2
* Try [Birthdate mapping](http://www.biomedcentral.com/1471-2164/13/606) approach as well? Ask Jared Decker to do for us.

#### Genome Scan

Look for changes in diversity, Fst, iHS

Progress: 

* Basic diversity up and running currently across all Ames data

Plan:

* Need to get iHS, Fst working
* Run on imputed data
* split by time and heterotic group

#### Pedigree Analysis

Track IBD regions down pedigree.  Ask whether haplotypes are more common than expected given pedigree, compare to recombination rate.

Progress:

* Pedigree information for lots of inbreds from Howie, CMLs, and Minnesota
* IBD done across all Ames
* HapMap3 imputation on Ames underway
* Anne did time/year for ~800 lines but from GRIN where data is usually when they got the accession not when registered

Plan:

* More Pedigree data from Pioneer?
* Check/add to pedigree from relatedness data
* Need better year/time data
* Scan for segregation distortion along genome, check for evidence of selection on those haplotypes (longer than expected, etc.)

#### SQuaT

Run [SQuaT](https://github.com/jjberg2/PolygenicAdaptationCode) on Ames genotpye data, looking for evidence of selection on individual traits over time.

Note this is perhaps method of most interest for Pioneer, as it suggests where breeding has been successful and can identify traits that nobody thought were under selection.

Berg may be willing to help us incorporate similarity of structure between GWAS panel and lines of interest.  Essentially lines of interest projected onto PCs of GWAS panel should be term in the model.

Progress:

* Beissinger getting method working for 282/landraces

Plan:

* Identify GWAS panel and traits of interest, run.
* Try multiple GWAS panels of same trait to see how results differ?

### Questions

Of interest to run analyses on more closed systems (e.g. Minnesota material, McMullen BSSS material, etc.?)

What GWAS panel doesn't cause big problems for structure for SQuaT? Are there landrace panels?

Do we need time data? Perhaps instead we want distance down pedigree? Do we have enough lines (and/or confidence) to divide into decades?

We have CML pedigree data.  Probably GBS too.  Include these?

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

## Genotype and Phenotype Data

[GBS](http://www.panzea.org/lit/data_sets.html#genos) data from Ames and all Zea.

Probably not worth going back to 55K data.

Should be able to impute Hapmap3 on all of the GBS data where possible.

SEEds? What data was used for hybrid gwas?

Progress:

* Hapmap3 imputation underway

Phenotype data:

| Code | description |
| --- | --- |
| PLHT	| plant height |
| DMC | dry matter content at harvest |
| DMY | dry matter yield |
| DTS | days to silking |
| DTA | days to anthesis |


## Analysis strategy
### Detecting Selection
The planned analyses can be divided into two approaches. 1) Detecting selection on single loci and 2) detection of polygenic selection on a phenotype. The single and polygenic approaches can be further divided by the type of null model used
##### Sinle locus vs polygenic
Both **single locus** and **polygenic** approaches can be used. Single locus approaches will test for outlier SNPs relative to a background distribution. Polygenic approaches will test if SNPs associated with a specific phenotype are more strongly correlated than expected based on the genomic background. Although the polygenic approach is better suited to detect selection on complex traits, it requires association with a phenotype, whereas a single locus approach does not. 
##### Null model
For both single and polygenic approaches, the null expectation can be determined either by modeling mendelian segregation through the **pedigree** or by correcting for population structure by modeling the covariance among populations using a **multivariate normal** distribution (MVN). The MVN approach can include individual with uncertain or unknown pedigree information, but will likely be more sensitive to population structure than a pedigree approach.

With this way of thinking, the analyses can be divided into quadrants:

|Loci/Null | Pedigree | MVN |
|||
| **Single Locus** | allele dropping | [Bayenv2](http://gcbias.org/bayenv/) |
| **Polygenic** |  MEBV analysis| [SQuaT](https://github.com/jjberg2/PolygenicAdaptationCode)|

### GWAS

The polygenic methods rely on effect size estimates of SNPs for the trait of interest. For the SQuaT approach, this must be done using a GWAS approach.  Although the [NAM](insert link) population contains less than 30 founders, it will probably provide the most robust data due to the large number of individuals phenotyped within each family. However the half-sib structure of NAM requires a non-standard approach to GWAS that is different from a more conventional mixed model approach.

## Stepwise OLS on NAM trait residuals
With respect to stepwise forward regression on the chromosome residuals of a trait from Wallace et al. 2014, I am running into several problems. First, with respect to memory being exceeded in a variety of R packages, biglars, lars, biglm. I also realized that when p>>n, you'll only get good estimates of predictors, but not their effect sizes with lars and lasso methods.

If the NAM chromosome residuals already incorporate major effect QTL, then we ought to be able to just do regular GWAS, but there's the issue of relatedness and n goes to 14, due to NAM progeny being a set of half-sib families (special GWAS- above). One thing I don't understand here is the residual after a QTL study is noise, environment? **Not sure how we are getting SNP effect sizes (additive ones) from this analysis, or if they can be trusted. Is the idea that these might be SNPs of small effect?** 

Should we just do RMIP in tassel? Should I just randomly sample n=1000 SNPs at a time, and do OLS/GWAS on these without stepwise? 

Finally, I could write a painful for loop in R, that stops when AIC stops decreasing.

### MEBV Analysis

This is the polygenic version of allele dropping. An MEBV for a trait of interest will be calculated for each individual with allele effects determined by an association panel. Throughout the pedigree, selection on the trait can be calculated by deviation of MEBVs from midparent values.

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

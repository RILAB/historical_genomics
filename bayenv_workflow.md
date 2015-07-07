## Bayenv2 workflow with modern maize data (KC)
Eventually, this will be expanded to individuals with release dates within a heterotic group. But for now, we'll stick with loose heterotic groups.

- First run PCA (use k-means for now to determine a rough number of groups or some threshold based on StDev). 
- Next pull those indices from the PCA script from a vcf file (vcftools).
- For each vcf file made, get the frequencies of the alleles (vcftools).
- Amend the header of each of the 6 heterotic group files
- Run this [R script](https://github.com/RILAB/historical_genomics/blob/master/make_allele_frq_bayenv.R) - note this script deals with LD in kind of a half-assed way (so you may need to check that later)

Now with the output, do the following in bash (because Bayenv is really THAT PARTICULAR ABOUT INPUTS):

- Remove the header:
```
tail -n+2 file > output
```
- Remove the first column:

```
awk 'BEGIN{FS=OFS="\t"}{$1="";sub("\t","")}1'  input > output
```

- **Add a tab to the end of each line** because otherwise Bayenv will not compute the covariance matrix (you will get a near silent error)

```
awk '{printf("%s\t \n", $0)}' input > output
```

This last output is your SNPsfile - so called - in the BAYENV manual.

Bayenv will throw a tantrum if any of your rows have fixed alleles in it, e.g.

0 0 0 0 0 0

4 89  8 23  14

For 6 pops, that first line is not acceptable.

And run on 6 heterotic groups first
```
bayenv2 -i SNPsfile -p 6 -r $RANDOM -k 100000 > matrix.out
```

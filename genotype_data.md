###SNP sets

####Maize Hapmap 3

Ames Data: 
- list of names of Ames data here:
```
/group/jrigrp4/Justin_Kate/hmp31/hmp31_ames_imputed.txt
```

NAM Founders: 
- list of NAM parents/founders here:
```
/group/jrigrp4/Justin_Kate/hmp31/taxa_list_founders37.txt
```

NAM RILs: as far as I can tell there are no NAM RILS imputed from HMP v. 3.1 just for GBS 2.7

###GbS 2.7

Metadata:     
```
/group/jrigrp4/Justin_Kate/GBS2.7/AllZeaGBSv2.7_public.csv
```

Raw data (NAM and AMES and other):
```
/group/jrigrp4/Justin_Kate/GBS2.7/AllZeaGBSv2.7_publicSamples_imputedV3b_agpv3.hmp.gz
```

Script to sort raw data:    
```
/group/jrigrp4/Justin_Kate/GBS2.7/sort_export.sh
```

Sorted data (NAM and AMES and other):       
```
/group/jrigrp4/Justin_Kate/GBS2.7/sortedGBS.hmp.txt
```

Script to generate lists of entries from the projects:     
```
/group/jrigrp4/GBS2.7/scripts/get_list_GBS.R
```

Combined list of NAM and AMES entries:    
```
/group/jrigrp4/GBS2.7/keep_list.txt
```

List of Ames entries here:    
```
/group/jrigrp4/GBS2.7/keep_list_Ames.txt
```

##Scripts
For the **hapmap 3.1** data in 
```
/group/jrigrp4/hmp31
```
There are 2 scripts - one to convert and filter missinginess of the hmp31 ames data "missing_ames.sh" and the other to run flashpca. The main issue with the data at present is that not much open source software will handle hdf5.

For the **GBS 2.7** data in
```
/group/jrigrp4/Justin_Kate/GBS2.7/
```
There is one script 'ames_sort_export.sh' that will sort the GBS data, convert to plink (keeping only the Ames accessions), downsize to binary plink, and run flashpca. 

## FLASHPCA RESULTS
**JUSTIN** results for the flashpca with GBS 2.7 are in the
```
/group/jrigrp4/Justin_Kate/GBS2.7/flashpca_results/
```
There should be 5 files in there. I performed this only on the 'keep_list_Ames.txt' - if you want to do NAM, you can, but not sure why you would want to. For further options with respect to [flashpca link is here](https://github.com/gabraham/flashpca)

##GWAS with the NAM children/progeny 
The script 'get_NAM_children' gets the data all wrangled into some agreeable format to do GWAS with the NAM Wallace residuals.

This script is in:
```
/group/jrigrp4/Justin_Kate/GBS2.7/scripts
```

But what the script does is this:

```
run_pipeline.pl -Xmx64g -fork1 -h sortedGBS.hmp.txt -includeTaxaInfile keep_list_NAM_children.txt -export -exportType VCF -runfork1


Call vcftools and then make everything biallelic because we really don't have time for much else

gzip *.vcf

~/bin/vcftools_0.1.12b/bin/vcftools --gzvcf sorted_NAM_children.vcf.gz --min-alleles 2 --max-alleles 2 --recode --out biallelic_NAM_children

# Cut the header
sed '11q;d' biallelic_NAM_children.recode.vcf > header.vcf

# Get the lines before the header
sed '1,10!d' biallelic_NAM_children.recode.vcf > first.vcf

# Get lines below the header
sed -e '1,11d' biallelic_NAM_children.recode.vcf > last.vcf

# transpose the header and awk and transpose again
cat header.vcf | tr '\t' '\n'| awk -F":" '{print $1}'| tr '\n' '\t' > middle.vcf

# Middle.vcf has no line ending so add one
sed -i -e '$a\' middle.vcf

# Put it all back together as one vcf file
cat first.vcf middle.vcf last.vcf > GWAS_NAM.vcf

# Convert this biallelic output back to plink
# Convert to plink binary, and exclude the SNPs that are not on any chromosome

~/bin/vcftools_0.1.12b/bin/vcftools --vcf GWAS_NAM.vcf --plink --out GWAS_NAM_plk

plink --file GWAS_NAM_plk --make-bed --chr 1-10 --out GWAS_NAM_bplk
# IT WORKS!!! Then take this file to GCTA and compute the GRM, do GWAS on NAM children
```

## Fitting simple single lms to NAM trait chrom residuals (Wallace et al. 2014) 

Forward stepwise on the raw is not possible/probable (memory issues). A new gist with example data as to how to do that using the output from plink. The gist is [here.](https://gist.github.com/kate-crosby/d4c4f0c5f727bcf6366f)


## To do list Kate/Justin
1. OLS on NAM trait residuals - ~~awaiting Tassel help, but also trying in R~~ ~~**UPDATE USING GCTA** **KATE**~~ UPDATE KATE NOW JUST DOING IT STRAIGHT UP DIRTY IN R
2. PCA - compute Tracy-Widom statistics **JUSTIN** **FLASHPCA done, awaiting T-W stats on largest eigenvalue** 
3. Missing data from Hmp 3.1 for Ames **KATE** **THIS IS RUNNING STILL - files are super big**
4. Run Qx, win the day **TBD**
5. Do allele dropping single with missing hmp 31 and no missing on multiple loci hmp31 **KATE**

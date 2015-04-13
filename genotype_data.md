
###SNP sets

####Maize Hapmap 3

Ames Data: 
- list of names of Ames data here:
```
/group/jrigrp4/hmp31/hmp31_ames_imputed.txt
```

NAM Founders: 
- list of NAM parents/founders here:
```
/group/jrigrp4/hmp31/taxa_list_founders37.txt
```

NAM RILs: as far as I can tell there are no NAM RILS imputed from HMP v. 3.1 just for GBS 2.7

###GbS 2.7

Metadata:     
```
/group/jrigrp4/GBS2.7/AllZeaGBSv2.7_public.csv
```

Raw data (NAM and AMES and other):
```
/group/jrigrp4/GBS2.7/AllZeaGBSv2.7_publicSamples_imputedV3b_agpv3.hmp.gz
```

Script to sort raw data:    
```
/group/jrigrp4/GBS2.7/sort_export.sh
```

Sorted data (NAM and AMES and other):       
```
/group/jrigrp4/GBS2.7/sortedGBS.hmp.txt
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
```/group/jrigrp4/hmp31
```
There are 2 scripts - one to convert and filter missinginess of the hmp31 ames data "missing_ames.sh" and the other to run flashpca. The main issue with the data at present is that not much open source software will handle hdf5.

For the **GBS 2.7** data in
```/group/jrigrp4/GBS2.7/
```
There is one script 'sortexport.sh' that will sort the GBS data, convert to plink (keeping only the Ames accessions), downsize to binary plink, and run flashpca. **JUSTIN** it will email you when it is finished.


## To do list Kate/Justin
1. OLS on NAM trait residuals - awaiting Tassel help, but also trying in R **KATE**
2. PCA - compute Tracy-Widom statistics **JUSTIN**
3. Missing data from Hmp 3.1 for Ames **KATE** 
4. Run Qx, win the day **TBD**
5. Do allele dropping single with missing hmp 31 and no missing on multiple loci hmp31 **KATE**

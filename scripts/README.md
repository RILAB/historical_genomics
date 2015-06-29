## A brief description scripts in this folder

1. Run the bulk imputation on the NAM children - script 1
2. Next run the single SNP lms on all traits in the NAM progeny - script 2
3. Run the filter SNP effects script to choose SNPs within a given window for the smallest p-value
4. Finally, run the final SNP effects script - script 4 to recalculate effects
5. Run script5.R to subset out all the SNPs that are over p = 0.05 (should you want).

Most of these are a tad bulky and violate DRY, apologies. Will streamline more when there is time. 

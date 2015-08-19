* The allele frequencies are the frequencies of allele A1
* The effects are the substitution effects of replacing A2 with A1.

## Task: Getting the NAM allele frequencies

# Important files

For these files, both Kate and I keyed off of SNP ID, which are based on genome v2 coordinates. This means we can use the ID's to match with Krug positions, which are also

## Get the alleles Kate mapped onto NAM
The file with all NAM child frequencies is : `./data/Namfreqs/NAMkids_frequencies.frq`. This was calculated from vcftools.

I have another file, which contains the positions used in the GWAS:
The file is: `./data/Namfreqs/GWAS_SNPs.txt`

This file was created by running `./scripts/allelefreqs.R`. I originally used this code to output imputed allele frequencies for the NAM kids, but now just used it to print out the SNP names.

## Get the allele frequencies specifically of the GWAS SNPs.

I build the allele frequencies of all biallelic snps in `NAMkids_frequencies.frq` using `./scripts/check_nam_alleles.py`. This resulted in the file:

        namfreqdict.pkl

One issue was that the vcf output had the v3 positions.  To get the v2 positions, I pulled the SNP names out of the original vcf file using `./scripts/getalleles.sh` and storing them in the file `./data/Namfreqs/alleleconverstions.txt`

Next, I needed to pull out the alleles for the SNP sites present in `GWAS_SNPs.txt`. I did this using './scripts/built_namallele.py` which results in the file:

        nam_genome_file.csv


## Get the overlap with Krug

Now this needs to be joined with the krug SNPs. This was done using `./scripts/krug_nam_overlap.rmd`. There are around 20k overlapping SNPs. Not a lot to go on. the overlaps are output here:

        ./data/NAM_freqs_olap_krug.csv
        ./data/Krug/freqs_olap.csv

## Make sure the two datasets have the same alleles!
Next, I need to figure out if the allele tracked in NAM is the allele tracked in Krug.

This was done with:

        ./scripts/krug_nam_alleles.py

Results:  out of `23178` SNPs, the allele tracked in Krug is one of the two alleles in NAM in `23018` of the caes.  These will be the SNPs to go forward with. The output files are:

        ./data/nam_olap_krug_biallelic.csv
        ./data/krug_olap_biallelic.csv

## Make the files formatted for Qx

done with: `./scripts/makefiles.R`
This code can be modified for alternative traits or SNP sets.

## Run the PA script
Berg's code, with Tim's modification (and a couple of my own) is located in this repo as a subtree.

The run was executed using using the file: `./PolygenicAdaptationScript/Run_Files/kwt_runfile.R`

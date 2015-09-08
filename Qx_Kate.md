## How Kate makes Berg and Coop input files for Qx

Make the GWAS files first...note the underscore allele in this file IS the MINOR allele.. technically you could run through the whole SNP effects for all traits for NAM with a list function and do.call after. This is one example.
```R
load("SNP_effects_ordered_Leaf_Angle.RData")

df <- df[,1:2]

write.table(df, "LeafAngle", row.names = FALSE)

```

Quit R.

Open in Vim. 
```vim
:%s/"//g

Add a tab anywhere there is a space.

:%s/ /^I/g

And separate out the base that is the MINOR allele.
:%s/_C/^IC/g
:%s/_T/^IT/g
:%s/_A/^IA/g
:%s/_G/^IG/g
```
Retitle the header. Exit vim.

Next do a unix join with the NAMfreqs.txt file - which is just the NAM_allfreqs.csv tab delimited.

Remove the headers of both files and sort them. Now join them.


```bash
sort LeafAngle > sortedLeafAngle
sort NAM_allfreqs.txt > sortedNAM_allfreqs.txt
join -1 1 -2 1 sortedLeafAngle sortedNAM_allfreqs.txt > intermediatefile
```

Now with awk just make the output you need. 

```bash
awk 'BEGIN {OFS="\t"}; {print $1,$4,$5,$3,$6}' intermediatefile > gwas.data.file
```

Ok, that's the first Qx file. 1 down four to go.

# Next make the fulldatasetfile for each cluster - split into 2 groups "late" and "early"

```bash
~/bin/vcftools_0.1.12b/bin/vcftools --vcf cluster2.recode.vcf --keep early_names_cluster2_Qx --recode --out early_cluster2
~/bin/vcftools_0.1.12b/bin/vcftools --vcf cluster2.recode.vcf --keep late_names_cluster2_Qx --recode --out late_cluster2


~/bin/vcftools_0.1.12b/bin/vcftools --vcf early_cluster2.recode.vcf --min-alleles 2 --max-alleles 2 --recode --out biallelic_early_cluster2
~/bin/vcftools_0.1.12b/bin/vcftools --vcf late_cluster2.recode.vcf --min-alleles 2 --max-alleles 2 --recode --out biallelic_late_cluster2

~/bin/vcftools_0.1.12b/bin/vcftools --vcf biallelic_early_cluster2.recode.vcf --freq --out frq_early_cluster2
~/bin/vcftools_0.1.12b/bin/vcftools --vcf biallelic_late_cluster2.recode.vcf --freq --out frq_late_cluster2

grep -v "scaffold" frq_early_cluster2.frq > early_c2.frq
grep -v "scaffold" frq_late_cluster2.frq > late_c2.frq

tail -n +2 late_c2.frq > latec2.frq
tail -n +2 early_c2.frq > earlyc2.frq

rm late_c2.frq
rm early_c2.frq

printf 'Late\n%.0s' {1..618333} > late
printf 'Early\n%.0s' {1..618333} > early

paste late latec2.frq > late_c2

paste early earlyc2.frq > early_c2

rm late
rm latec2.frq


rm early
rm earlyc2.frq

# This is problematic, we have sites with indels and they differ, we also have sites that have -nan (presumably ridiculously small freqencies)


grep -v "nan" early_c2 > early_c2.frq
grep -v "nan" late_c2 > late_c2.frq


grep -v "-" early_c2.frq > frq_c2_early
grep -v "-" late_c2.frq > frq_c2_late

cut -f1,2,3,6,7 frq_c2_early > early_c2.frq
cut -f1,2,3,6,7 frq_c2_late > late_c2.frq

rm early_c2
rm late_c2
```
 
Vim to edit these outputs.

```bash

awk 'BEGIN {OFS="\t"}; {print $1,$6,$4,$7,$3,$2}' early_c2.frq > frq_c2_early
awk 'BEGIN {OFS="\t"}; {print $1,$6,$4,$7,$3,$2}' late_c2.frq > frq_c2_late

rm early_c2.frq
rm late_c2.frq

awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $6"_"$5}' frq_c2_late > late
awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $6"_"$5}' frq_c2_early > early

rm frq_c2_late
rm frq_c2_early

sort -k 7,7 early > sorted_early
sort -k 7,7 late > sorted_late

join -1 7 -2 1 sorted_late sorted_allele > late_full_c2.txt
join -1 7 -2 1 sorted_early sorted_allele > early_full_c2.txt


rm sorted_late
rm sorted_early


awk 'BEGIN {OFS = "\t"}; {print $8,$2,$3,$4,$5,$6,$7} ' late_full_c2.txt > late_c2_final_full
awk 'BEGIN {OFS = "\t"}; {print $8,$2,$3,$4,$5,$6,$7} ' early_full_c2.txt > early_c2_final_full



rm late_full_c2.txt
rm early_full_c2.txt

sort -k 1,1 late_c2_final_full > sorted_late
sort -k 1,1 early_c2_final_full > sorted_early

join -1 1 -2 1 sorted_late sorted_early > to_split

# This to_split file should be concordant between groups for frequencies now. Use VIM to remove S0_

awk 'BEGIN {OFS="\t"}; {print $1,$2,$3,$4,$5,$6,$7}' to_split > late

awk 'BEGIN {OFS="\t"}; {print $1,$8,$9,$10,$11,$12,$13}' to_split > early


cat late early > full_dataset_c2_early_late.txt

sort -k 1,1 full_dataset_c2_early_late.txt > full_dataset_file_cluster2.txt

rm full_dataset_c2_early_late.txt
```



# FILE 3 - Freqs file

Remove the "S0_" coordinates because I originally took these out of the GWAS with NAM.

To make the freqs file (Ames) sort the full.dataset file and join to gwas.data.file:

```bash
(head -n 2 full_dataset_Ames.txt  && tail -n +3 full_dataset_Ames.txt | sort) > sorted.full.data.set.file
join -1 1 -2 1 sorted.full.data.set.file gwas.data.file > freqs_file
```

# FILE4 - make the match pop file from the GWAS panel pop

```bash
printf 'NAM\n%.0s' {1..511532} > NAM
paste NAM NAM_allfreqs.txt > unordered_NAM
awk '{print $2 " " $1 " " $3 " " $4 " " $5}' unordered_NAM > ordered_NAM
sort -k 1,1 ordered_NAM > sortedordered_NAM
grep -v "S_0" sortedordered_NAM > NAM_for_match
```

Get the allele conversion file - remove the header. Remove any S0_ coordinates in vim.

```bash
sort -k3,3 alleleconversion.txt > sortedalleleconversion.txt
join -1 1 -2 3 NAM_for_match sortedalleleconversion.txt > match_pop_file_to_edit
awk 'BEGIN {OFS="\t"}; {print $1,$2,$3,$4,$5,$7,$6}' match_pop_file_to_edit > match_pop_file
```

Add a header, add tab separators in vim if you want.

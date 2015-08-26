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
awk '{ print $1 " " $4 " " $5 " " $3 " " $6}' intermediatefile > gwas.data.file
```

Ok, that's the first Qx file. 1 down four to go.

# Next make the fulldatasetfile with AMES - FILE 2

i.e. the allele frequencies, first get each of the Ames cluster files into order, and remove the lines with scaffolds.


``` bash
for file in *.frq
do
	echo "$file: " $(awk '{ print $6 " " $5 " " $2 " " $1}' $file > out$file)
done

grep -v "scaffold" outnewcluster1.recode.vcf.frq > cluster1.frq
grep -v "scaffold" outnewcluster2.recode.vcf.frq > cluster2.frq
grep -v "scaffold" outnewcluster3.recode.vcf.frq > cluster3.frq
grep -v "scaffold" outnewcluster4.recode.vcf.frq > cluster4.frq
grep -v "scaffold" outnewcluster5.recode.vcf.frq > cluster5.frq
grep -v "scaffold" outnewcluster6.recode.vcf.frq > cluster6.frq
```

Print out the group names an appropriate number of times (number of lines in frequency files minus the header).
```bash
printf 'TropicalBlueGroup\n%.0s' {1..618333} > blue
printf 'SSYellowGroup\n%.0s' {1..618333} > yellow
printf 'SSGreenGroup\n%.0s' {1..618333} > green
printf 'NSSRedGroup\n%.0s' {1..618333} > red
printf 'PurpleGroup\n%.0s' {1..618333} > purple
printf 'OrangeGroup\n%.0s' {1..618333} > orange
```

And paste groups together
```bash
paste blue cluster1.frq > cluster1
...
```
Etc. 


Now we just need to join the alleleconversion.txt file with each of the clusters so that we have the v2 coordinate as the SNP name.
``` bash
for file in cluster*
do
	echo "$file: " $(awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6 " " $7 " " $7"_"$6}' $file > out$file)
done
```

Then just awk some more to put the fields together in the order you want. Thanks awk.

That's file 2.

# FILE 3 - Freqs file

Remove the "S0_" coordinates because I originally took these out of the GWAS with NAM.

```bash
grep -v "S0_" full_dataset_file2.txt > full_dataset_Ames.txt
```

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

Get the allele conversion file - remove the header.

```bash
sort -k3,3 alleleconversion.txt > sortedalleleconversion.txt
grep -v "S0_" sortedalleleconversion.txt > conversion_allele
join -1 1 -2 3 NAM_for_match conversion_allele > match_pop_file_to_edit
awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $7 " " $6}' match_pop_file_to_edit > match_pop_file
```

Add a header, add tab separators in vim if you want.

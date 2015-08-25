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

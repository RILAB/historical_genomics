# Relatively hacky way to get a Bayenv file by Individual

First, in shell declare your list of named individuals (example below - you can make this file in vim - will provide script later):

```
#!/bin/bash -l

declare -a arr=("05-397" "05-438" "12E" "207" "22612" "25-046" "3042" "3102-23" "3167B" "32311C-A" "33-16")

for i in "${arr[@]}"
do
        echo "$i: "$(~/bin/vcftools_0.1.12b/bin/vcftools --vcf final.vcf --indv $i --recode --out forfrq$i)
done
```

- Copy these small vcfs to a new directory

- Calculate frequencies of each vcf file, produces the 0,1 counts, plus missing sites.

```
for file in *.vcf
do
        echo "$file: "$(~/bin/vcftools_0.1.12b/bin/vcftools --vcf $file --freq --out new$file)
done
```

- Next remove the header of all these files, because we'll move to R next.

```bash
for file in *.frq
do
        echo "$file: "$(tail -n+2 $file > noheader$file)
done
```


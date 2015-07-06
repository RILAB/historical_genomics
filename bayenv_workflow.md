## Bayenv2 workflow with modern maize data (KC)
Eventually, this will be expanded to individuals with release dates within a heterotic group. But for now, we'll stick with loose heterotic groups.

To make the covariance matrix. Take a random bunch of loci - 5000 in the example here (10000/2))

```
sort -R new_file.txt | head -n 10000 > SNPsfile
```

And run on 6 heterotic groups first
```
bayenv2 -i SNPsfile -p 6 -r $RANDOM -k 100000 > matrix.out
```

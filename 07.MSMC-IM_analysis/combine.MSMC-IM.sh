#!/bin/sh

ls within1*final.txt > within1.list
sed -i 's/within1-//g' within1.list


for i in `cat within1.list`
do
python3 ~/msmc-tools-master/combineCrossCoal.py  Across-${i}  within1-${i} within2-${i} > Combined12-${i}
#perl ../convert-msmc-CRR.pl ${i}
for a in 1e-9 1e-8 1e-7 1e-6 1e-5 ##b1
do
for b in 1e-1 1e-3 1e-2 ## b2
do
python3 MSMC_IM.py -mu 1.15e-8  -beta ${a},${b} -o MSMC_IM/${i} --printfittingdetails --plotfittingdetails  --xlog Combined12-${i}
done
done
done


#MSMC_IM simulation: simulate two pops 10 replicates with divergence of 500kya and single direction of migration (5%); 10 replicates
python3 500k.rate0.05_ms_prime_msformat.py 10


#MSMC_IM simulation: simulate two pops with divergence of 500kya and single direction of migration (10%);10 replicates
python3 500k.rate0.10_ms_prime_msformat.py  10

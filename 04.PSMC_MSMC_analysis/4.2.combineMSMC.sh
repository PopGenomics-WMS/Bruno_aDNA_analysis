##############################################################
### Run MSMC: step02 (run combineCrossCoal.py)
##############################################################

ls within2*final.txt > within2.list
sed -i 's/within2-//g' within2.list

for i in `cat within2.list`
do
python3 ~/msmc-tools-master/combineCrossCoal.py  Across-${i}  within1-${i} within2-${i} > Combined12-${i}

done

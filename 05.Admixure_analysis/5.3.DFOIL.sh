##############################################################
### Runnning DFOIL
##############################################################

P2=Bruno   # P2 pop

pvalue=0.001 #0.001 0.005 0.01 0.05

for P1 in Polarsample  # P1 pop
do

for P3 in EUsample   # P3 pop
do

for P4 in AMsample   # P4 pop
do

for win in 100000 150000 200000 250000 300000 350000 400000 500000 ## window size
do
python ~/00.software/mvftools/mvftools.py CalcPatternCount --mvf ${P1}-${P3}-${P4}.TV.vcf.mvf --out ${P1}-${P3}-${P4}.TV.vcf.mvf.W${win}.txt --windowsize ${win} --sample-labels ${P1}_${P1},${P2}_${P2},${P3}_${P3},${P4}_${P4},BLK-0902155_BLK-0902155
~/00.software/dfoil/dfoil.py --infile ${P1}-${P3}-${P4}.TV.vcf.mvf.W${win}.txt --pvalue ${pvalue} --out ${P1}-${P3}-${P4}.TV.vcf.mvf.W${win}.P${pvalue}.stats
python ~/00.software/dfoil/dfoil_analyze.py ${P1}-${P3}-${P4}.TV.vcf.mvf.W${win}.P5e3.stats > ${P1}-${P3}-${P4}.TV.vcf.mvf.W${win}.P${pvalue}.stats.result

done
done
done
done

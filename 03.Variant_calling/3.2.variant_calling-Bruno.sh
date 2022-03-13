##############################################################
### genotype calling for Bruno 
##############################################################
REF=Polar_bear.reference.fas

# Filter bam using minimum read length of 35bp and mapping quality of 30
samtools view -q30 -h Brunobear.all.sorted.rmdup.rehead.bam | awk 'length($10) > 34 || $1 ~ /^@/' | samtools view -bS - > Brunobear.all.sorted.rmdup.R35q30.rehead.bam

# Index bam
samtools index Brunobear.all.sorted.rmdup.R35q30.rehead.bam

# average sequencing coverage
samtools depth Brunobear.all.sorted.rmdup.R35q30.rehead.bam | awk '{sum+=$3} END { print "Brunobear.all.sorted.rmdup.R35q30.rehead.bam Average depth = ",sum/2345457942,NR}' >>Brunobear.all.sorted.rmdup.R35q30.rehead.bam.DEPTH.txt


# Bruno genotype calling for each scaffold

for i in {1..36} X1
do
samtools faidx ${REF} scaffold_${i} >scaffold_${i}.fas
Bam2snpAD -r scaffold_${i} -f scaffold_${i}.fas Brunobear.all.sorted.rmdup.R35q30.rehead.bam >scaffold_${i}.snpAD
/snpAD -B  --refbias_out=scaffold_${i}.refbias.txt  -c 6 -o scaffold_${i}.priors.txt -O scaffold_${i}.errors.txt scaffold_${i}.snpAD

refbias=`cat scaffold_${i}.refbias.txt`
snpADCall  -B ${refbias}  -N Bruno.R35q30 -e scaffold_${i}.errors.txt  -p "`cat scaffold_${i}.priors.txt`"  scaffold_${i}.snpAD > Bruno.R35q30.scaffold_${i}.Bflag.snpAD.vcf

bgzip Bruno.R35q30.scaffold_${i}.Bflag.snpAD.vcf
vcftools --gzvcf Bruno.R35q30.scaffold_${i}.Bflag.snpAD.vcf.gz --min-meanDP 7  --minQ 40 --max-meanDP 42  --remove-indels --recode --recode-INFO-all --out Bruno.R35q30_${i}.Dep7toTwo.Q40.Bflag

bgzip Bruno.R35q30_${i}.Dep7toTwo.Q40.Bflag.recode.vcf
tabix -p vcf Bruno.R35q30_${i}.Dep7toTwo.Q40.Bflag.recode.vcf.gz

done






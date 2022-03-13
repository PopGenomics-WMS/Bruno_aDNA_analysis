##############################################################
### Run MSMC: step01
##############################################################

## phase using beagle
for chr in {1..36}
do
java -Xmx32g -jar beagle.4.1.jar gt=Bruno-modern_Bear.${chr}.pass.vcf  out=Bruno-modern_Bear.${chr}.phase nthreads=6
done

## get phased genotype for each sample
for i in  samples
do
for chr in {1..36}
do

vcftools --gzvcf Bruno-modern_Bear.${chr}.phase.vcf.gz --keep ${i}.list --recode --out ${i}_${chr}.phase
bgzip ${i}_${chr}.phase.recode.vcf
tabix -p vcf ${i}_${chr}.phase.recode.vcf.gz

done
done


## run msmc2 for 8 haplotypes
for POP in 8hap.poppairs
do
msmc2  -I 0-4,0-5,0-6,0-7,1-4,1-5,1-6,1-7,2-4,2-5,2-6,2-7,3-4,3-5,3-6,3-7 -s  -t 8 -o Across-${POP}.V2.out \
01.8hap_msmciput-mask_01/${POP}.chr1.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr2.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr3.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr4.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr5.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr6.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr7.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr8.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr9.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr10.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr11.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr12.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr13.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr14.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr15.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr16.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr17.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr18.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr19.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr20.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr21.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr22.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr23.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr24.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr25.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr26.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr27.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr28.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr29.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr30.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr31.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr32.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr33.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr34.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr35.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr36.msmc.txt


msmc2 -I 0,1,2,3  -t 8 -o within1-${POP}.V2.out \
01.8hap_msmciput-mask_01/${POP}.chr1.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr2.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr3.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr4.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr5.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr6.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr7.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr8.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr9.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr10.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr11.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr12.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr13.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr14.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr15.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr16.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr17.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr18.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr19.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr20.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr21.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr22.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr23.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr24.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr25.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr26.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr27.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr28.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr29.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr30.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr31.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr32.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr33.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr34.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr35.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr36.msmc.txt

msmc2  -I 4,5,6,7  -t 8 -o within2-${POP}.V2.out \
01.8hap_msmciput-mask_01/${POP}.chr1.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr2.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr3.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr4.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr5.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr6.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr7.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr8.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr9.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr10.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr11.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr12.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr13.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr14.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr15.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr16.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr17.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr18.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr19.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr20.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr21.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr22.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr23.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr24.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr25.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr26.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr27.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr28.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr29.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr30.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr31.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr32.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr33.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr34.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr35.msmc.txt \
01.8hap_msmciput-mask_01/${POP}.chr36.msmc.txt
done


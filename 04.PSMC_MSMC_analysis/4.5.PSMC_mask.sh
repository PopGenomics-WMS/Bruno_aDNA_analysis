##############################################################
### Run PSMC using bam with unadmixed regions
##############################################################

REF=Polar_bear.reference.fas
BAM=sample.rehead.bam

# x and y are one third and two fold of whole-genome sequencing average depth for each BAM 
minDepth=x
maxDepth=y

for msk in Regions_with_maskedregions_removed.bed
do

## “-l” option should be a bed file

samtools mpileup  -C50 -uf ${REF} ${BAM} -l ${BAM}.${msk}  | ~/00.software/psmc-master/samtools-0.1.18/bcftools/bcftools view -c - | ~/00.software/psmc-master/samtools-0.1.18/bcftools/vcfutils.pl vcf2fq -d ${minDepth} -D  ${maxDepth}  | gzip > ${BAM}.${msk}.P0.sort.fq.gz


~/00.software/psmc-master/utils/fq2psmcfa -q 20 ${BAM}.${msk}.P0.sort.fq.gz >${BAM}.${msk}.P0.sort.psmcfa

samtools faidx ${BAM}.${msk}.P0.sort.psmcfa

for i in {1..36}
do
samtools faidx ${BAM}.${msk}.P0.sort.psmcfa scaffold_$i >>${BAM}.${msk}.P0.sort.auto.psmcfa
done

~/00.software/psmc-master/psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o ${BAM}.${msk}.P0.sort.auto.psmc ${BAM}.${msk}.P0.sort.psmcfa
done

##############################################################
### Run PSMC 
##############################################################

REF=Polar_bear.reference.fas
BAM=sample.rehead.bam

# x and y are one third and two fold of whole-genome sequencing average depth for each BAM 
minDepth=x
maxDepth=y


samtools mpileup  -C50 -uf ${REF} ${BAM}  | ~/00.software/psmc-master/samtools-0.1.18/bcftools/bcftools view -c - | ~/00.software/psmc-master/samtools-0.1.18/bcftools/vcfutils.pl vcf2fq -d ${minDepth} -D  ${maxDepth}  | gzip > ${BAM}.P0.sort.fq.gz

~/00.software/psmc-master/utils/fq2psmcfa -q 20 ${BAM}.P0.sort.fq.gz >${BAM}.P0.sort.psmcfa

samtools faidx ${BAM}.P0.sort.psmcfa


for i in {1..36}
do
samtools faidx ${BAM}.P0.sort.psmcfa scaffold_$i >>${BAM}.P0.sort.auto.psmcfa
done

~/00.software/psmc-master/psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o ${BAM}.P0.sort.auto.psmc ${BAM}.P0.sort.psmcfa


##############################################################
### genotype calling for modern bears
##############################################################
REF=Polar_bear.reference.fas

# generate gvcf for each sample

for SRA in sample1
do
java -jar ./GenomeAnalysisTK.jar -T  HaplotypeCaller  -R  ${REF}  -I ${SRA}.realigh.merge.rehead.bam --emitRefConfidence BP_RESOLUTION --min_base_quality_score 18 -o  ${SRA}.realigh.merge.rehead.bam.g.vcf 
bgzip  ${SRA}.realigh.merge.rehead.bam.g.vcf
tabix -p vcf  ${SRA}.realigh.merge.rehead.bam.g.vcf.gz
done

# joint calling of gvcfs

java -Xmx200g  -jar ./GenomeAnalysisTK.jar -T GenotypeGVCFs -o All_modern_Bear.vcf -nt 24  -R   /projects/redser2/genomes/Polar_Bear/Ursus_maritimus_jun2019.fasta \
--variant sample1.all.rehead.bam.g.vcf.gz \
--variant sample2.all.rehead.bam.g.vcf.gz \
--variant sample3.all.rehead.bam.g.vcf.gz \
.....
--variant samplen.all.rehead.bam.g.vcf.gz \

# Filter SNPs
java -Xmx10g  -jar GenomeAnalysisTK.jar -R  ${REF}   -T VariantFiltration   --filterExpression "QUAL < 40.0" --filterName "QUALFilter" --filterExpression "MQ < 25.0" --filterName "MQFilter"   --variant All_modern_Bear.vcf  --filterExpression "MQ0 >= 4 && ((MQ0/(1.0*DP)) > 0.1)" --filterName "HARD_TO_VALIDATE" --missingValuesInExpressionsShouldEvaluateAsFailing --logging_level ERROR -o All_modern_Bear.filter1.vcf -cluster 3 -window 10
grep -v  -e "Filter"  -e "SnpCluster"  -e "HARD_TO_VALIDATE"   All_modern_Bear.filter1.vcf >  All_modern_Bear.filter2.vcf
vcftools --vcf All_modern_Bear.filter2.vcf --remove-indels --recode --recode-INFO-all --max-alleles 2 --out All_modern_Bear.filter2.bi-snp.vcf 





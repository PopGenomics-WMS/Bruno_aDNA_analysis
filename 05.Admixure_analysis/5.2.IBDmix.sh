##############################################################
### Get genotype from each scaffold for Bruno and Browbear seperately
##############################################################

for i in {1..36} 
do

vcftools --gzvcf Bruno-modern_Bear.pass.recode.vcf.gz  --keep Browbear.list --max-missing 0.6  --remove-indels --max-alleles 2 --chr ${i} --recode --out Browbear.chr${i} >scaffold_${i}.out
vcftools --gzvcf Bruno-modern_Bear.pass.recode.vcf.gz  --keep Bruno.list  --remove-indels --max-alleles 2 --chr ${i} --recode --out Bruno.chr${i}  >Bruno.scaffold_${i}.out

done

##############################################################
### Running IBDmix for each scaffold seperately
##############################################################

for i in {1..36}
do
# Running IBDmix for each scaffold
~/00.software/IBDmix/generate_gt -a Bruno.chr${i}.recode.vcf -m Browbear.chr${i}.recode.vcf  -o Bruno-Browbear.chr${i}.gt
~/00.software/IBDmix/ibdmix -g Bruno-Browbear.chr${i}.gt -o Bruno-Browbear.chr${i}.gt.ibdmix -n Brunobear

# Filter and get coordinant and length for each admixed tracts 
awk '{if($4-$3>30000 && $5>=4) print $0"\t"$4-$3 }' Bruno-Browbear.chr${i}.gt.ibdmix  >Bruno-Browbear.chr${i}.LOD4_30Kb.gt.ibdmix
awk '{print $2"\t"$3"\t"$4}' Bruno-Browbear.chr${i}.LOD4_30Kb.gt.ibdmix >Bruno-Browbear.chr${i}.LOD4_30Kb.gt.ibdmix.bed
sort -k1,1n -k2,2n Bruno-Browbear.chr${i}.LOD4_30Kb.gt.ibdmix.bed >Bruno-Browbear.chr${i}.LOD4_30Kb.gt.ibdmix.sort.bed
done


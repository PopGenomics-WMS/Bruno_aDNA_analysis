##############################################################
### mapping seqencing reads from Bruno to reference
##############################################################

SAMPLE=LibIDs
BWA_THREADS=12
SEED_DISABLE=1024
BAM_MIN_QUALITY=20
REFERENCE_NAME=Polar_bear
REFERENCE_SEQUENCE=Polar_bear.reference.fas

###  ...Adapter trimming and merging of reads
SeqPrep2 -f ${SAMPLE}_L001_R1_001.fastq.gz -r ${SAMPLE}_L001_R2_001.fastq.gz -1 ${SAMPLE}_R1_unmerged.fastq.gz -2 ${SAMPLE}_R2_unmerged.fastq.gz -q 15 -L 25 -A AGATCGGAAGAGCACACGTC -B AGATCGGAAGAGCGTCGTGT -s ${SAMPLE}_merged.fastq.gz -E ${SAMPLE}_readable_alignment.txt.gz -o 10 -d 1 -C ATCTCGTATGCCGTCTTCTGCTTG -D GATCTCGGTGGTCGCCGTATCATT >& ${SAMPLE}_SeqPrep_output.txt

### BWA alignments with merged reads

bwa aln -l ${SEED_DISABLE} -t ${BWA_THREADS} ${REFERENCE_SEQUENCE} ${SAMPLE}_merged.fastq > ${SAMPLE}_merged.${REFERENCE_NAME}.sai
bwa samse ${REFERENCE_SEQUENCE} ${SAMPLE}_merged.${REFERENCE_NAME}.sai ${SAMPLE}_merged.fastq > ${SAMPLE}_merged.${REFERENCE_NAME}.sam

### Convert SAM to BAM

samtools view -q${BAM_MIN_QUALITY} -bSh ${SAMPLE}_merged.${REFERENCE_NAME}.sam > ${SAMPLE}_merged.${REFERENCE_NAME}.bam

### Sort and index all_reads BAM file
samtools sort ${SAMPLE}_merged.${REFERENCE_NAME}.bam ${SAMPLE}_merged.${REFERENCE_NAME}.sorted
samtools index ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.bam

### Remove duplicates and index
samtools rmdup -S ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.bam ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.rmdup.bam
samtools index ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.rmdup.bam

### Generate statistics like number mapped, duplicates, and number aligned to each chromosome
samtools flagstat ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.bam >& ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.flagstats.txt

### mapDamage to assess damage rates from all aligned and duplicate-removed data and to draw fragment length distributions of aligned data
mapDamage -i ${SAMPLE}_all_reads.${REFERENCE_NAME}.sorted.bam -r ${REFERENCE_SEQUENCE} --merge-reference-sequences -l 200 -d ~/mapDamage_${SAMPLE} -y 0.5 -m 25 -t ${SAMPLE}


###Merge bam from all libraries
java -jar picard.jar MergeSamFiles  INPUT=./JK578-1-1_S81_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./JK579-1-1_S87_all_reads.Polar_bear.sorted.rmdup.bam INPUT=./JK578-1-2_S82_all_reads.Polar_bear.sorted.rmdup.bam INPUT=./JK579-1-2_S88_all_reads.Polar_bear.sorted.rmdup.bam    INPUT=./JK578-2-1_S83_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./JK580-1-1_S89_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./JK578-2-2_S84_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./JK580-1-2_S90_all_reads.Polar_bear.sorted.rmdup.bam INPUT=./JK578-3-1_S85_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./P4712_new_all_reads.Polar_bear.sorted.rmdup.bam INPUT=./JK578-3-2_S86_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./SE5145_BAN036-1_S100_all_reads.Polar_bear.sorted.rmdup.bam INPUT=./JK578_S80_all_reads.Polar_bear.sorted.rmdup.bam  INPUT=./SE5145_BAN037-1_S101_all_reads.Polar_bear.sorted.rmdup.bam OUTPUT=./Brunobear.all.sorted.rmdup.bam VALIDATION_STRINGENCY=LENIENT 

###  AddReadGroups and index bam
java -Xmx16g -jar picard.jar AddOrReplaceReadGroups OUTPUT=Brunobear.all.sorted.rmdup.rehead.bam  INPUT=Brunobear.all.sorted.rmdup.bam  RGID=Brunobear_ALLlib RGLB=Brunobear RGPL=ILLUMINA RGPU=ILLUMINA RGSM=Brunobear  VALIDATION_STRINGENCY=LENIENT
samtools index Brunobear.all.sorted.rmdup.rehead.bam

### sequencing depth for whole genome and sex chrom
samtools depth Brunobear.all.sorted.rmdup.rehead.bam  | awk '{sum+=$3} END { print "Brunobear.all Average depth = ",sum/2345457942,NR}' >Brunobear.all.sorted.rmdup.rehead.bam.DEPTH.txt
samtools depth Brunobear.all.sorted.rmdup.rehead.bam  -r scaffold_X1 | awk '{sum+=$3} END { print "Brunobear.scaffold_X1 Average depth = ",sum/125271463}' >Brunobear.scaffold_X1.DEPTH.txt


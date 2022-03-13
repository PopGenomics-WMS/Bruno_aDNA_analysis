##############################################################
### mapping seqencing reads from modern bears to reference
##############################################################

REF=Polar_bear.reference.fas

for SRA in sample1 sample2
do
mv ${SRA} ${SRA}.sra

###  trimming reads
trimmomatic-0.39.jar PE -threads 10 -phred33 ${SRA}_1.fastq.gz ${SRA}_2.fastq.gz ${SRA}_1.paired.fastq.gz ${SRA}_1.unpaired.fastq.gz ${SRA}_2.paired.fastq.gz ${SRA}_2.unpaired.fastq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

### map paired reads
bwa mem -t 12 -M -R  "@RG\tID:${SRA}\tLB:${SRA}\tPL:ILLUMINA\tSM:${SRA}" ${REF} ${SRA}_1.paired.fastq.gz ${SRA}_2.paired.fastq.gz | samtools view -bS - -o ${SRA}.pe.bam

### map Single-end reads
cat ${SRA}_1.unpaired.fastq.gz ${SRA}_2.unpaired.fastq.gz >${SRA}.se.fastq.gz
bwa mem -t 12 -M -R  "@RG\tID:${SRA}\tLB:${SRA}\tPL:ILLUMINA\tSM:${SRA}" ${REF} ${SRA}.se.fastq.gz  | samtools view -bS - -o ${SRA}.se.bam

### sort
java -Xmx32g -Djava.io.tmpdir=${SRA}.pe  -jar picard.jar SortSam I=${SRA}.pe.bam O=${SRA}.pe.sort.bam SORT_ORDER=coordinate
java -Xmx16g -Djava.io.tmpdir=${SRA}.se -jar picard.jar SortSam I=${SRA}.se.bam O=${SRA}.se.sort.bam SORT_ORDER=coordinate

samtools index ${SRA}.se.sort.bam
samtools index ${SRA}.pe.sort.bam

### remove duplicate
java -Xmx32g -Djava.io.tmpdir=${SRA}.pe -jar picard.jar MarkDuplicates I=${SRA}.pe.sort.bam O=${SRA}.pe.sort.dedup.bam REMOVE_DUPLICATES=true METRICS_FILE=${SRA}.pe.dedup.metrics VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=50
java -Xmx16g -Djava.io.tmpdir=${SRA}.pe -jar picard.jar MarkDuplicates I=${SRA}.se.sort.bam O=${SRA}.se.sort.dedup.bam REMOVE_DUPLICATES=true METRICS_FILE=${SRA}.se.dedup.metrics VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=50

samtools index ${SRA}.pe.sort.dedup.bam
samtools index ${SRA}.se.sort.dedup.bam

###realign
mkdir ${SRA}
java -Xmx32g -Djava.io.tmpdir=${SRA}/tmp  -jar GenomeAnalysisTK.jar   -R   ${REF} -T RealignerTargetCreator -o ${SRA}.pe.sort.dedup.bam.intervals -I ${SRA}.pe.sort.dedup.bam
java -Xmx32g -Djava.io.tmpdir=${SRA}/tmp -jar GenomeAnalysisTK.jar   -R   ${REF} -T  IndelRealigner -targetIntervals ${SRA}.pe.sort.dedup.bam.intervals  -o ${SRA}.pe.sort.dedup.realigh.bam -I ${SRA}.pe.sort.dedup.bam

java -Xmx16g -Djava.io.tmpdir=${SRA}/tmp  -jar GenomeAnalysisTK.jar  -R   ${REF} -T RealignerTargetCreator -o ${SRA}.se.sort.dedup.bam.intervals -I ${SRA}.se.sort.dedup.bam
java -Xmx16g -Djava.io.tmpdir=${SRA}/tmp -jar GenomeAnalysisTK.jar   -R   ${REF} -T  IndelRealigner -targetIntervals ${SRA}.se.sort.dedup.bam.intervals  -o ${SRA}.se.sort.dedup.realigh.bam -I ${SRA}.se.sort.dedup.bam

####merge se and pe 
java -jar picard.jar MergeSamFiles  INPUT=./${SRA}.pe.sort.dedup.realigh.bam INPUT=./${SRA}.se.sort.dedup.realigh.bam  OUTPUT=${SRA}.sort.dedup.realigh.merge.bam
samtools index ${SRA}.sort.dedup.realigh.merge.bam

### sequencing depth for whole genome and sex chrom
samtools depth ${SRA}.sort.dedup.realigh.merge.bam  | awk '{sum+=$3} END { print "Average depth = ",sum/2345457942,NR}' >${SRA}.sort.dedup.realigh.merge.bam.DEPTH.txt
samtools depth ${SRA}.sort.dedup.realigh.merge.bam  -r scaffold_X1 | awk '{sum+=$3} END { print "scaffold_X1 Average depth = ",sum/125271463}' >${SRA}.sort.dedup.realigh.merge.bam.scaffold_X1.DEPTH.txt
done

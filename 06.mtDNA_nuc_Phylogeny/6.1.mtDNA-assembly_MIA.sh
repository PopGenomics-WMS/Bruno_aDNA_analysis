##############################################################
### Using MIA to assembly mitochondiral genomes
##############################################################

MIA_REFERENCE_SEQUENCE=Ursus_maritimus_NC_003428.1.fasta
ANCIENT_DNA_MATRIX=ancient.submat.txt

for SAMPLE in Brunolibs
do
	mia -r ${MIA_REFERENCE_SEQUENCE} -f ${SAMPLE}_merged.fastq -c -C -U -s ${ANCIENT_DNA_MATRIX} -i -F -k 14 -m ${SAMPLE}_merged.maln
 	wait
 	gzip ${SAMPLE}_merged.fastq
wait
done
 
for SAMPLE in Brunolibs
do
 	ma -M ${SAMPLE}_merged.maln.* -f 3 > ${SAMPLE}_merged.maln.F.mia_stats.txt
 	wait
 	ma -M ${SAMPLE}_merged.maln.* -f 2 > ${SAMPLE}_merged.maln.F.mia_coverage_per_site.txt
 	wait
 	ma -M ${SAMPLE}_merged.maln.* -f 5 > ${SAMPLE}_merged.maln.F.mia_consensus.fasta
 	wait
 	ma -M ${SAMPLE}_merged.maln.* -f 41 > ${SAMPLE}_merged.maln.F.inputfornext.txt
 	wait
 
    perl mia_consensus_coverage_filter.pl -c 20 -p 0.9 -I ${SAMPLE}_20x_0.9 <${SAMPLE}_merged.maln.F.inputfornext.txt >${SAMPLE}_merged.maln.F.mia_consensus.20x_0.9_filtered.fasta
 
done


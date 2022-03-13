##############################################################
#### Phylogeny analysis of mtDNA sequences
##############################################################

#Align mtDNA sequences using muscle
muscle -in 2012.PNAS.40mtDNA_IDs.sequence-burno.fasta -out 2012.PNAS.40mtDNA_IDs.sequence-burno.aln.fasta 

# Construct ML tree using raxml
raxmlHPC -x 12345 -k -# 1000 -p 321 -m GTRGAMMAI -T 20 -s 2012.PNAS.40mtDNA_IDs.sequence-burno.aln-rmDloop.NN.fas -f a -n 2012.PNAS.40mtDNA_IDs.sequence-burno.aln-rmDloop.NN.fas.raxml2.tre 

##############################################################
#### Phylogeny analysis of nuclear genome sequences
##############################################################

#Convert genotype (VCF) for each sample into .fasta format sequences
python3 vcf2fasta.sjf.py -v Bruno-modernbear.vcf  -op ./ -nt 8 
cat *fasta >Bruno-modernbear.fas

#Construct NJ tree using megacc
megacc -a ./NJ_BT1000.mao -d Bruno-modernbear.fas -o Bruno-modernbear.nj.tre 




### Generate MSMC input files for bootstraps 
for POP in 4hap_poppiars
do
python3 ~/msmc-tools-master/multihetsep_bootstrap.py -n 30 -s 5000000 ${POP}_bsdir \
00.4haps_mask_input/${POP}.chr1.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr2.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr3.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr4.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr5.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr6.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr7.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr8.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr9.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr10.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr11.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr12.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr13.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr14.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr15.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr16.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr17.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr18.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr19.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr20.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr21.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr22.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr23.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr24.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr25.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr26.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr27.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr28.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr29.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr30.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr31.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr32.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr33.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr34.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr35.mask.msmc.txt \
00.4haps_mask_input/${POP}.chr36.mask.msmc.txt
done

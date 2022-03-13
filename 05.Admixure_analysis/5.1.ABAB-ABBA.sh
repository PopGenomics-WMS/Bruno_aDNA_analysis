##############################################################
### Running ABAB-ABBA analysis
##############################################################

# Convert .vcf file into .ped files using plink
~/00.software/plink --file Bruno-modern_Bear.pass.TV.vcf  --chr-set 80 --recode tab  --out  Bruno-modern_Bear.pass.TV.vcf 

#  Convert .ped file into .EIGENSTRAT format files using convertf
~/00.software/AdmixTools/bin/convertf -p par.ped2eigen 

# Running ABAB-ABBA using qpDstat
~/00.software/AdmixTools/src/qpDstat -p par.abba >01.ABAB-ABBA.result 

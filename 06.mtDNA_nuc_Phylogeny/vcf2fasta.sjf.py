#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import gzip
import sys
import time
import argparse
from multiprocessing import Pool

def get_list(in_file):
	try:
		global decode
		if in_file[in_file.rfind(".")+1:] == "gz":
			vcf = gzip.open(in_file,'r')
			decode=True
		else:
			vcf = open(in_file,'r')
			decode=False
	except IOError:
		print("ERROR: {0} do not exists.".format(in_file))
	else:
		for line in vcf:
			if decode:
				line=line.decode('utf-8')
			
			if line.startswith("#CHROM"):
				sample_list = line.split()[9:]
				break
	finally:
		vcf.close()

	return sample_list


def recode(sample_id):
	print('[{0}] INFO: Start  convert {1}'.format(time.ctime(),sample_id))

	in_file=dict_run[sample_id][0]
	out_prefix=dict_run[sample_id][1]
	i=int(dict_run[sample_id][2])

	dict_allel = {
	'..' : '-',
	'AA':'A', 'TT':'T', 'CC':'C', 'GG':'G',
	'AC':'M', 'CA':'M',
	'AG':'R', 'GA':'R',
	'AT':'W', 'TA':'W',
	'CG':'S', 'GC':'S',
	'CT':'Y', 'TC':'Y',
	'GT':'K', 'TG':'K'
	}
	try:
		if decode:
			vcf = gzip.open(in_file,'r')
		else:
			vcf = open(in_file,'r')
	except IOError:
		print("[{0}] ERROR: {1} do not exists.".format(time.ctime(),in_file))
	else:
		output = open('{0}/{1}.fasta'.format(out_prefix,sample_id),'w')
		output.write('>{0}'.format(sample_id)+'\n')
		fas_box=[]
		if decode:
			for line in vcf:
				line=line.decode('utf-8')
	
				if line.startswith("#"):
					pass
				else:
					ref=line.split()[3]
					alt=line.split()[4]
					dict_temp={
					'0/0':ref+ref,'0|0':ref+ref,
					'0/1':ref+alt,'0|1':ref+alt,
					'1/1':alt+alt,'1|1':alt+alt,
					'./.':'..'
					}
					snp=dict_allel[dict_temp[line.split()[9+i].split(':')[0]]]
					fas_box.append(snp)
					if len(fas_box)==100:
						output.write(''.join(fas_box)+'\n')
						fas_box=[]
			output.write(''.join(fas_box)+'\n')
		else:
			for line in vcf:
				if line.startswith("#"):
					pass
				else:
					ref=line.split()[3]
					alt=line.split()[4]
					dict_temp={
					'0/0':ref+ref,'0|0':ref+ref,
					'0/1':ref+alt,'0|1':ref+alt,
					'1/1':alt+alt,'1|1':alt+alt,
					'./.':'..'
					}
					snp=dict_allel[dict_temp[line.split()[9+i].split(':')[0]]]
					fas_box.append(snp)
					if len(fas_box)==100:
						output.write(''.join(fas_box)+'\n')
						fas_box=[]
			output.write(''.join(fas_box)+'\n')
	finally:
		vcf.close()
		output.close()
		print('[{0}] INFO: Finish convert {1}'.format(time.ctime(),sample_id))
def final_run():
	parser = argparse.ArgumentParser(
	formatter_class=argparse.RawDescriptionHelpFormatter,
	description="Convert VCF format to fasta format (per sample).",
	epilog='''
@author:     Jingfang SI
@copyright:  2018 China Agricultural University. All rights reserved.
@contact:    sijingfang@foxmail.com
	'''
	)
	parser.add_argument("-v", "--vcf", required=True,help="specify the input vcf(.vcf/.vcf.gz) file")
	parser.add_argument("-op", "--out-prefix", required=True,help="specify the prefix of output file")
	parser.add_argument("-nt", "--num-threads", required=True,type=int, default=1,help="specify the number of data threads")
	args = parser.parse_args()
	
	in_file = args.vcf
	out_prefix = args.out_prefix
	num_threads = args.num_threads

	sample_list=get_list(in_file)
	global dict_run
	dict_run={}
	for sample_id in sample_list:
		dict_run[sample_id]=[in_file,out_prefix,sample_list.index(sample_id)]
	
	print('[{0}] INFO: Convert vcf to fasta. Total samples : {1}.'.format(time.ctime(),len(sample_list)))
	current_time = time.time()
	with Pool(num_threads) as p:
		p.map(recode,sample_list)
		p.close()
		p.join()
	
	print('[{0}] INFO: Done'.format(time.ctime()))
	# print('[{0}] INFO: Total running time {1}'.format(time.ctime(),time.strftime("%H:%M:%S", time.mgtime(time.time()-current_time))))
if __name__ == '__main__':
	final_run()

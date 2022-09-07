import time
start = time.time() 

import pandas as pd, numpy as np, time
from eva import *
from eva.ckks import *
from eva.metric import valuation_mse
from eva.seal import *
import sys, os, datatable as dt, pickle



def max_dim(x):
    i = 0
    while True:
        if (2 ** i <= x) & (2 ** (i + 1) >= x):
            break
        i = i + 1

    return 2 ** (i + 1)


### Client 부분
plink_file = sys.argv[1]
enc_geno_name = sys.argv[2]
weight_snp_list_file = sys.argv[3]
public_ctx_file = sys.argv[4]
signature_file = sys.argv[5]
vec_size = int(sys.argv[6])


snp_list = pd.read_csv(weight_snp_list_file,sep='\t',header=0)

public_ctx = load(public_ctx_file)
signature = load(signature_file)


print('Running plink for additive encoding')
print('plink --bfile ' + plink_file + ' --recode A --out ' + plink_file)
os.system('plink --bfile ' + plink_file + ' --recode A --out ' + plink_file)
print('\n')
with open(plink_file + '.raw') as (f):
    ncols = len(f.readline().split(' '))
geno = np.loadtxt((plink_file + '.raw'), skiprows=1, usecols=(range(6, ncols)))
geno = geno.transpose()
geno = pd.DataFrame(geno)
bim = pd.read_csv((plink_file + '.bim'), sep='\t', header=None)
bim = bim.loc[0:bim.shape[0]]
fam = pd.read_csv((plink_file + '.fam'), sep='\t', header=None)
samples = fam[1]
geno.columns = samples
Nsnps = geno.shape[0]

bim.columns = [ 'CHR_bim', 'SNP', '0', 'POS_bim', 'A1_bim', 'A2_bim']
bim = pd.concat([bim,geno],axis=1)
bim = pd.merge(left=bim, right=snp_list, how='inner', on='SNP')


geno = bim[samples.to_list()] 

diff_idx = bim['A2'] != bim['A2_bim']
geno.loc[diff_idx,:] = np.ones_like(geno.loc[diff_idx]) * 2 - geno.loc[diff_idx]

bim=bim['SNP']
N = geno.shape[1]
N_sample = samples.shape[0]

slot_size = max_dim(bim.shape[0])

tmp = np.zeros(slot_size - bim.shape[0])
geno.index = np.arange(geno.shape[0])
tmp = np.zeros((slot_size - geno.shape[0], N))
geno_pad = np.concatenate((np.array(geno), tmp))

Inputs={} 

for j in range(N_sample):
    for i in  range(int(slot_size/vec_size)):           
        Inputs.update({samples[j]+'_'+str(i):geno_pad[i*vec_size:(i+1)*vec_size,j]})
       
enc_geno = public_ctx.encrypt(Inputs, signature)
save(enc_geno, enc_geno_name)

print("time :", time.time() - start)

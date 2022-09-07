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


def ele_sum(vector, my_len):
    shifted = vector
    for j in range(0, int(np.log2(my_len))):
        tmp = shifted << 2 ** j
        shifted = shifted + tmp
    return shifted


fam_file = sys.argv[1]
phe_file = sys.argv[2] 
params_name = sys.argv[3]
signature_name = sys.argv[4]
compiled_name = sys.argv[5]
q = int(sys.argv[6])
fixed_point = int(sys.argv[7])


fam = pd.read_csv(fam_file,sep='\t',header=None)
weights = pd.read_csv(phe_file,sep='\t',header=0)
samples = fam[1]
N_sample = samples.shape[0]
beta = weights['BETA']

slot_size = max_dim(beta.shape[0])
tmp = np.zeros(slot_size - beta.shape[0])
beta_pad = np.concatenate((np.array(beta), tmp), axis=0)

if slot_size >= 2**16:
    vec_len=2**16
else:
    vec_len=slot_size

prs = EvaProgram('PRS', vec_size=vec_len)    
with prs:
    for j in range(N_sample):
        res = 0
        for i in range(int(slot_size/vec_len)):
            x = Input(samples[j]+'_'+str(i))
            b = list(beta_pad[i*vec_len:(i+1)*vec_len])
            tmp = x*b
            res = res + ele_sum(tmp, vec_len)
        Output(samples[j], res)


prs.set_output_ranges(q)
prs.set_input_scales(fixed_point)
compiler = CKKSCompiler(config={'warn_vec_size': 'false'})
compiled_prs, params, signature = compiler.compile(prs)

save(params, params_name)
save(signature, signature_name)
save(compiled_prs, compiled_name)

print('The vector size of compiled model is '+str(prs.vec_size))

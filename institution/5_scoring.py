import time
start = time.time() 

import pandas as pd, numpy as np, time
from eva import *
from eva.ckks import *
from eva.metric import valuation_mse
from eva.seal import *
import sys, os, datatable as dt, pickle


enc_geno_name = sys.argv[1]
compiled_prs_name = sys.argv[2]
public_ctx_name = sys.argv[3]
enc_score_name = sys.argv[4]

enc_geno = load(enc_geno_name)
compiled_prs = load(compiled_prs_name)
public_ctx = load(public_ctx_name)

enc_score = public_ctx.execute(compiled_prs, enc_geno)
save(enc_score, enc_score_name)

print("time :", time.time() - start)

import time
start = time.time()


import pandas as pd, numpy as np, time
from eva import *
from eva.ckks import *
from eva.metric import valuation_mse
from eva.seal import *
import sys, os, datatable as dt, pickle
import csv


secret_ctx_name = sys.argv[1]
enc_score_name = sys.argv[2]
signature_name = sys.argv[3]
score_name = sys.argv[4]

secret_ctx = load(secret_ctx_name)
enc_score = load(enc_score_name)
signature = load(signature_name)

outputs = secret_ctx.decrypt(enc_score, signature)

res={}
for i in range(len(outputs)):
    res.update({list(outputs.keys())[i]:list(outputs.values())[i][0]})

with open(score_name+'_score', 'w', encoding='UTF-8') as f:
    w = csv.writer(f)
    w.writerow(res.keys())
    w.writerow(res.values())

print("time :", time.time() - start)

from eva import *
from eva.ckks import *
from eva.metric import valuation_mse
from eva.seal import *
import sys, os, datatable as dt, pickle

params_name = sys.argv[1]
public_name = sys.argv[2]
secret_name = sys.argv[3]

params = load(params_name)
public_ctx, secret_ctx = generate_keys(params)

save(public_ctx, public_name)
save(secret_ctx, secret_name)

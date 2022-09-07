#!/bin/bash
phe=$1
SNP=$2
A1=$3
A2=$4
BETA=$5
P=$6
ref_dir=$7 #../../LD/ldblk_1kg_eur
bim_prefix=$8 #../../../client/test
n_gwas=$9 #50000
out_dir=${10} #../../methods/PRScs/results/
a=${11} #1
b=${12} #0.5
phi=${13} #auto
chr=${14} #
cd ../ #company
pwd
echo Rscript prscs_gen_input.r inputs/"${phe}".csv inputs/"${phe}"_prscs_input.csv "${SNP}" "${A1}" "${A2}" "${BETA}" "${P}"
Rscript prscs_gen_input.r inputs/"${phe}".csv inputs/"${phe}"_prscs_input.csv "${SNP}" "${A1}" "${A2}" "${BETA}" "${P}"
cd methods

mkdir "${out_dir}"/"${phe}"

if [ "${phi}" = "auto" ];
then
	if [ -z "${chr}" ];
	then 
        	python3 PRScs/PRScs.py --ref_dir="${ref_dir}" --bim_prefix="${bim_prefix}" --sst_file=../inputs/"${phe}"_prscs_input.csv --n_gwas="${n_gwas}" --out_dir="${out_dir}"/"${phe}"/"${phe}" --a="${a}" --b="${b}"
	else
		python3 PRScs/PRScs.py --ref_dir="${ref_dir}" --bim_prefix="${bim_prefix}" --sst_file=../inputs/"${phe}"_prscs_input.csv --n_gwas="${n_gwas}" --out_dir="${out_dir}"/"${phe}"/"${phe}" --a="${a}" --b="${b}" --chrom="${chr}"
	fi
else
	if [ -z "${chr}" ];
	then
       		python3 PRScs/PRScs.py --ref_dir="${ref_dir}" --bim_prefix="${bim_prefix}" --sst_file=../inputs/"${phe}"_prscs_input.csv --n_gwas="${n_gwas}" --out_dir="${out_dir}"/"${phe}"/"${phe}" --a="${a}" --b="${b}" --phi="${phi}"
	else
	python3 PRScs/PRScs.py --ref_dir="${ref_dir}" --bim_prefix="${bim_prefix}" --sst_file=../inputs/"${phe}"_prscs_input.csv --n_gwas="${n_gwas}" --out_dir="${out_dir}"/"${phe}"/"${phe}" --a="${a}" --b="${b}" --phi="${phi}" --chrom="${chr}"
	fi
fi
cd ../
pwd
echo Rscript prscs_gen_output.r "${phe}" "${a}" "${b}" "${phi}" "${phe}"_prscs_output.csv
Rscript prscs_gen_output.r "${phe}" "${a}" "${b}" "${phi}" "${phe}"_prscs_output.csv

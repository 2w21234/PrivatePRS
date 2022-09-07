#!/bin/bash
phe=$1
SNP=$2
BETA=$3
P=$4
CHR=$5
POS=$6
A1=$7
A2=$8
ref_dir=$9 #../../LD/all_phase3.EUR
r2_thres=${10} #0.1
p_thres=${11} #0.05
kb=${12} #250
chrs=${13}


mkdir PT/results/"${phe}"

if [ -z "${chrs}" ];
then

	plink \
	    --bfile "${ref_dir}" \
	    --clump-p1 1 \
	    --clump-r2 "${r2_thres}" \
	    --clump-kb "${kb}" \
	    --clump ../inputs/"${phe}".csv \
	    --clump-snp-field "${SNP}" \
	    --clump-field "${P}" \
	    --out PT/results/"${phe}"/"${phe}"_PT
else
        plink \
            --bfile "${ref_dir}" \
            --clump-p1 1 \
            --clump-r2 "${r2_thres}" \
            --clump-kb "${kb}" \
            --clump ../inputs/"${phe}".csv \
            --clump-snp-field "${SNP}" \
            --clump-field "${P}" \
            --out PT/results/"${phe}"/"${phe}"_PT \
	    --chr ${chrs}
fi

cd PT/results/"${phe}"
awk 'NR!=1{print $3}' "${phe}"_PT.clumped >  "${phe}"_PT.valid.snp
cd ../../../../
pwd
echo Rscript PT_gen_output.r methods/PT/results/"${phe}"/"${phe}"_PT.valid.snp inputs/"${phe}".csv "${P}" "${SNP}" "${CHR}" "${POS}" "${A1}" "${A2}" "${BETA}" "${p_thres}" methods/PT/results/"${phe}"/"${phe}"_PT_output.csv

Rscript PT_gen_output.r methods/PT/results/"${phe}"/"${phe}"_PT.valid.snp inputs/"${phe}".csv "${P}" "${SNP}" "${CHR}" "${POS}" "${A1}" "${A2}" "${BETA}" "${p_thres}" methods/PT/results/"${phe}"/"${phe}"_PT_output.csv



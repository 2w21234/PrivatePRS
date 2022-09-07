#!/bin/bash
phe=$1
SNP=$2
BETA=$3
P=$4
CHR=$5
POS=$6
A1=$7
A2=$8
SE=$9 #SE
case_n=${10} #Nca
control_n=${11} #Nco
ncol=${12} #Ncol
case_freq=${13} #FRQ_A_19099
control_freq=${14} #FRQ_U_34194
N=${15} #53293
ref_dir=${16} #../../LD/all_phase3.EUR
INFO=${17}
ldr=${18}
eff_type=${19}
chrs=${20}

echo ${chrs}
mkdir LDpred/results/"${phe}"

if [ -z "${chrs}" ];
then
	for chr in {1..22};
	do
   	ldpred coord --gf "${ref_dir}".${chr} --ssf ../inputs/"${phe}".csv --out ./LDpred/results/"${phe}"/"${phe}".${chr} --rs "${SNP}" --A1 "${A1}" --A2 "${A2}" --pos "${POS}" --chr "${CHR}" --pval "${P}" --eff "${BETA}" --se "${SE}" --case-n "${case_n}" --control-n "${control_n}" --case-freq "${case_freq}" --control-freq "${control_n}" --ncol "${ncol}" --info "${INFO}"  --N "${N}" --eff_type "${eff_type}" --only-hm3 --match-genomic-pos
  	ldpred gibbs --cf ./LDpred/results/"${phe}"/"${phe}".${chr} --ldr "${ldr}" --out ./LDpred/results/"${phe}"/"${phe}".${chr} --ldf "${ref_dir}".${chr}
	done
else
        for chr in `echo "${chrs}" | grep -o -e "[^,]*"`;
        do
	echo 'chr:' ${chr}
        echo ldpred coord --gf "${ref_dir}".${chr} --ssf ../inputs/"${phe}".csv --out ./LDpred/results/"${phe}"/"${phe}".${chr} --rs "${SNP}" --A1 "${A1}" --A2 "${A2}" --pos "${POS}" --chr "${CHR}" --pval "${P}" --eff "${BETA}" --se "${SE}" --case-n "${case_n}" --control-n "${control_n}" --case-freq "${case_freq}" --control-freq "${control_n}" --ncol "${ncol}" --info "${INFO}"  --N "${N}" --eff_type "${eff_type}" --only-hm3 --match-genomic-pos
	echo ldpred gibbs --cf ./LDpred/results/"${phe}"/"${phe}".${chr} --ldr "${ldr}" --out ./LDpred/results/"${phe}"/"${phe}".${chr} --ldf "${ref_dir}".${chr}
	ldpred coord --gf "${ref_dir}".${chr} --ssf ../inputs/"${phe}".csv --out ./LDpred/results/"${phe}"/"${phe}".${chr} --rs "${SNP}" --A1 "${A1}" --A2 "${A2}" --pos "${POS}" --chr "${CHR}" --pval "${P}" --eff "${BETA}" --se "${SE}" --case-n "${case_n}" --control-n "${control_n}" --case-freq "${case_freq}" --control-freq "${control_n}" --ncol "${ncol}" --info "${INFO}"  --N "${N}" --eff_type "${eff_type}" --only-hm3 --match-genomic-pos
        ldpred gibbs --cf ./LDpred/results/"${phe}"/"${phe}".${chr} --ldr "${ldr}" --out ./LDpred/results/"${phe}"/"${phe}".${chr} --ldf "${ref_dir}".${chr}
        done
fi

cd ../
echo Rscript ldpred_gen_output.r "${phe}"
Rscript ldpred_gen_output.r "${phe}"


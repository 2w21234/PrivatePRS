
#!/bin/bash
phe=$1 #ADHD
LD=$2 #../../LD/all_phase3.EUR
cojo_sblup=$3 #1.33e6
cojo_wind=$4 #1000
SNP=$5
A1=$6
A2=$7
FRQ=$8
BETA=$9
SE=${10}
P=${11}
N=${12}
chrs=${13}
echo ${chrs}
mkdir SBLUP/results/"${phe}"

cd ../
echo Rscript sblup_gen_input.r inputs/"${phe}".csv inputs/"${phe}"_SBLUP_input.csv ${SNP} ${A1} ${A2} ${FRQ} ${BETA} ${SE} ${P} ${N}
Rscript sblup_gen_input.r inputs/"${phe}".csv inputs/"${phe}"_SBLUP_input.csv ${SNP} ${A1} ${A2} ${FRQ} ${BETA} ${SE} ${P} ${N}
cd methods/

if [ -z ${chrs} ];
then
	for chr in {1..22};
	do
   	gcta64 --bfile "${LD}".${chr} --cojo-file ../inputs/"${phe}"_SBLUP_input.csv --cojo-sblup "${cojo_sblup}" --cojo-wind "${cojo_wind}" --chr ${chr} --out SBLUP/results/"${phe}"/"${phe}"_${chr} 
	done
else
	for chr in `echo "${chrs}" | grep -o -e "[^,]*"`;
        do
	echo gcta64 --bfile "${LD}".${chr} --cojo-file ../inputs/"${phe}"_SBLUP_input.csv --cojo-sblup "${cojo_sblup}" --cojo-wind "${cojo_wind}" --chr ${chr} --out SBLUP/results/"${phe}"/"${phe}"_${chr}
        gcta64 --bfile "${LD}".${chr} --cojo-file ../inputs/"${phe}"_SBLUP_input.csv --cojo-sblup "${cojo_sblup}" --cojo-wind "${cojo_wind}" --chr ${chr} --out SBLUP/results/"${phe}"/"${phe}"_${chr} 
        done
fi
cd ../
pwd
echo Rscript sblup_gen_output.r "${phe}" "${phe}"_sblup_output.csv
Rscript sblup_gen_output.r "${phe}" "${phe}"_sblup_output.csv




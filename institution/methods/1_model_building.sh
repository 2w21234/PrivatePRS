#!/bin/bash
method=${1}
echo "${method}"
if [ ${method} = "PRScs" ]
then
	phe=$2
	SNP=$3
	A1=$4
	A2=$5
	BETA=$6
	P=$7
	ref_dir=$8 
	bim_prefix=$9 
	n_gwas=${10} 
	out_dir=${11} 
	a=${12} #1
	b=${13} #0.5
	phi=${14} #auto
	CHRS=${15}
	echo 'prscs is called'
	bash prscs.sh ${phe} ${SNP} ${A1} ${A2} ${BETA} ${P} ${ref_dir} ${bim_prefix} ${n_gwas} ${out_dir} ${a} ${b} ${phi} ${CHRS}
elif [ ${method} = "SBLUP" ]
then
	phe=$2 #ADHD
	LD=$3 #../../LD/all_phase3.EUR
	cojo_sblup=$4 #1.33e6
	cojo_wind=$5 #1000
	SNP=$6
	A1=$7
	A2=$8
	FRQ=$9
	BETA=${10}
	SE=${11}
	P=${12}
	N=${13}
	CHRS=${14}
	echo ${CHRS}
	echo 'SBLUP is called'
	echo bash sblup.sh ${phe} ${LD} ${cojo_sblup} ${cojo_wind} ${SNP} ${A1} ${A2} ${FRQ} ${BETA} ${SE} ${P} ${N} ${CHRS}
	bash sblup.sh ${phe} ${LD} ${cojo_sblup} ${cojo_wind} ${SNP} ${A1} ${A2} ${FRQ} ${BETA} ${SE} ${P} ${N} ${CHRS}



elif [ ${method} = "PT" ]
then
	phe=$2
	SNP=$3
	BETA=$4
	P=$5
	CHR=$6
	POS=$7
	A1=$8
	A2=$9
	ref_dir=${10} #../../LD/all_phase3.EUR
	r2_thres=${11} #0.1
	p_thres=${12} #0.05
	kb=${13} #20
	CHRS=${14}
	bash pt.sh ${phe} ${SNP} ${BETA} ${P} ${CHR} ${POS} ${A1} ${A2} ${ref_dir} ${r2_thres} ${p_thres} ${kb} ${CHRS}
	echo bash pt.sh ${phe} ${SNP} ${BETA} ${P} ${CHR} ${POS} ${A1} ${A2} ${ref_dir} ${r2_thres} ${p_thres} ${kb} ${CHRS}
elif [ ${method} = 'LDpred' ]
then
	phe=$2
	SNP=$3
	BETA=$4
	P=$5
	CHR=$6
	POS=$7
	A1=$8
	A2=$9
	SE=${10} #SE
	case_n=${11} #Nca
	control_n=${12} #Nco
	ncol=${13} #Ncol
	case_freq=${14} #FRQ_A_19099
	control_freq=${15} #FRQ_U_34194
	N=${16} #53293
	ref_dir=${17} #../../LD/all_phase3.EUR
	INFO=${18}
	ldr=${19}
	eff_type=${20}
	CHRS=${21}
	echo bash ldpred.sh ${phe} ${SNP} ${BETA} ${P} ${CHR} ${POS} ${A1} ${A2} ${SE} ${case_n} ${control_n} ${ncol} ${case_freq} ${control_freq} ${N} ${ref_dir} ${INFO} ${ldr} ${eff_type} ${CHRS}
	bash ldpred.sh ${phe} ${SNP} ${BETA} ${P} ${CHR} ${POS} ${A1} ${A2} ${SE} ${case_n} ${control_n} ${ncol} ${case_freq} ${control_freq} ${N} ${ref_dir} ${INFO} ${ldr} ${eff_type} ${CHRS}

fi



library(data.table)
library(dplyr)
args <- commandArgs(trailingOnly=TRUE)
snps <- args[1]
sst <- args[2]
pval_col <- args[3]
snp_col <- args[4]
chr_col <- args[5]
bp_col <- args[6]
A1_col <- args[7]
A2_col <- args[8]
eff_col <- args[9]
p_thres <- args[10]
out_name <- args[11]

snps <- fread(snps, header=FALSE)
sst <- fread(sst)
sst_joined <- as.data.frame(inner_join(snps, sst, by=c('V1'=snp_col)))
colnames(sst_joined)[1] <- snp_col

tf <- sst_joined[pval_col] <= p_thres
sst_joined <- sst_joined[tf,]
sst_joined <- sst_joined[,c(chr_col,snp_col,bp_col,A1_col,A2_col,eff_col)]
colnames(sst_joined) <- c('CHR','SNP','POS','A1','A2','BETA')
fwrite(sst_joined,out_name,sep='\t')


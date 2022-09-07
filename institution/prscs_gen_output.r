library(data.table)
args <- commandArgs(trailingOnly=TRUE)
phe <- args[1]
a <- args[2]
b <- args[3]
phi <- args[4]
output <- args[5]
out_name <- paste(phe,'_pst_eff_a',a,'_b',b,'_phi',phi,'_chr','all','.txt',sep='')

setwd(paste('methods/PRScs/results/',phe,sep=""))

system(paste(c('cat',paste(phe,'_pst_eff_a',a,'_b',b,'_phi',phi,'_chr',1:22,'.txt',sep=''),'>',out_name),collapse = ' '))
sumstat <- fread(out_name)
colnames(sumstat) <- c('CHR','SNP','POS','A1','A2','BETA')
fwrite(sumstat,output,row.names=F,sep='\t')

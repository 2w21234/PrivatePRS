library(data.table)
library(dplyr)
setwd('./methods/SBLUP')
args <- commandArgs(trailingOnly=TRUE)
phe <- args[1]
input <- paste('../../../../inputs/',phe,'.csv',sep='')
output <- args[2]
setwd(paste('results/',phe,sep=''))
system(paste0(c('cat',paste(phe,'_',1:22,'.sblup.cojo',sep=''),'>',paste(phe,'_all.sblup.cojo',sep='')),collapse = ' '))
a <- fread(paste(phe,'_all.sblup.cojo',sep=''))
b <- fread(input)
sst_joined <- inner_join(a,b,by=c('V1'='SNP'))
sst_joined <- sst_joined[,c('CHR','V1','BP','A1','A2','V4')]
colnames(sst_joined) <- c('CHR','SNP','POS','A1','A2','BETA')
fwrite(sst_joined, output,sep='\t',row.names=F)

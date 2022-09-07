library(data.table)
args <- commandArgs(trailingOnly=TRUE)
phe_path <- args[1]
out_name <- args[2] 
SNP <- args[3]
A1 <- args[4]
A2 <- args[5]
BETA <- args[6]
P <- args[7]

a <- as.data.frame(fread(phe_path))
a <- a[c(SNP,A1,A2,BETA,P)]
colnames(a) <- c('SNP','A1','A2','BETA','P')

fwrite(a,out_name, sep='\t', row.names=F)

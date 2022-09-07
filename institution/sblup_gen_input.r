library(data.table)
args <- commandArgs(trailingOnly=TRUE)
input <- args[1]
output <- args[2]
SNP <- args[3]
A1 <- args[4]
A2 <- args[5]
FRQ <- args[6]
BETA <- args[7]
SE <- args[8]
P <- args[9]
N <- args[10]


stt <- data.frame(fread(input))

a <- stt[,c(SNP,A1,A2,FRQ,BETA,SE,P,N)]

colnames(a) <- c('SNP','A1','A2','freq','b','se','p','N')
fwrite(a,output,row.names=F, sep='\t')

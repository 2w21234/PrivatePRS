library(data.table)

args <- commandArgs(trailingOnly=TRUE)
phe <- args[1] 
setwd(paste('methods/LDpred/results/',phe,sep=''))


for(p in c('_p1.0000e+00','_p3.0000e-01','_p1.0000e-01','_p3.0000e-02','_p1.0000e-02','_p3.0000e-03','_p1.0000e-03','-inf')){
	files <- paste(phe,'.',1:22,'_LDpred',p,'.txt',sep='')
	total <- NULL
	for(i in 1:22){
  		try({
		  a <- as.data.frame(fread(files[i]))
    	  	  total <- rbind(total,a)
		},silent=T)
	}	
	CHR <- total[['chrom']]
	tmp <- strsplit(CHR,'_')
	tmp <- unlist(tmp)
	tmp <- tmp[(1:(length(tmp)/2))*2]
	tmp <- as.numeric(tmp)
	CHR <- tmp
	SNP <- total[['sid']]
	A1 <- total[['nt1']]
	A2 <- total[['nt2']]
	if(p=='-inf') BETA_col <- 'ldpred_inf_beta'
	else BETA_col <- 'ldpred_beta'
	
	BETA <- total[[BETA_col]]
	POS <- total[['pos']]
	total <- cbind(CHR,SNP,POS,A1,A2,BETA)

	fwrite(total,paste(phe,p,'_ldpred_output.csv',sep=''),sep='\t',row.names=F)
}


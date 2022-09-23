# PrivatePRS ```v1.0```

## Introduction
```PrivatePRS``` is a software tool for polygenic risk scoring, ensuring the privacy issue that each individual can be uniquely identified by genotype data consisting of SNPs. ```PrivatePRS``` is based on ***homomorphic encryption system*** on **complex vector space** and **cyclotomic polynomial ring** allowing for small noise for efficiency. ```PrivatePRS``` makes it possible for a user to easily calculate her PRS using a range of representative PRS models. PrivatePRS includes pre-built pipelines to run four widely used PRS models (PRScs, SBLUP, LDpred and P+T). Specifically, PrivatePRS provides scripts for installing and running these four models, along with preprocessed and quality-controlled Linkage Disequilibrium (LD) files that are required for PRS calculation. Therefore, only the individual standard genotype file (plink format) and summary statistics file are needed for running PrivatePRS with any of the four popular PRS methods. 



![image](https://user-images.githubusercontent.com/37434378/186298559-525b2281-5bf7-41ab-b124-6b553dc08f34.png)

**Overview of PrivatePRS**

First, the TTP generates a secret key for decryption and a public key for encryption and transfers the public key to the client. 

Second, the client encrypts her own genotype data and transfers it to the analysis institution. 

Third, the analysis institution calculates PRS in an encrypted state using a linear model. The weights of the SNPs, necessary for PRS calculation, are calculated using one of the four widely used methods. The institution then transfers the encrypted score to the TTP. 

Lastly, the TTP decrypts the score and sends the result to the client. Under our system, the genomic data analysis institution has access to neither the raw genotypes nor the risk score of the client. In the absence of the TTP, the client can take the role of TTP. 


## Instructions
### Environment
```Linux``` and ```Anaconda3``` are required to run ```PrivatePRS```.

### Installation
We use EVA for compiler of homomorphic encryption system.
To generate additive genotype data which consists of 0, 1 and 2 from bed file, we use plink.  
The dependencies will be downloaded on a virtual environment named ```PrivatePRS```.
```R``` and its libraries (```data.table```, ```dpylr```) are required.

#### 1. Clone PrivatePRS, create virtual environment and set the environments
```
git clone https://github.com/2w21234/PrivatePRS.git  
cd PrivatePRS  
conda create -n PrivatePRS -y  
conda activate PrivatePRS
bash 0_installation-1.sh
cd EVA
```
For dependencies, the ```CMakeList.txt``` file in /EVA needs to be modified as follows:
      'find_package(SEAL 3.6 REQUIRED)' -> 'find_package(SEAL)'
And then run the second installation bash file.
```
cd .. # Under PrivatePRS/
bash 0_installation-2.sh
```


#### 2. Send the SNP list (.bim file) and sample information (.fam file) to the institution for compiling. These files have to be 'tab' separated.

**Client (./client)**

```
cp test.bim test.fam ../institution/client_info/
```

#### 3.(PRS Model-building module) Train one of the PRS models in an unencrypted state

**Institution (./institution/methods)**

The first parameter of '1_model_building.sh' is the name of PRS method. It shoud be one of ('PRScs', 'SBLUP','PT','LDpred').
The other following parmeters depends on the PRS method. The trained weights (output) will be saved in the directory 'institution/methods/{PRS method}/results/{phenotype}/', automatically named as {phenotype}+{PRS method}.

##### PRScs 
```
bash 1_model_building.sh PRScs ADHD SNP A1 A2 BETA P ../LD/hdf5/ldblk_1kg_eur ../client_info/test 53293 PRScs/results 1 0.5 auto 1,2
```
14 parameters are required for 'PRScs':
  1. ***Summary statistics file*** : a GWAS summary statistics file **without a suffix(e.g '.txt', '.csv', ...)** for a phenotype, this file **should be in the following directory, 'PrivatePRS/company/inputs/'**.
  2. ***Column name of rs-id in a summary statistics file***
  3. ***Column name of effect allele in a summary statistics file*** 
  4. ***Column name of alternative allele in a summary statistics file*** 
  5. ***Column name of effect size in a summary statistics file***
  6. ***Column name of p-value in a summary statistics file***
  7. ***Directory including LD reference hdf5 files*** : this directory is population-specific.
  8. ***Bim file*** : a directory to a bim file from the client without a suffix('.bim')
  9. ***Number of samples used in GWAS study*** 
  10. ***Directory where the coefficients are written***
  11. ***Parameter a in the gamma-gamma prior of PRScs***
  12. ***Parameter b in the gamma-gamma prior of PRScs***
  13. ***Global shrinkage parameter phi of PRScs*** : 'auto' automatically calculates the optimal value.
  14. ***Chromosome number*** : chromosome numbers used in PRS training, should be the format of '1,2,3'.**If this value is empty (null), then PrivatePRS trains on the whole autosomal chromosomes.**

##### SBLUP
```
bash 1_model_building.sh SBLUP ADHD ../LD/bfile/EUR 7.33e5 1000 SNP A1 A2 FRQ BETA SE P N 1,2
```
13 parameters are required for 'SBLUP':
  1. ***Summary statistics file*** : a GWAS summary statistics file **without a suffix(e.g '.txt', '.csv', ...)** for a phenotype, this file **should be in the following directory, 'PrivatePRS/company/inputs/'**.
  2. ***Path to a bfile*** : a name of a bfile without a suffix('.bed','.bim','.fam')
  3. ***Parameter lambda in SBLUP*** : the input parameter lambda = m * (1 / h2SNP - 1) where m is the total number of SNPs used in this analysis (i.e. the number of SNPs in common between the summary data and the reference set), and h2SNP is the proportion of variance in the phenotype explained by all SNPs.
  4. ***Distance parameter in SBLUP***
  5. ***Column name of rs-id in a summary statistics file***
  6. ***Column name of effect allele in a summary statistics file*** 
  7. ***Column name of alternative allele in a summary statistics file*** 
  8. ***Column name of effect allelic frequency in a summary statistics file***
  9. ***Column name of effect size in a summary statistics file***
  10. ***Column name of standard error in a summary statistics file***
  11. ***Column name of p-value in a summary statistics file***
  12. ***Column name of the number of samples used in a summary statistics file***
  13. ***Chromosome number*** : chromosome numbers used in PRS training, should be the format of '1,2,3'.**If this value is empty (null), then PrivatePRS trains on the whole autosomal chromosomes.**

##### P+T
```
bash 1_model_building.sh PT ADHD SNP BETA P CHR BP A1 A2 ../LD/bfile/EUR 0.1 0.05 250 1,2
```
13 parameters are required for 'P+T'  
  1. ***Summary statistics file*** : a GWAS summary statistics file **without a suffix(e.g '.txt', '.csv', ...)** for a phenotype, this file **should be in the following directory, 'PrivatePRS/company/inputs/'**.
  2. ***Column name of rs-id in a summary statistics file***
  3. ***Column name of effect size in a summary statistics file***
  4. ***Column name of p-value in a summary statistics file***
  5. ***Column name of chromosome in a summary statistics file***
  6. ***Column name of position(base pair)***
  7. ***Column name of effect allele in a summary statistics file*** 
  8. ***Column name of alternative allele in a summary statistics file*** 
  9. ***Path to a bfile*** : a name of a bfile without a suffix('.bed','.bim','.fam')
  10. ***R2 threshold*** 
  11. ***P-value threshold***
  12. ***Window size of clumping***
  13. ***Chromosome number*** : chromosome numbers used in PRS training, should be the format of '1,2,3'.**If this value is empty (null), then PrivatePRS trains on the whole autosomal chromosomes.**

##### LDpred
```
bash 1_model_building.sh LDpred ADHD SNP OR P CHR BP A1 A2 SE Nca Nco Ncol FRQ_A_19099 FRQ_U_34194 53293 ../LD/bfile/EUR INFO 10 OR 1,2
```
20 parameters are required for 'LDpred'  
  1. ***Summary statistics file*** : a GWAS summary statistics file **without a suffix(e.g '.txt', '.csv', ...)** for a phenotype, this file **should be in the following directory, 'PrivatePRS/company/inputs/'**.
  2. ***Column name of rs-id in a summary statistic file***
  3. ***Column name of effect size in a summary statistic file***
  4. ***Column name of p-value in a summary statistic file***
  5. ***Column name of chromosome in a summary statistic file***
  6. ***Column name of position(base pair)***
  7. ***Column name of effect allele in a summary statistic file*** 
  8. ***Column name of alternative allele in a summary statistic file*** 
  9. ***Column name of standard error of estimates in a summary statistic file*** 
  10. ***Column name of the number of cases in GWAS summary statistic file*** 
  11. ***Column name of the number of controls in GWAS summary statistic file***
  12. ***Column name of the total number of samples in GWAS summary statistic file*** 
  13. ***Column name of the case frequency in summary statistic file*** 
  14. ***Column name of the control frequency in summary statistic file*** 
  15. ***The number of individuals in summary statistic file***
  16. ***path to a bfile*** : a name of a bfile without a suffix('.bed','.bim','.fam')
  17. ***column name of the INFO score in summary statistic file*** 
  18. ***LD radius***
  19. ***effect type*** : an element of the set {LINREG, OR, LOGOR, BLUP}
  20. ***Chromosome number*** : chromosome numbers used in PRS training, should be the format of '1,2,3'.**If this value is empty (null), then PrivatePRS trains on the whole autosomal chromosomes.**

#### 4. Send the SNP list to the client
**Institution (./institution/method/SBLUP/results/ADHD/)**

We assume that the institution trained SBLUP for ADHD. Then the institution have to send the SNP list to the client. If the institution doesn't want to share the beta (coefficients) in summary statistics of GWAS with the client, the institution needs to cut out the beta column from summary data and send the SNP list file to the client.
```
cut -f 1-5 ADHD_sblup_output.csv > ADHD_sblup_snp_list
mv ADHD_sblup_snp_list ../../../../../client/snp_list/
```

#### 5. (Compiler module) Compile the model
**Institution (./institution)**

The institution compiles the model for encryption and decryption. And the institution sends the outputs(parameter, signature, compiled model) to the client and TTP.
```
python3 2_compile.py client_info/test.fam methods/SBLUP/results/ADHD/ADHD_sblup_output.csv compiled_model/ADHD_sblup_params compiled_model/ADHD_sblup_signature compiled_model/ADHD_sblup_compiled_prs 30 30

cp compiled_model/ADHD_sblup_params ../TTP/params/
cp compiled_model/ADHD_sblup_signature ../TTP/signature/
cp compiled_model/ADHD_sblup_signature ../client/signature/
```
7 parameters are required for compiling.
  1. ***fam file of the client***
  2. ***Coefficients file of the trained PRS model***
  3. ***Path to the compiled model's parameter file (output)***
  4. ***Path to the compiled model's signature file (output)***
  5. ***Path to the compiled model (output)***
  6. ***Fixed point parameter*** : the fixed-point scale for inputs (30 means 2^30)
  7. ***Coefficient range of the output*** : the maximum ranges of coefficients (30 means 2^30)
  

#### 6. (Key generation module) Generate the public and secret keys
**TTP (./TTP)**

TTP generate keys using the parameters from the institution and send the public key to the client and the institution.
```
python3 3_key_generate.py params/ADHD_sblup_params public_ctx/ADHD_sblup_public_ctx secret_ctx/ADHD_sblup_secret_ctx

cp public_ctx/ADHD_sblup_public_ctx ../client/public_ctx/
cp public_ctx/ADHD_sblup_public_ctx ../institution/public_ctx/
```
3 parameters are required for key generation.
  1. ***Compiled model's parameter file***
  2. ***Path to the public key file (output)***
  2. ***Path to the secret key file (output)***


#### 7. (Encryption module) Encrypt the genotype
**Client (./client)**

The client encrypts her genotypes using the public key. And send the encrypted genotypes to the institution.
```
python3 4_encrypt.py test enc_geno/ADHD_sblup_enc_genotype snp_list/ADHD_sblup_snp_list public_ctx/ADHD_sblup_public_ctx signature/ADHD_sblup_signature 65536

cp enc_geno/ADHD_sblup_enc_genotype ../institution/enc_geno/

```
6 parameters are required for encryption.
  1. ***plink bfile without a suffix(.bim, .fam, .bed) containing client's genotype information***
  2. ***Path to the encrypted genotype data (output)***
  3. ***SNP list file from the institution***
  4. ***Public key from TTP***
  5. ***Signature file of the compiled model***
  6. ***Vector length of the compiled model***    

#### 8. (Risk scoring module) Risk scoring in an encrypted state
**Institution (./institution)**
The institution calculates the risk score in an encrypted state and send the encrypted scores to TTP.
```
python3 5_scoring.py enc_geno/ADHD_sblup_enc_genotype compiled_model/ADHD_sblup_compiled_prs public_ctx/ADHD_sblup_public_ctx enc_score/ADHD_sblup_enc_score 

cp enc_score/ADHD_sblup_enc_score ../TTP/enc_score/
```
4 parameters are required for risk calculation.
  1. ***Encrypted genotype from the client***
  2. ***Compiled model***
  3. ***Public key from TTP***
  4. ***Path to the encrypted risk score (output)***

#### 9. (Decryption module) Decrypt the encrypted scores
**Institution (./TTP)**
TTP decrypts the encrypted scores using the secret key and send send the result to the client.
```
python3 6_decrypt.py secret_ctx/ADHD_sblup_secret_ctx enc_score/ADHD_sblup_enc_score signature/ADHD_sblup_signature score/ADHD_sblup 

cp score/ADHD_sblup_score ../client/SBLUP
```
4 parameters are required decryption.
  1. ***Secret key***
  2. ***Encrypted grisk score from the institution***
  3. ***Signature file of the compiled model from the institution***
  4. ***Path to the unencrypted risk score (output)***


## References

1. Cheon, J.H., et al. Homomorphic Encryption for Arithmetic of Approximate Numbers. 2017. Cham: Springer International Publishing.
2. Chang, C.C., et al., Second-generation PLINK: rising to the challenge of larger and richer datasets. Gigascience, 2015. 4: p. 7.
Wang, J., et al., Expanding the BLUP alphabet for genomic prediction adaptable to the genetic architectures of complex traits. Heredity (Edinb), 2018. 121(6): p. 648-662.
3. Vilhjalmsson, B.J., et al., Modeling Linkage Disequilibrium Increases Accuracy of Polygenic Risk Scores. Am J Hum Genet, 2015. 97(4): p. 576-92.
4. Yang, J., et al., Conditional and joint multiple-SNP analysis of GWAS summary statistics identifies additional variants influencing complex traits. Nat Genet, 2012. 44(4): p. 369-75, S1-3.
5. Ge, T., et al., Polygenic prediction via Bayesian regression and continuous shrinkage priors. Nat Commun, 2019. 10(1): p. 1776.
6. Roshan Dathathri, et al., EVA: An Encrypted Vector Arithmetic Language and Compiler for Efficient Homomorphic Computation. Programming Language Design and Implementation (PLDI 2020), 2019: p. 546-561.
7. Jung Hee Cheon, et al., A Full RNS Variant of Approximate Homomorphic Encryption. SAC: International Conference on Selected Areas in Cryptography. Springer, 2018: p. 347-368.

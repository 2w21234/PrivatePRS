#!/bin/bash
if [ -f "hdf5/ldblk_1kg_afr/ldblk_1kg_chr1.hdf5" ]
then
        echo 'LD files in hdf5 format already have been installed!'
else
        cd hdf5
        # AFR
        wget https://www.dropbox.com/s/mq94h1q9uuhun1h/ldblk_1kg_afr.tar.gz
        tar -zxvf ldblk_1kg_afr.tar.gz

        # AMR
        wget https://www.dropbox.com/s/uv5ydr4uv528lca/ldblk_1kg_amr.tar.gz
        tar -zxvf ldblk_1kg_amr.tar.gz

        # EAS
        wget https://www.dropbox.com/s/7ek4lwwf2b7f749/ldblk_1kg_eas.tar.gz
        tar -zxvf ldblk_1kg_eas.tar.gz

        # EUR
        wget https://www.dropbox.com/s/mt6var0z96vb6fv/ldblk_1kg_eur.tar.gz
        tar -zxvf ldblk_1kg_eur.tar.gz

        # SAS
        wget https://www.dropbox.com/s/hsm0qwgyixswdcv/ldblk_1kg_sas.tar.gz
        tar -zxvf ldblk_1kg_sas.tar.gz

        cd ..
fi


if [ -f "bfile/AFR.1.bed" ]
then
        echo 'LD files in plink-format format already have been installed!'
else
        wget https://hanlab.snu.ac.kr/_file_distribution/2206/bfile.zip --no-check-certificate
        unzip bfile.zip
fi

rm bfile.zip

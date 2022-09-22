#!/bin/bash

conda install python=3.7.13 -y
conda install -c conda-forge scipy=1.7.3 -y
conda install -c conda-forge numpy=1.21.6 -y 
conda install -c conda-forge h5py=3.7.0 -y
conda install -c conda-forge pandas=1.2.3 -y
conda install -c bioconda plink=1.90b6.21 -y 
conda install -c conda-forge cmake=3.24.1 -y
conda install -c statiskit libboost-dev=1.68.0 -y 
conda install -c conda-forge make=4.3 -y
conda install -c conda-forge libprotobuf=3.21.5 -y 
conda install -c anaconda protobuf=4.21.5 -y
conda install -c conda-forge datatable=0.11.1 -y
conda install -c conda-forge pickle5=0.0.12 -y
conda install -c bioconda gcta=1.93.2beta -y
#conda install -c pypi plinkio=0.9.8 -y
conda install -c conda-forge gcc=12.1.0 -y
conda install -c conda-forge gxx=12.1.0 -y
conda install -c conda-forge clangxx=14.0.6 -y
conda install -c conda-forge clang=14.0.6 -y

pip3 install ldpred==1.0.10



git clone  https://github.com/microsoft/EVA.git
cd EVA

git clone -b v4.0.0 https://github.com/microsoft/SEAL.git
cd SEAL

~/anaconda3/envs/PrivatePRS/bin/cmake -S . -D CMAKE_C_COMPILER=~/anaconda3/envs/PrivatePRS/bin/clang-14 -D CMAKE_CXX_COMPILER=~/anaconda3/envs/PrivatePRS/bin/clang-14 -D SEAL_THROW_ON_TRANSPARENT_CIPHERTEXT=OFF
~/anaconda3/envs/PrivatePRS/bin/make -j




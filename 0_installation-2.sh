#!/bin/bash
cd EVA
git submodule update --init
~/anaconda3/envs/PrivatePRS/bin/cmake -S . -D CMAKE_CXX_COMPILER=~/anaconda3/envs/PrivatePRS/bin/clang-14
~/anaconda3/envs/PrivatePRS/bin/make -j

python3 -m pip install -e python/
python3 python/setup.py bdist_wheel --dist-dir='.'

python3 tests/all.py




cd ../institution/LD
bash LD_download.sh


cd ../methods
git clone https://github.com/getian107/PRScs.git
mkdir PRScs/results
mkdir PT/results
mkdir LDpred/results
mkdir SBLUP/results

#!/bin/bash -l

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e """${YELLOW} 
#  ____ ___ ____  _____ ____  
# |  _ \_ _|  _ \| ____/ ___| 
# | |_) | || |_) |  _| \___ \ 
# |  __/| ||  __/| |___ ___) |
# |_|  |___|_|   |_____|____/ 
#                             
# STARTING PIPES
${NC}
"""


# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'

cd ~/1MB438/RESULTS
rm -rf linux_pipes
mkdir -p linux_pipes
cd linux_pipes

w3m -dump https://en.wikipedia.org/wiki/Principal_component_analysis > PCA.txt
wc PCA.txt
head -n 100 PCA.txt > short_pca.txt
wc short_pca.txt

grep PCA short_pca.txt | wc -l
grep PCA PCA.txt | wc -l

cd ~/1MB438/RESULTS/linux_pipes
mkdir -p sam
cd sam
ln ../../linux_tutorial/a_better_name/sample_1.sam .
samtools view -b sample_1.sam > sample_1.bam
ll
samtools view sample_1.bam | head
samtools view sample_1.bam | tail
samtools view sample_1.bam | cut -f 1,10





echo -e """${GREEN} 
#  ____ ___ ____  _____ ____  
# |  _ \_ _|  _ \| ____/ ___| 
# | |_) | || |_) |  _| \___ \ 
# |  __/| ||  __/| |___ ___) |
# |_|  |___|_|   |_____|____/ 
#                             
# FINISHED PIPES
${NC}
"""





















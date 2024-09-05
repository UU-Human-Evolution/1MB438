#!/bin/bash -l

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e """${YELLOW} 
#  ____ ___ ____  _____ _     ___ _   _ _____ ____  
# |  _ \_ _|  _ \| ____| |   |_ _| \ | | ____/ ___| 
# | |_) | || |_) |  _| | |    | ||  \| |  _| \___ \ 
# |  __/| ||  __/| |___| |___ | || |\  | |___ ___) |
# |_|  |___|_|   |_____|_____|___|_| \_|_____|____/ 
#                                                   
# STARTING PIPELINES
${NC}
"""


# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'


cd ~/1MB438/RESULTS
rm -rf linux_pipelines/
mkdir linux_pipelines
cd linux_pipelines

cp ~/1MB438/DATA/Lab0/linux_pipelines/linux_pipelines.tar.gz .
ll
tar -xzvf linux_pipelines.tar.gz
ll

echo $PATH
export PATH=$PATH:~/1MB438/RESULTS/linux_pipelines/dummy_scripts

cd ~/1MB438/RESULTS/linux_pipelines/data/exomeSeq/
filter_reads -i raw_data/my_reads.rawdata.fastq -o my_reads.filtered.fastq -d
align_reads -i my_reads.filtered.fastq -o my_reads.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -d
find_snps -i my_reads.filtered.aligned.sam -o my_reads.filtered.aligned.snpcalled.pileup -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -d

touch exome_analysis_script.sh

cd ~/1MB438/RESULTS/linux_pipelines/data/rnaSeq/
filter_reads -i raw_data/sample1.fastq -o sample1.filtered.fastq -d
filter_reads -i raw_data/sample2.fastq -o sample2.filtered.fastq -d
filter_reads -i raw_data/sample3.fastq -o sample3.filtered.fastq -d
align_reads -i sample1.filtered.fastq -o sample1.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -d
align_reads -i sample2.filtered.fastq -o sample2.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -d
align_reads -i sample3.filtered.fastq -o sample3.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -d
diff_exp -i sample1.filtered.aligned.sam,sample2.filtered.aligned.sam,sample3.filtered.aligned.sam -o sample.diff_exp.out -d




echo -e """${GREEN} 
#  ____ ___ ____  _____ _     ___ _   _ _____ ____  
# |  _ \_ _|  _ \| ____| |   |_ _| \ | | ____/ ___| 
# | |_) | || |_) |  _| | |    | ||  \| |  _| \___ \ 
# |  __/| ||  __/| |___| |___ | || |\  | |___ ___) |
# |_|  |___|_|   |_____|_____|___|_| \_|_____|____/ 
#                                                   
# FINISHED PIPELINES
${NC}
"""













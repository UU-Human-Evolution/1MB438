#!/bin/bash -l

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e """${YELLOW} 
#  ___ _   _ _____ ____   ___  
# |_ _| \ | |_   _|  _ \ / _ \ 
#  | ||  \| | | | | |_) | | | |
#  | || |\  | | | |  _ <| |_| |
# |___|_| \_| |_| |_| \_\____/ 
#                              
# STARTING INTRO
${NC}
"""


# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'


cd

#git clone https://github.com/UU-Human-Evolution/1MB438.git

ls -l

cd 1MB438

mkdir -p RESULTS

ls -l

cd RESULTS

ll ~/

rm -rf linux_tutorial
mkdir linux_tutorial
cp -r ~/1MB438/DATA/Lab0/linux_tutorial/*  linux_tutorial/

cd linux_tutorial
ll
tar -xzvf files.tar.gz
ll

mv important_results/temp_file-1  backed_up_proj_folder/
mv important_results/dna_data_analysis_result_file_that_is_important-you_should_really_use_tab_completion_for_file_names.bam backed_up_proj_folder/
ll backed_up_proj_folder/

mv a_strange_name  a_better_name
ll

cp backed_up_proj_folder/last_years_data  external_hdd/
ll external_hdd/

rm useless_file
rmdir this_is_empty
rm -r this_has_a_file

ll old_project/
head old_project/the_best
head a_better_name/large_file

mv part_2/*.txt part_1/
ll many_files/*.txt

echo -e """${GREEN} 
#  ___ _   _ _____ ____   ___
# |_ _| \ | |_   _|  _ \ / _ \ 
#  | ||  \| | | | | |_) | | | |
#  | || |\  | | | |  _ <| |_| |
# |___|_| \_| |_| |_| \_\____/
#
# FINISHED INTRO
${NC}
"""

















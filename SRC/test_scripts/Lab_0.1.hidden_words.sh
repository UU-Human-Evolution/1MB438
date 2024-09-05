#!/bin/bash -l

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e """${YELLOW}
#  _   _ ___ ____  ____  _____ _   _
# | | | |_ _|  _ \|  _ \| ____| \ | |
# | |_| || || | | | | | |  _| |  \| |
# |  _  || || |_| | |_| | |___| |\  |
# |_| |_|___|____/|____/|_____|_| \_|
#
# STARTING HIDDEN
${NC}
"""

# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'

#rm -r ~/1MB438/RESULTS/linux_pipes
mkdir -p ~/1MB438/RESULTS/linux_pipes
cd ~/1MB438/RESULTS/linux_pipes

rm -rf hidden_words
unzip ../../DATA/Lab0/linux_pipes/hidden_word_exercise.zip

cd hidden_words/exercise_1/directoryB/solution_1.1/
ll
ls -la

cd ..
perl program.pl

cd ../directoryC/
ls -l
echo 66 | perl file_size_check.pl

cd ../../exercise_2/
cat solution_2.1.txt
echo "Please give me solution 2.2" > solution_2.2.txt
perl text_file_check.pl
cd ../exercise_3/
mkdir solution
cp codes.txt solution/
perl check_code.pl

rm junk.txt data/junk*
perl check_junk.pl

cd ../exercise_4/
grep bioinformatics text.txt  | wc -l
perl get_last2char.pl 36

echo -e """${GREEN}
#  _   _ ___ ____  ____  _____ _   _ 
# | | | |_ _|  _ \|  _ \| ____| \ | |
# | |_| || || | | | | | |  _| |  \| |
# |  _  || || |_| | |_| | |___| |\  |
# |_| |_|___|____/|____/|_____|_| \_|
#                                    
# FINISHED HIDDEN
${NC}
"""













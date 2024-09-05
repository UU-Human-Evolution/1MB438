#!/bin/bash -l

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
echo -e """${YELLOW} 
#  ____   ____ ____  ___ ____ _____ ____  
# / ___| / ___|  _ \|_ _|  _ \_   _/ ___| 
# \___ \| |   | |_) || || |_) || | \___ \ 
#  ___) | |___|  _ < | ||  __/ | |  ___) |
# |____/ \____|_| \_\___|_|    |_| |____/ 
#                                         
# STARTING SCRIPTS
${NC}
"""



# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'

cd ~/1MB438/RESULTS
rm -rf linux_scripts
cp -r ~/1MB438/DATA/Lab0/linux_scripts ~/1MB438/RESULTS/
cd ~/1MB438/RESULTS/linux_scripts

tar -xzvf linux_scripts.tar.gz
ll

a=5
echo print this text to the terminal
echo "you can use quotes if you want to"
echo Most international flights leave from terminal $a at Arlanda airport
a="five"
echo Most international flights leave from terminal $a at Arlanda airport

a=4
echo $a squared is $(($a*$a))
x=4
y=5
z=10
echo The volume of the rectangular cuboid with the sides $x,$y,$z is $(($x*$y*$z)).

for i in "Print these words" one by one;
do
    echo $i
done

for number in 1 2 3;
do
    echo $number
done

for whatevernameyouwant in {12..72};
do
    echo $whatevernameyouwant
done

# declare the values the loop will loop over
for secondsToGo in {1..0};
do
    # print out the current number
    echo $secondsToGo

    # sleep for 1 second
    sleep 1

done

# Declare the start of a new year in a festive manner
echo Happy New Year everyone!!



# move to the SAM files directory to start with.
# $1 contains the first argument given to the program
cd sam

# use ls to get the list to iterate over.
for file in *.sam;
do

    # print a message to the screen so that the user knows what is happening.
    # $(basename $file .sam) means that it will take the file name and remove .sam
    # at the end of the name.
    echo "Converting $file to $(basename $file .sam).bam"

    # do the actual converting
    samtools view -b $file > $(basename $file .sam).bam
done




# use a pattern to get the list to iterate over.
for file in *.sam;
do

    # basename will remove the path information to the file, and will also remove the .sam ending
    filename_bam=$(basename $file .sam)

    # add the .bam file ending to the filename
    filename_bam=$filename_bam.bam

    # check if the intended output file does not already exists.
    if [ ! -f $filename_bam ];
    then

       # print a message to the screen so that the user knows what is happening.
       echo "Converting $file to $filename_bam"

       # do the actual converting
       samtools view -b $file > $filename_bam

    else
       # inform the user that the conversion is skipped
       echo "Skipping conversion of $file as $filename_bam already exist"
    fi
done




# set the number you want to calculate the factorial of
n=10

# could also be supplied through an argument to the program
# n=$1

# you have to initialize a variable before you can start using it.
# Leaving this empty would lead to the first iteration of the loop trying
# to use a variable that has no value, which would cause it to crash
factorial=1

# declare the values the loop will loop over (1 to whatever $n is)
for i in $( seq 1 $n );
do

    # set factorial to whatever factorial is at the moment, multiplied with the variable $i
    factorial=$(( $factorial * $i ))

    # an alternative solution which gives exactly the same result, but makes it a bit more readable maybe
    # temporary_sum=$(( $factorial * $i ))
    # factorial=$temporary_sum

done

# print the result
echo The factorial of $n is $factorial






# make the dummy pipeline available
export PATH=$PATH:~/1MB438/RESULTS/linux_pipelines/dummy_scripts

# go to the input files
cd ~/1MB438/RESULTS/linux_scripts/fastq

# loop over all the fastq files
for file in *.fastq;
do

    # filter the reads
    filter_reads -i $file -o $file.filtered -d

    # align the reads
    align_reads -r ~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -i $file.filtered -o $file.filtered.aligned.sam -d

    # call SNPs
    find_snps -r ~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -i $file.filtered.aligned.sam -o $file.filtered.aligned.snpcalled.pileup -d


    break
done

# remove intermediate files
rm *.sam *.filtered




echo -e """${GREEN} 
#  ____   ____ ____  ___ ____ _____ ____  
# / ___| / ___|  _ \|_ _|  _ \_   _/ ___| 
# \___ \| |   | |_) || || |_) || | \___ \ 
#  ___) | |___|  _ < | ||  __/ | |  ___) |
# |____/ \____|_| \_\___|_|    |_| |____/ 
#                                         
# FINISHED SCRIPTS
${NC}
"""




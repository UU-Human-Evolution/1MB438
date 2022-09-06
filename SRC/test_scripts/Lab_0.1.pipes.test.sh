# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'

cd ~/1MB438/RESULTS
rm -rf linux_pipes
mkdir linux_pipes
cd linux_pipes

w3m -dump https://en.wikipedia.org/wiki/Principal_component_analysis > PCA.txt
wc PCA.txt
head -n 100 PCA.txt > short_pca.txt
wc short_pca.txt

grep PCA short_pca.txt | wc -l
grep PCA PCA.txt | wc -l

cd ~/1MB438/RESULTS/linux_pipes
mkdir sam
cd sam
ln ../../linux_tutorial/a_better_name/sample_1.sam .
samtools view -b sample_1.sam > sample_1.bam
ll
samtools view sample_1.bam | head
samtools view sample_1.bam | tail
samtools view sample_1.bam | cut -f 1,10


























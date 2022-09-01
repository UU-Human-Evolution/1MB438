# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'

cd ~/1MB438/RESULTS/
mkdir -p linux_permissions
cd linux_permissions
touch filename
ll

mkdir -p directoryname
ll
chmod a=x filename
ll

chmod a-rwx filename
chmod 663 filename

rm -r *
mkdir -p stuff
touch stuff/linkfile
echo "aerhaerh" > stuff/linkfile
ln -s stuff/linkfile
ll

rm -r *
mkdir -p one/two/three
cd one/two/three
touch a b c d e
ll
cd ../../..
ln -s one/two/three
ll

rm -r *
echo """Cats sleep anywhere, any table, any chair.
Top of piano, window-ledge, in the middle, on the edge.
Open draw, empty shoe, anybody's lap will do.
Fitted in a cardboard box, in the cupboard with your frocks.
Anywhere! They don't care! Cats sleep anywhere.""" > textfile
grep "Cat" textfile
#grep "cat" textfile
grep -i "cat" textfile
cp textfile textcopy
grep "Cat" text*

ll /etc | sort -k 5 -n
ln -s ../linux_tutorial/a_better_name/sample_1.sam .
samtools view -bS sample_1.sam | samtools sort - -o outbam.bam

wc sample_1.sam
grep "SN:chr" sample_1.sam | wc
grep "chr1" sample_1.sam | wc -l
samtools view outbam.bam | grep "AB?BBAABB" | wc -l

grep "^@" sample_1.sam > at.txt
grep "[0-9]\\{3\\}$" sample_1.sam

sed "s/chr1/chr2/" sample_1.sam > sample_2.sam

touch one.bam two.sam three.bam four.sam five.bam six.sam
for f in *.sam
do
  mv $f ${f/.sam}.bam;
done









































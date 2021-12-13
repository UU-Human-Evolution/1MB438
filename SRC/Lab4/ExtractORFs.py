from Bio import SeqIO
import sys
import re

#Fasta file
fasta_file = sys.argv[1]
#GenemarkS processed file
genemark_file = sys.argv[2]

dContigs = {}

#Read the single sequence
for record in SeqIO.parse(fasta_file, "fasta"):
    dContigs[record.id] = record

#Read lines from file and remove newline (\n) from each line
with open(genemark_file, 'r') as file2:
    lines = [line.strip('\n') for line in file2]

regex = r"\s+(\d+)\s+([+-])\s+(\d+)\s+(\d+)"


for line in lines:
    if 'SequenceID:' in line:
        contig = line.split()[-1]
    if re.match(regex, line) is not None:
        orf_nr = line.split()[0]
        strand = line.split()[1]
        first_pos = int(line.split()[2])
        last_pos = int(line.split()[3])

        if strand == '+':
            seq_new = dContigs[contig].seq[first_pos-1:last_pos]
        elif strand == '-':
            #On the opposite strand we have to take the reverse complement of the sequence
            seq_new = dContigs[contig].seq[first_pos-1:last_pos].reverse_complement()

        print('>%s_orf_%s/%s-%s' %(contig, orf_nr, first_pos, last_pos))
        print(str(seq_new))
from Bio import SeqIO
import sys
import os

#Fasta file
infile = sys.argv[1]

def mean(numbers):
    return float(sum(numbers)) / max(len(numbers), 1)

lSeq_length = []
for record in SeqIO.parse(infile, "fasta"):
    length = len(record.seq)
    print record.id+'\t'+ str(length)
    lSeq_length.append(length)

print '# %s Sequences, Total length: %s' %(len(lSeq_length), str(sum(lSeq_length)))
print '# Shortest length: %s, Longest length: %s,  Average size: %s' %(min(lSeq_length), max(lSeq_length), str(mean(lSeq_length)))
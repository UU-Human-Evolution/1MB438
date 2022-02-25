#!/usr/bin/env python3
"""
Created on Tue Oct 13 11:48:42 2020

@author: Hjorvik
"""

import sys
from Bio import SeqIO


#Store the files as DataFrames



fasta_headers = SeqIO.index(sys.argv[1],"fasta")

#table = pd.DataFrame(sys.argv[1])

#Check if headers are properly formated
headerlist = []

for i in fasta_headers:

    if len(i) > 8:
        sys.stdout.write('Format Error: recode your FASTA headers so they are shorter than 8 characters')
        break
    else:
        headerlist.append(i)


if len(headerlist)==len(fasta_headers):
   sys.stdout.write('Formated appropiately')









from Bio import SeqIO
import sqlite3
import sys

#Argument 1 should include fasta file (nucleotide) 
NucleotideFasta = sys.argv[1]
#Argument 2 should be the name of your output file
ProteinFasta = sys.argv[2]
wf_proteins = open(ProteinFasta, 'w')

#Create connection to database
db = sqlite3.connect('my_database.db') #insert your database name (change if you used another name)
cursor = db.cursor()

#Read the nucleotides
lSequence = []
for record in SeqIO.parse(NucleotideFasta, "fasta"):
    #Prepare for database input
    orf_id = record.id
    nucleotides = str(record.seq)
    aminoacids = str(record.seq.translate())
    length = len(aminoacids)
    wf_proteins.write('>'+orf_id+'\n'+aminoacids+'\n')
    cursor.execute('''INSERT INTO orfs(orf_id, nucleotides, aminoacids, length) VALUES(?,?,?,?)''', (orf_id, nucleotides, aminoacids, length))
    db.commit( )

cursor.close()

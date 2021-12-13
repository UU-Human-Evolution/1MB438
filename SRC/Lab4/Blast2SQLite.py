from Bio.Blast import NCBIXML
import os
import sys
import sqlite3

#Read blast XML-file
blastfile = sys.argv[1]

#table name
table_name = sys.argv[2]

#Insert your database name
db = sqlite3.connect('my_database.db')

cursor = db.cursor()

try:
    cursor.execute('''DROP TABLE %s ''' %table_name)
    db.commit()
except:
    cursor.execute('''create table %s(orf_name CHAR, hit INTEGER, hit_length INTEGER, eval FLOAT, identity FLOAT)''' %table_name)
    db.commit()


result_handle = open(blastfile)
blast_records = NCBIXML.parse(result_handle)

for record in blast_records:
    #record = next(blast_records)
    orf_id = record.query

    lScore = []
    dTEMP = {}

    #Fetch the first alignment
    alignment = record.alignments[0]
    hsp = alignment.hsps[0]

    #Extract the information needed
    blast_hit = alignment.title
    e_value = hsp.expect
    length = alignment.length
    identities = hsp.identities
    #Modify table to match your database 
    cursor.execute('''INSERT INTO %s(orf_name, hit, hit_length, eval, identity) VALUES(?,?,?,?,?)''' %table_name, (orf_id, blast_hit, length, e_value, identities))
    db.commit()
               
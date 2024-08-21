import os
import sys

fasta_file  = sys.argv[1]
table_file = sys.argv[2]

if not os.path.isfile(fasta_file):
    print("File path {} does not exist. Exiting...".format(fasta_file))
    sys.exit()
elif not os.path.isfile(table_file):
    print("File path {} does not exist. Exiting...".format(table_file))
    sys.exit()

dict_of_tab_entries = {}
with open(table_file) as fp:
    for line in fp:
        if len(line.strip().split('\t')[0]) > 8:
            print("Error: the name of the species \"" + line.strip().split('\t')[0] + "\" in the tab-separated file is longer than 8 characters! Exiting!")
            sys.exit()
        elif len(line.strip().split('\t')) != 3:
            print("Error: tab-separated file does not contain exactly 3 fields in line \"" + line.strip() + "\"! Exiting!")
            sys.exit()
        else:
            dict_of_tab_entries[str(line.strip().split('\t')[-1])] = str(line.strip())

with open(fasta_file) as fp:
    for line in fp:
        if line.startswith(">"):
            if line.strip().split(' ')[0][1:len(line.strip().split(' ')[0])] in dict_of_tab_entries:
                print(">" + dict_of_tab_entries[line.strip().split(' ')[0][1:len(line.strip().split(' ')[0])]].split('\t')[0])
            else:
                print("Warning: fasta entry " + line.strip().split(' ')[0][1:len(line.strip().split(' ')[0])] + " does not exist! It won't be converted!")
        else:
            print(line.strip())

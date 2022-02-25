import os
import sys

fasta_file  = sys.argv[1]

if not os.path.isfile(fasta_file):
    print("File path {} does not exist. Exiting...".format(fasta_file))
    sys.exit()

with open(fasta_file) as fp:
    for line in fp:
        if line.startswith(">"):
            print("%s\t%s\t%s" % ("make_me_to_max_8_characters", '_'.join(line.strip().split(' ')[1:]), line.split(' ')[0][1:]))

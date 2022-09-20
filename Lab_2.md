
# Session 2 - Aligning our sequences 

**Goals of the practical session:** In this exercise you will use BLAST (Basic Local Alignment Search Tool) to search for sequence similarity. First you will use an online server to search for similarities and then you will run the blast on your computer. Take a look at “HowTo_BLASTGuide.pdf” for how to use BLAST. Then you will learn to use different programs for multiple alignments: kalign, mafft,or muscle, and hmmalign. You will align two datasets (16S and EPHX1) with kalign, mafft or muscle, and you will learn how to use readseq to convert between different alignment formats. You will also run both perl and python script to manipulate your files.

**Assessment of the practical session:** Work alone or in pairs during this lab. As you progress, take notes of answers to the questions highlighted in red in the designated black boxes, or on a paper sheet. At the end of the lab, you should approach one of the teaching assistants present, and ask them to check your answers. They will discuss incorrect answers with you. Once the assistants have approved your answers, they will mark your attendance and the practical session is considered completed.

## Local pairwise alignment
###Online-based BLAST exercise

Use the NCBI server for the online part: [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastp&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome)
Search the protein database SwissProt for [orf_x.fasta](./DATA/Lab2/orf_x.fasta)

**Question 1**
a) What is the name of the gene that is the top hit and what is its function?

##### Search for homologs

You have sequenced a stretch of DNA [orf_serratia.fasta](./DATA/Lab2/orf_serratia.fasta) from Serratia marcescens found in the gut of an insect. You identified an open reading frame and translated it in to a protein and now you want to see if this gene has any homologs in the SwissProt database.

Search SwissProt database with [orf_serratia.fasta](./DATA/Lab2/orf_serratia.fasta)

**Question 2**
1. What protein do you think it is and what is its function?
2. There are some hits that give a much higher E-value than the top hits. To which group of bacteria do these entries belong?
3. What is the taxonomic placement of Serratia? Make a guess and then check the Taxonomy
browser for the real answer.

##### Search for coding regions

Suppose that you have sequenced the stretch of DNA in [sequence.txt](./DATA/Lab2/sequence.txt). Now you want to see if you have any coding regions in your sequence.

Search for open reading frames with Transeq (see [Using_transeq](./extra/Using_transeq.md)), using the standard genetic code. When you search for proteins in a DNA sequence, it is often difficult to know where it starts. It should cover most of the nucleotide sequence when you have found the right frame.

**Question 3**
1. What is the name of the protein?
2. What is its function

###Running BLAST locally

The program for local blast searches is called blastall and includes all the different blast programs. You specify the blast program with the option -p. In the following section you will use the file [prokaryotes_db](./DATA/Lab2/prokaryotes_db) which contains prokaryotic protein sequences in FASTA format.


1. Make a database of the file using formatdb
`makeblastdb -in prokaryotes_db -dbtype prot`
2. Blast the anthrax protein sequence [anthrax.fasta](./DATA/Lab2/anthrax.fasta) against prokaryotes_db.txt. You need to specify at least the following options:
`BLAST_TYPE -db DB_NAME -query QUERY_NAME -out OUT_NAME`
   Where DB_NAME is the name of your database, QUERY_NAME the file that
contains your query sequence, BLAST_TYPE the type of blast program you
want to use (e.g. "blastp" or "blastn") and OUT_NAME how you want to
name your output file.
3. Take a look at the blast result file:
`less OUT_NAME`

**Question 4**

1. What's the name of the second hit in the blast result?
2. What's the corresponding e-value?
3. What are the start and end positions in the hit gene that matches query sequence?


## Multiple aligments 
### Kalign, MAFFT and Muscle

Kalign, MAFFT and Muscle are three different fast alignment programs for protein and nucleotide sequences. Even if they differ in their algorithms they are all advancements on the same general algorithm as ClustalW. As a result they are very fast compared to other programs and can align 1500 sequences in under 10 seconds. MAFFT and Muscle are among the most commonly used alignment programs nowadays.

You can find a brief introduction, and further link, on how to use MAFFT [here](https://mafft.cbrc.jp/alignment/software/). For Muscle you can find a short introduction [here](http://www.drive5.com/muscle/manual/basic_alignment.html), and the more extensive documentation [here](http://www.drive5.com/muscle/manual/). You can also type the following for each program in the terminal to get basic help on how to use them:

kalign

mafft --help

muscle

Align the two datasets independently, EPHX1 ([ephx1.fasta](./DATA/Lab2/ephx1.fasta)) and 16S ([16S.fasta](./DATA/Lab2/16S.fasta)), using two of the alignment programs (Of course it is recommended to have a look at the input file so that you know what you are aligning!). If you are using MAFFT you will need to pipe the output to a new file, this
can be done with the command “>”.The full command should then look something like this:
`mafft (infile) > (outfile)`

### Converting between alignment formats
Unfortunately, there is no standard alignment format that can be read by all programs. Therefore, a sequence-oriented bioinformatician needs some format-converting skills. Readseq is a useful program for converting between alignment formats. For information on how to use readseq type:
`java jar ./SRC/readseq.jar --help`

Use readseq to convert the files you aligned in the previous exercise (default output from kalign is in fasta format - caution! you need to redirect the output from the screen to a file) to the format nexus.

#### Visualizing alignments
You can look at alignments with the program Jalview.

`java jar ./SRC/jalview.jar`

The software package [SuiteMSA](http://bioinfolab.unl.edu/~canderson/SuiteMSA/) is also a good tool for more advanced alignment viewing, for example comparing two alignments. However, for ordinary alignment viewing and editing it is unnecessarily complex.

**Question 5** 
Compare the two alignment programs for ephx1
1. Can you see a difference in the output of the two programs? (Visualize the alignments)
2. How come multiple sequence align programs can produce different results?



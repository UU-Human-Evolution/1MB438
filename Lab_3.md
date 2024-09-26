# Session 3 - BLAST
During the last sessions, you collected and aligned mitochondrial sequences from databases that you will be using for the remaining sessions. Today, you will attempt to find genes in them using a simple similarity-based approach with BLAST.

## Goals
+ Revisit sequence databases from Lab 1
+ Become familiar with BLAST and its output
+ Find coding regions in the mitochondrial genomes using a similarity-based approach

## Input(s)
+ Full mitochondrial genomes collected in previous sessions
+ Protein sequences in FASTA format

## Output(s)
+ Alignments of genes with full mitochondrial genomes
+ Lists of hits in the different mitogenomes

## Tools
+ Sequence databases
+ (command line) BLAST

![](https://upload.wikimedia.org/wikipedia/commons/1/15/Map_of_the_human_mitochondrial_genome.svg)
**Figure 2: Map of the Human mitochondira**
By Emmanuel Douzery - Own work, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=46726514

From the full mitochondrial genome sequences you collected in lab 1, ***select just one species of interest*** that you will test (your choice!). Please check the Genbank entry for that sequence to make sure that it contains information about the start and end positions of the genes.

**Question 1** What species did you select? Please record the ID of the Genbank entry.

Now that you have a species that you want to focus on, we want to obtain protein sequences ***for three genes of interest***. Protein sequences can be obtained from e.g. [UniProt](https://www.uniprot.org/). 
Search the database for the **proteins** 
- *CytB*,
- *COX1* and
- *ND6*
and download each sequence into a **separate FASTA file**. Make sure you mark them correctly.

We now want to search for these protein sequences **in our mitochondrial genomes** to identify the **corresponding coding regions in that nucleotide sequence**. 
For obvious reasons, we cannot directly align protein sequences with a nucleotide sequence as they are composed from a **different alphabet** and there are often alternative codons in the translation process, so the assignment of an amino acid to three nucleotides is ambiguous. 
[tblastn](https://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_BLASTGuide.pdf) is a handy tool for this purpose as it takes a protein sequence as input and compares this to a nucleotide database. As part of the process, the nucleotides in the database are translated into hypothetical proteins using all six possible reading frames.

We want to **compare the proteins to the specific sequences you collected earlier**, so we want to run BLAST using it as a custom database. This means we cannot actually use the online version of BLAST as illustrated in the lectures but we need to run it locally (for us: Solander).

First, we need to prepare our sequence file for BLAST searches. We use the comment **makeblastdb** to preprocess the database. This preprocessing of the database for multiple searches is one of the main reasons why BLAST is such an efficient search algorithm.

```
makeblastdb -in full_nonaligned_mitogenomes.fasta -dbtype nucl 
```

**Question 2.** How many new files are created? Can you read them? Try to find out what they are.

Now we can perform the BLAST search for our first protein, let's start with *CytB*.

```
tblastn -query CYTB.fasta -db full_nonaligned_mitogenomes.fasta -outfmt 6 -out CYTB.blast
```

Reflect yourself on the results. Make sure to use the names of your respective files. Open the output file. What do you see? Can you make sense of the different columns?

```
Column_name	Description
qseqid	query (e.g., unknown gene) sequence id
sseqid	subject (e.g., reference genome) sequence id
pident	percentage of identical matches
length	alignment length (sequence overlap)
mismatch	number of mismatches
gapopen	number of gap openings
qstart	start of alignment in query
qend	end of alignment in query
sstart	start of alignment in subject
send	end of alignment in subject
evalue	expect value
bitscore	bit score
```
**Question 3.** Did you find a good hit in your species of interest? Is this actually the best hit compared to the other species (in terms of how long the hit is, identity and E-value)?

Now repeat these steps for *COX1* and *ND6* using informative names for the output files so you don't overwrite your previous results.

**Question 4.** You don't need to submit an answer to this one in the quizz, but it will help you later during the presentation of the proyect. Answer the same questions as for Q3 for these other two proteins. Is one of the proteins standing out from the others?

Return to the Genbank entry for the full mitochondrial genome of your species of interest. Locate the position information of the three genes.

**Question 5.** Has your BLAST search identified the same start and end locations as listed in Genbank? If there are differences, can you speculate about their reason? 
Some genes might start at a higher position and end at a lower one. Any idea why?  


---
## Report:
Please submit the answers in the quizz to the following questions: 1, 2, 3 and 5.

---

## Bonus: Collect additional mitochondrial genomes using online BLAST

**This section only applies to those who did not find at least 10 sequences when performing their database searches in Lab 1**

You may not have found at least 10 sequences in Genbank in Lab 1, for example, due to the quality of annotation of certain entries. It is very likely that there are far more sequences that are homologous to your sequences of interest than those found with your initial Genbank search. Therefore, use a few of your full mitochondrial genomes and CytB sequences to perform an [online BLAST search](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome). You can copy the sequence from your FASTA file and paste them into the query field on the BLAST website. From your BLAST hits, download enough sequences in FASTA format to fill up your dataset to a total of 10. Download only one hit per species.

*OBS!* Before choosing a sequence have a look at its length - the hits should not be much shorter than the query. Additionally, as a sanity check, you should see that all of your sequences have a relatively similar position on the mitochondrial genome (except possibly your outgroup sequences).

Add the new sequences to the FASTA file you created in Lab 2 and repeat the alignment with MAFFT. We will use this multiple sequence alignment in the coming sessions. Remember that these steps need to be done for both, the full mitochondrial genome as well as CytB.



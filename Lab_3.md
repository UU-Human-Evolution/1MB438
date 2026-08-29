# Session 3 - BLAST

## Introduction

In the last sessions, you collected and aligned mitochondrial sequences from databases that you will be using for the remaining sessions. Today, you will attempt to find genes in them using a simple similarity-based approach with BLAST, a tool for local alignment. Most of this practical will not directly contribute to your research question, but will rather provide some experience and further learning of concepts presented in the lectures. Nevertheless, if your data set of species was incomplete, or the alignment look bad, this methodology will allow you to supplement it with new sequences. 

### Goals

+ Revisit sequence databases from `Lab 1`
+ Become familiar with BLAST and its output
+ Find coding regions in the mitochondrial genomes using a similarity-based approach

### Input(s)

+ Full mitochondrial genomes collected in previous sessions
+ Protein sequences in FASTA format

### Output(s)

+ Alignments of genes with full mitochondrial genomes
+ Lists of hits in the different mitogenomes

### Tools

+ Sequence databases
+ BLAST (command line)


## Select a given species' mitochondrial genome

From the full mitochondrial genome sequences you collected in `Lab 1`, **select just one species of interest** (your choice!). Please check the `Genbank` entry for that sequence to make sure that it contains information about the start and end positions of mitochondrial genes. If it does, that genome is annotated.

**Question 1**: **What species did you select? Please write down the ID of the Genbank entry**.


## Collecting protein sequences

Now that you have a species to focus on, you want to obtain protein sequences **for three genes of interest**. Protein sequences can be obtained from [UniProt](https://www.uniprot.org/). Search the database for the **proteins** coded in *CYTB*, *COX1* and *ND6* genes, and download each sequence into a separate fasta file. Ideally, your species will have sequences for all three proteins. Make sure you name all files correctly (e.g. `CYTB_protein.fasta`, `COX1_protein.fasta`, `ND6_protein.fasta`).

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/1/15/Map_of_the_human_mitochondrial_genome.svg" width="700"/>
</div>

**Figure 3: Map of the human mitochondira**  
By Emmanuel Douzery | CC BY-SA 4.0

You now want to search for these protein sequences **in the selected mitochondrial genome** to identify coding regions corresponding to each of the three proteins in the nucleotide sequence. 

## Aligning protein to DNA sequences

Of course, we cannot directly align protein sequences with a nucleotide sequences as these systems are coded in a **different alphabet**. We use A, C, T and G to describe nucleotides in DNA sequences, while protein sequences are coded by letters corresponding to each possible aminoacid (A, V, K, T, R, etc.). Additionally, there are often alternative codons in the translation process, so the assignment of an amino acid to three nucleotides is ambiguous. 

T-BLAST-N ([tblastn](https://ftp.ncbi.nlm.nih.gov/pub/factsheets/HowTo_BLASTGuide.pdf)) is a handy tool for this purpose, as it takes an input protein sequence and compares it to a nucleotide database. As part of the process, the nucleotides in the database are translated into hypothetical proteins using all six possible reading frames. Therefore, the actual alignment does not take place between the protein and the nucleotide sequences, but rather the protein and all possible proteins generated from the nucleotide sequences.

BLAST can be run online or on the command line, and it can align the input sequence against the whole database, a subset of it, or only specific sequences of interest. In this session, you want to **align the three protein sequences to your mitochondrial genomes database**. So you want to run BLAST with a custom database.

### Prepare a custom database

Before the alignment can start, you need to prepare your reference database to include only those sequences you want to align the input to. For this, you use the function `makeblastdb`. This pre-processing of the database for multiple searches is one of the main reasons why BLAST is a great search algorithm.

```ruby
makeblastdb -in CYTB_ALL_SPECIES_nice_names.fasta -dbtype nucl 
```

**Question 2**: **How many new files are created? Can you read them? Try to find out what they are.**


### BLAST against a custom database

Now you can perform the BLAST search for your first protein. Let's start with *CYTB*, and make sure to use the names of your respective files:

```ruby
tblastn -query CYTB_protein.fasta -db CYTB_ALL_SPECIES_nice_names.fasta -outfmt 6 -out CYTB_protein.blast
```

Reflect yourself on the results. Open the output file (`.blast`). What do you see? Can you make sense of the different columns?

| Column name | Column description                                    |
|-------------|-------------------------------------------------------|
| qseqid      | query (e.g., unknown gene) sequence id                |
| sseqid      | subject (e.g., reference genome) sequence id          |
| pident      | percentage of identical matches                       |
| length      | alignment length (sequence overlap)                   |
| mismatch    | number of mismatches                                  |
| gapopen     | number of gap openings                                |
| qstart      | start of alignment in query                           |
| qend        | end of alignment in query                             |
| sstart      | start of alignment in subject                         |
| send        | end of alignment in subject                           |
| evalue      | expect value                                          |
| bitscore    | bit score                                             |


**Question 3**: **Did you find a good hit in your species of interest? Is this actually the best hit compared to the other species (in terms of how long the hit is, identity and E-value)?**

Now repeat these steps for *COX1* and *ND6* using informative names for the output files so you don't overwrite your previous results.

**Question 4**: **What about the other two proteins? Is one of the proteins standing out from the others?**

Return to the Genbank entry for the full mitochondrial genome of your species of interest. Locate the position information of the three genes.

**Question 5**: **Has your BLAST search identified the same start and end locations as listed in Genbank? If there are differences, can you speculate about the reasons why?** Some genes might start at a higher position and end at a lower one. Why?  


# STUDIUM QUIZZ
Please submit the answers in the quizz to the following questions: 1, 2, 3 and 5.

---

## Collect additional mitochondrial genomes using online BLAST

**This section only applies to those who did not find at least 10 sequences when performing their database searches in `Lab 1`**

You may not have found at least 10 sequences in `Lab 1`, e.g. due to the quality of annotation of certain entries. It is very likely that there are far more sequences that are homologous to your sequences of interest than those found with your initial Genbank search. Therefore, use a few of your full mitochondrial genomes and *CYTB* sequences to perform an [online BLAST search](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome). You can copy the sequence from your fasta file and paste it into the query field on the BLAST website. From your BLAST hits, download enough sequences in fasta format to fill up your dataset to a total of 10. Download only one hit per species.

**OBS!** Before choosing a sequence, have a look at its length: the hits should not be much shorter than the query. Additionally, you should see that all of your sequences have a relatively similar position on the mitochondrial genome (except maybe in your outgroup sequences).

Add the new sequences to the FASTA file you created in `Lab 2` and repeat the alignment with `MAFFT`. You will use this multiple sequence alignment in the next session. Remember that these steps need to be done for both the full mitochondrial genome and the *CYTB*.

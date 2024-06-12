# Session 2 - Alignments of mitochondrial sequences

## Introduction / Background information to Session 2

In this session, you will focus on alignments. As you have seen in the lecture, you can align two sequences (pairwise alignment) or multiple sequences (multiple alignments). Here, you will do a bit of both. For the pairwise alignment part, you will follow a tutorial that was developed by Rasmus Wernersson. For the multiple alignment part, you will continue to work with the mitochondrial genomes from the previous sessions. Obtaining a good alignment of your sequences will be essential for answering your groups question.

## Goals

  + Perform local and global pairwise alignments with different algorithms
  + Explore parameters of pairwise alignments
  + Perform multiple alignments and visualize them
  + Manipulate files

## Input(s)

  + complete mitochondrial genomes
  + sequences for cytB

## Output(s)

  + An alignment of mitochondrial genomes
  + An alignment of cytB

## Tools

  + Online alignment tools
  + Alignment program: [mafft](https://mafft.cbrc.jp/alignment/software/)
  + Alignment visualization program: Jalview

## Steps

  + Step 1: Pairwise alignment exercise
  + Step 2: Multiple alignment exercise

## Details

### Step 1: Pairwise alignment

Please go through the tutorial on [this page](https://teaching.healthtech.dtu.dk/22111/index.php/ExPairwiseAlignment).

Answer questions 1 to 14 (Not 0.0). Submit answers to all the questions to the Quiz in Studium.

### Step 2: Multiple alignments

You will now be working with the sequences you have collected last time. This also means that the results will depend on your selection. An outcome of today could also be that you decide to replace certain sequences as the alignment indicates some issues with them (e.g. they are not covering the full length or seem to show many mismatches/gaps). **During this session, we only perform the alignments, if you decide that you need to replace or add sequences, we will do that as part of a later session.**

#### Step 2a: Align the entire mitochondria

Start by login into Solander.

Finally, we will start by aligning your **full mitochondrial** genomes! We are going to use a software called `mafft`. 

Aligning this set of mitochondrial genomes is a computationally intensive task. 

In order to execute MAFFT, just type `mafft`. 
You will be asked several questions, among others: 
- the input file name (type in the fasta file you prepared),
- the output file name (type in the name of the fasta file you want to be called after alignment and include the file extension, `.fasta` in this case),
- output file format (sorted fasta),
- algorithm (choose `FFT-NS-1 (fast)`).

Once you have chosen all the options, the corresponding command-line will be printed on the screen.

**Question 2-1. Write down the command.**

Now, launch the alignment. It will take a while. In the meantime, you can work on the next step on another terminal window, which is another alignment, of a single gene. It is also a good time to take a break!

#### Step 2b: Align the sequences for the cytochrome B gene (cytB)

Nowadays there is an abundance of genomic data available, for organelles and entire genomes, for a large number of species. This is why in this session and the bioinformatics project, you are aligning the entire mitochondria. However, for a long time, it was more common to work with alignments of single genes (and in some cases, for instance when exploring the diversity in a given environment, it is still a common approach). Aligning single genes might also be a good approach when working with diverse species. And of course, it is much faster!

*Cytochrome b* is a gene found in the mitochondria of eukaryotic cells. The protein is part of the respiratory chain complex III, making it an essential part of the energy metabolism. Since all eukaryotes should have *cytB*, the gene can be used for species identification, and is often used to assess phylogenetic relationships between organisms

Proceed to the alignment with `mafft`. You can take the same command as the one you created when aligning for the entire genome.

You can look at alignments with the program Jalview.
**CAREFUL: if you are working on your own terminal most likely you are not going to be able to visualize it, the labs are designed to work on the university computers. You can [download](https://www.jalview.org/) the program to your own computer and then scp all the necessary files to view it locally.*

`java -jar ./<your_path>/jalview.jar`

**Question 2-2. Visually inspect your alignment. Do you notice anything odd? Does any sequence stand out visually (e.g. the outgroup)?**

  1. Correctly aligned sequences should have highly similar or even identical blocks;
  2. If you have one strange sequence which seems badly aligned either remove it or keep it but make a note which one it was;
  3. If you can't see identical blocks you should inspect the situation, you might have:
     1. Highly diverged sequences - then it's ok
     2. Mixture of sequences from different genes - then you might have a problem...
     3. Same gene in different orientations (+ and - strand instead of only +)
     4. Poor alignment of correct sequences - sometimes alignment algorithms are not doing a very good job...

**Question 2-3. Show your new alignment to a teaching assistant. If you cannot show it, submit the corresponding alignment file (.fasta).**

The main take-home message from this step is that it is important to examine your alignments well. Sometimes some sequences will genuinely be longer or shorter than other sequences; however, it might also be due to some errors!

#### Back to Step 2a

By now the alignment of the entire mitochondria should be ready for you to look at! Open it with `jalview`. What do you see?

**Question 2-4. Visually inspect the alignment of the full mitochondrial genome the same way you did for cytB in Q2-4. What do you notice? Are the same species standing out?**

---
## REPORT

Pairwise alignment tutorial: submit answers to all questions (you can number them 1-1, 1-2, etc).

Multiple alignment: submit answers to questions 2-1 through 2-4. For Question 2-2 and 2-4, it can be useful to include a screenshot of what you saw. Only submit the alignment (FASTA file) if you cannot show it to a teaching assistant.


---

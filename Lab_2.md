# Session 2 - Alignments of mitochondrial sequences

## Introduction

In this session, you will focus on sequence alignments. As you have seen in the lectures, you can align two sequences (pairwise alignment) or multiple sequences (multiple alignments). Here, you will do a bit of both. For the pairwise alignment part, you will follow a tutorial that was developed by Rasmus Wernersson. For the multiple alignment part, you will continue to work with the mitochondrial genomes from the previous sessions. Obtaining a good alignment of your sequences will be essential for answering your groups question.

### Goals

  + Perform local and global pairwise alignments
  + Explore the effect of changing parameters in alignment algorithms
  + Perform multiple alignments and visualize them
  + Manipulate files

### Input(s)

  + Multi fasta of the full mitochondrial genome
  + Multi fasta of the *CYTB* gene

### Output(s)

  + Alignment of the mitochondrial genomes
  + Alignment of the *CYTB* gene

### Tools

  + Online alignment tools
  + Alignment program [mafft](https://mafft.cbrc.jp/alignment/software/)
  + Alignment visualization programs [Jalview](https://www.jalview.org/) and [AliView](https://ormbunkar.se/aliview/)

### Key sections

  + Pairwise alignment exercise
  + Multiple alignment exercise


## Pairwise alignment

Go through the tutorial on [this page](https://teaching.healthtech.dtu.dk/22111/index.php/ExPairwiseAlignment).
Answer questions 1 to 14 and submit answers to all questions to the Quizz in Studium.

**OBS!** This part of the practical does not directly contribute to your research project but covers topics explained in the lectures and is a good preparation for the exam. Use it to further understand the alignment algorithms and how small parameter variations impact the alignment results.


## Multiple alignments

You will now be working with the sequences you collected on `Lab 1`. The results you obtain today could promt you to replace certain sequences as the alignment indicates some issues with them (e.g. they are not covering the full length of the gene/genome, they show many mismatches or gaps, etc.). **During this session, we only perform the alignments, if you decide that you need to replace or add sequences, we will do that as part of a later session.**

### Align the full mitochondria

We will start by aligning your full mitochondrial genomes! For that, we use the software called `MAFFT` (visit the [website](https://mafft.cbrc.jp/alignment/server/index.html) or the [paper](https://doi.org/10.1093/nar/gkf436)).

Aligning a set of mitochondrial genomes can be computationally intensive. 

In order to execute `MAFFT`, just type `mafft` in the terminal logged in the Solander server.

You will be asked several questions: 

- **Input file name** (type in the multi fasta file you prepared, e.g. `MT_ALL_SPECIES_nice_names`.fasta`),
- **Output file name** (type in the desired name of the aligned fasta, including the `.fasta` file extension),
- **Output file format** (we want a sorted fasta),
- **Alignment algorithm** (choose `FFT-NS-1 (fast)`)

Once you have chosen all the options, the corresponding command will be printed on the screen.

**Question 2.1**: **Write down the printed command.**

Now, launch the alignment. It might take a while. You can work on the next step on another terminal window or take a mini break.

### Align the *CYTB* gene

Today, there is an abundance of genomic data available, both for organelles and entire genomes, for a large number of species. However, for a long time, that was not the case, and it was more common to work with alignments of single genes. In some cases, it is still a common approach (e.g. when studying the ecological composition of an ecosystem, when working with very divergent species, etc). Of course, the computational resources used are less and all steps are much faster.

*Cytochrome b* is a gene found in the mitochondria of eukaryotic cells. The protein is part of the respiratory chain complex III, making it an essential part of the energy metabolism. Since all eukaryotes should have a *CYTB* gene, its sequence can be used for species identification and to assess phylogenetic relationships between organisms

For this single gene alignment, you will also use `MAFFT`. You can take the same command as the one you created when aligning for the entire genome.

## Visualize alignments

You can visualize alignments with many programs. `Jalview` and `AliView` are a very good options.
If you are working on your own computer and not logged in to Solander, you won't be able to visualize the alignments unless you download the softwares: [download Jalview](https://www.jalview.org/), [download AliView](https://ormbunkar.se/aliview/). If you are working on the university computers, you can just type any of the commands below to open the programs:

```
java -jar ./<YOUR_PATH>/jalview.jar ## JALVIEW
aliview  ## ALIVIEW
``` 

Alternatively, you can use this [online alignment visualization tool](https://alignmentviewer.org) through your web browser. You will first need to transfer the alignment fasta to your local computer (using `scp` or `rsync`) and then upload the file to the website. The alignment visualization in this tool is much worse than in the previous options.

**Question 2.2**: **Visually inspect your alignment for *CYTB*. Do you notice anything odd? Does any sequence stand out visually (e.g. the outgroup)?**

  1. Correctly aligned sequences should have highly similar or even identical blocks.
  2. If you have one strange sequence which seems badly aligned, either remove it or keep it but make a note which one it was.
  3. If you can't see identical blocks you should inspect the situation. You might have:
     - Highly diverged sequences - then it's ok.
     - A mix of sequences from different genes - then you have a problem...
     - The same gene in different orientations (`+` and `-` strand instead of only `+`)
     - A poor alignment of correct sequences - sometimes alignment algorithms are not doing a very good job...

**Question 2.3**: **Upload the alignment files (.fasta) in the Studium quizz.**

The take-home message from this step is that it is important to examine your alignments well. Sometimes some sequences will genuinely be longer or shorter than other sequences; however, this might also be due to errors!

### Back to the mitochondria...

The alignment of the full mitochondrial genomes should be ready for you to look at! Open it with `JalView` or `AliView`. What do you see?

**Question 2.4**: **Visually inspect the alignment of the full mitochondrial genome the same way you did for *CYTB* in question 2.2. What do you notice? Are the same species standing out?**


## STUDIUM QUIZZ

**Pairwise alignment**: Submit answers to the tutorial questions 1-14.

**Multiple alignment**: Submit answers to questions 2.1-2.4. For questions 2.2 and 2.4, it can be useful to include a screenshot of what you saw. Also submit the alignment file (`.fasta` format).

---

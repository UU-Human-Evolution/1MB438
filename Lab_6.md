# Session 6 - Phylogenetic Analysis

## An introduction to Phylogenetics
Since the eve of Biology as a field of Science, one of the key questions has been how do the different organisms we see today relate to each other, and how they evolved. In the old days, we used anatomical similarities (also known as [homologies](https://en.wikipedia.org/wiki/Homology_(biology))) and dissimilarities to try to reconstruct their evolutionary history. 
![Example of Homologies](https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Homology_vertebrates-en.svg/1280px-Homology_vertebrates-en.svg.png)

With the dawn of genetic sequencing and the genomic era, we can now establish those relationships with quite more certainty and in a less biased way. Using genetic data for inferring these relationships is known as Phylogenetics, and it is the "gold-standard" to stablish the relationship between modern species. 

### The Base of Phylogenetic Analysis 
The basic idea behind it all is quite simple: as species diverge over time, they accumulate mutations that the other groups don't share. So, when comparing several sequences, the bigger the number of differences between them, the larger the time since their common ancestor. However, this simple idea gets complicated quite soon, as we are working with really long sequences and, in some cases, long periods of time. This means that we will need to use robust statistical modeling in order to infer these relationships, that we will represent as a [phylogenetic tree](https://en.wikipedia.org/wiki/Phylogenetic_tree).

![Phylogenetic tree from Ersmark et al. 2016](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Phylogenetic_tree_for_wolves.jpg/468px-Phylogenetic_tree_for_wolves.jpg)

*Phylogenetic tree from Ersmark et al. 2016: https://doi.org/10.3389/fevo.2016.00134*

Each tree is a hypothesis of the relationship between our sequences, and our goal is to identify, from all the possible trees, the one that is most likely to be true according to our data. This may vary depending on the genomic region you are looking at, the models that you use or how you preprocess and align your sequences. 

So, with this in our minds, let's get going. 

## Goals 
+ Work with PAUP and learn how to extract information from its output
+ Create phylogenetic trees meaningful for our project's question

## Input
+ Aligned sequences of the complete mitochondrial DNA and CytB that we curated on Lab 5

## Output(s)
+ Several tree files 

## Tools
+ [PAUP](https://paup.phylosolutions.com/) 
## Details

For this Session, we are going to use the files that we created in the previous one. Make sure you followed the instructions properly and that you have all the files located. 


### Step 1:

As we performed the alignment of our sequences in the previous session, we can proceed to inferring which of all the possible trees is the most likely. We may use several methods to do this:

+ [Parsimony](https://www.mun.ca/biology/scarr/2900_Parsimony_Analysis.htm): "the simplest explanation that can explain the data is to be preferred", so the hypothesis with the smallest number of changes is the most likely. However, this method has plenty of assumptions that we know are false, so it is not used anymore.
+ [Neighbour-joining](https://academic.oup.com/mbe/article/4/4/406/1029664): A slightly more refined version of parsimony in which we chose the best tree by minimizing branch lengths in the tree. More computationally intensive than parsimony, but still something that a modern computer can do fairly quickly.
+ [Maximum Likelihood](http://ib.berkeley.edu/courses/ib200a/lect/ib200a_lect11_Will_likelihood.pdf): "Likelihood is defined to be a quantity proportional to the probability of observing the data given the model". This means that, by providing a model of how DNA sequences change, we can determine which tree is the most probable to be true. 
+ [Bayesian Inference](https://www.sciencemag.org/site/feature/data/1050262.pdf): This method uses Bayesian Statistics to combine prior information that we know about our data (also known as Prior Probability Distribution) with the likelihood, in order to transform it into a more accurate probability distribution, known as the Posterior.

![](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5624502/bin/emss-73449-f001.jpg)

*Prior, likelihood and posterior distribution for a two-parameter phylogenetic example in Nascimento et al. 2017: https://dx.doi.org/10.1038%2Fs41559-017-0280-x*

The last two are the state-of-the-art methods for phylogenetic analysis, and have become more and more popular as computing power has increased, as both methods are very demanding in that regard. However, for today's session we are going to focus on the 'naive' method: Parsimony. 

### An introduction to PAUP*
PAUP* is an abbreviation for *Phylogenetic Analysis Using Parsimony* and other methods.
PAUP is now a rather old program but is still the most flexible program for parsimony and maximum likelihood analyses. So even if it is slow it is still often use for non standard tasks and it is good for learning phylogenetics. PAUP* works very well for parsimony for all datasets, expept for very large ones (thousands of taxa). For those datasets it is possible to use TNT. Since maximum likelihood is more computationally heavy it gets unreasonable to run PAUP* on also fairly small datasets and it has been superseded by software like *RAxML*, *Garli*, *PHYML* or *iqTree*. Since PAUP* was the dominating software for phylogenetic
analyses for a long time it has also been influential on the syntax to give commands in many other programs, most notable *MrBayes*.

Input files for PAUP* are text files with blocks of data or PAUP commands in the NEXUS format. The file [primate-mtDNA-interleaved.nex](./DATA/Lab6/primate-mtDNA-interleaved.nex.txt) is an example of a data matrix (or alignment) in NEXUS format and [primate-tree.nex](./DATA/Lab6/primate-tree.nex.txt) is an example of a tree in nexus format. Take a look at them in a text editor. A NEXUS file is built up of a number of different blocks; the alignment is in a data block, the tree is in a trees block and so on.

You start PAUP from the command line:

 `paup`
 
At the PAUP prompt `>`, you type commands to PAUP. To get a list of all available commands, type

 `help`
 
For example, the command for executing a data file (in nexus format) is

 `execute primate-mtDNA-interleaved.nex`
 
PAUP* commands can be abbreviated as long as they are unambiguous

 `exe primate-mtDNA-interleaved.nex`
 
You can also execute a datafile at startup:

 `paup primate-mtDNA-interleaved.nex`
 
After you have read in a data block, you can read in a trees block. PAUP* complains if you try to execute a trees block without having first executed a data block.
A PAUP* command usually has a range of options, which each can have a type. The command set for example, has an option criterion, which has three types: Parsimony, Likelihood and Distance. These are the three criteria for selecting a tree that PAUP* implements. To specify a type of an option, use '=':

  `set criterion=parsimony`

####Calculate scores
If you have trees in memory (i.e. if you have executed a trees block or have searched for one), you can evaluate them using parsimony (pscores) or likelihood (lscores).
pscores calculates the tree lengths of trees in memory lscores calculates the likelihoods of trees in memory exec primate-mtDNA-interleaved.nex
 
 `exec primate_tree.nxs`
 
 `pscores` gives you the following tree length:
 
`Tree # 1`
`Length 1153`

whereas `lscores` gives you the log likelihood of observing the data for the given model and tree:

`Tree 1`
`-ln L 5988.05924`

To set options for parsimony and likelihood, use the commands pset (set options for parsimony
analysis), lset (set options for likelihood analysis). For example to specify parameters that correspond
to the Jukes-Cantor substitution model:

`lset nst=1 basefreq=equal rates=equal pinv=0`

Where nst is number of substitution types, basefreq is base frequencies, rates is the among-site rate variation and pinv is the proportion of invariable sites.

In summary, given a data set for a number of taxa, and a set of possible trees, we can select a best hypothesis (a
tree) using some kind of criterion, by which we can evaluate how good the tree is for this particular
data. Today we will evaluate trees using the **maximum parsimony** criterion. The most parsimonious
solution is the one that requires the **least amount of change**. Therefore, according to the maximum
parsimony criterion, the best hypothesis is the tree that requires the fewest changes, that is, the
shortest tree.

### Applying Maximum Parsimony to our data

Use the format conversion tool you used in Session 2 to convert your alignments for 16S and
cytB to nexus format.

`readseq -a -f17 in_file > out_file.nxs`

2. Use PAUP* to obtain a maximum parsimony tree for each of your genes.
Run the following file in PAUP* (replacing input and output names!):

`begin paup -l <name_log_file>;

exec input.nxs;

set criterion=parsimony;

# Now that you have set all the parameters run this command to get the trees

hsearch;

# You will see an output, please save the parsimony score, you will need it for later

savetrees file=output_pars.tre format=phylip brlens;

end;

quit;`

You can run the code from above as a script if you save it into a file and then run:

`paup <script_from_above>`

The trees are now in newick (also called phylip) format in the file output_pars.tre. In case you need
to convert the names in the output tree files you can use the tab-delimited file you generated in Session 5
and use the script called [x6_fix_names.pl](./SRC/Lab6/x6_fix_names.pl) to convert the taxon names. 

* Change the names in you output tree

`perl x6_fix_names.pl <tree tile> <name_table>`

* There can be more than one tree. Next, put each tree in one file and look at them
using *FigTree*. **Reroot the trees** with your outgroup species. Save them as pdf
files. Save the trees as well as your PAUP* logfiles. In order to run *FigTree*:

`figtree <tree.file>`


##### Question 1
* Which is the most parsimonious tree? Explain what it means to your phylogenetic question.

**Submit your answer and the PAUP log file to Studium** 



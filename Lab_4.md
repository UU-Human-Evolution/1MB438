# Session 4 - Phylogenetic Analysis

## An Introduction to Phylogenetics
Since the beinning of Biology as a field of Science, one of the key questions has been how do the different organisms we see today relate to each other, and how they evolved. In the old days, we used anatomical similarities (also known as [homologies](https://en.wikipedia.org/wiki/Homology_(biology))) and dissimilarities to try to reconstruct their evolutionary history. 
![Example of Homologies](https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Homology_vertebrates-en.svg/1280px-Homology_vertebrates-en.svg.png)

With the dawn of genetic sequencing and the genomic era, we can now establish those relationships with quite more certainty and in a less biased way. The practice of using genetic data to infer these relationships is known as Phylogenetics, and it is the "gold-standard" for establishing the relationship between modern species. 

### The Base of Phylogenetic Analysis 
The basic idea behind it all is quite simple: as species diverge over time, they accumulate mutations that the other groups don't share. So, when comparing several sequences, the bigger the number of differences between them, the larger the time since their common ancestor. However, this simple idea gets complicated quite soon, as we are working with really long sequences and, in some cases, long periods of time. This means that we will need to use robust statistical modeling in order to infer these relationships, which we will represent as a [phylogenetic tree](https://en.wikipedia.org/wiki/Phylogenetic_tree).

![Phylogenetic tree from Ersmark et al. 2016](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Phylogenetic_tree_for_wolves.jpg/468px-Phylogenetic_tree_for_wolves.jpg)

*Phylogenetic tree from Ersmark et al. 2016: https://doi.org/10.3389/fevo.2016.00134*

Each tree is a hypothesis of the relationship between our sequences, and our goal is to identify (from all the possible trees), the one that is most likely to be a true tree, according to our data. This may vary depending on the region you are looking at, the models you are using or how you preprocess and align your sequences. 

So, with this in mind, let's get going... 

## Goals
+ Test which substitution model works best with our data;
+ Work with IQTree and learn how to extract information from its output;
+ Create a phylogenetic tree that is meaningful for our project's question;

## Input
+ Fasta sequences of the complete **mitochondrial DNA** and **CytB** that we aligned in Lab 2

## Output(s)
+ IQTree file with relevant info on our tree
+ Tree file
+ Image files of your trees

## Tools
+ Maximum Likelihood  program: [IQTree](http://www.iqtree.org/)
+ FigTree, a phylogenetic tree visualization software

## Details

For this Session, we will use the files we created in the previous labs. Please make sure you follow the instructions properly and that you have all the files you need. 

**It's also a good idea to use the conversion script from session 1 to change to one of the shorter names in your fasta file!**


Since we have produced an alignment in the previous session, we can proceed to infer **which tree, of all the possible trees, is the most likely one**. There are several methods to do this:

+ [Parsimony](https://www.mun.ca/biology/scarr/2900_Parsimony_Analysis.htm): "**the simplest explanation that can explain the data is to be preferred**", so the hypothesis with the smallest number of changes is the most likely. 
 However, this method has plenty of assumptions that we know are false, so it is not used anymore.
+ [Neighbour-joining](https://academic.oup.com/mbe/article/4/4/406/1029664): A slightly more refined version of parsimony in which we chose the best tree by **minimizing branch lengths** in the tree. More computationally intensive than parsimony, but still something that a modern computer can do fairly quickly.
+ [Maximum Likelihood](http://ib.berkeley.edu/courses/ib200a/lect/ib200a_lect11_Will_likelihood.pdf): "Likelihood is defined to be a quantity proportional to the probability of observing the data given the model". This means that, **by providing a model of how DNA sequences change, we can determine which tree is the most probable to be true**. 
+ [Bayesian Inference](https://www.sciencemag.org/site/feature/data/1050262.pdf): This method uses Bayesian Statistics to combine **prior information** that we know about our data (also known as Prior Probability Distribution) **with the likelihood**, in order to transform it into a more accurate probability distribution, known as the **Posterior**.
  
![](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5624502/bin/emss-73449-f001.jpg)

*Prior, likelihood and posterior distribution for a two-parameter phylogenetic example in Nascimento et al. 2017: https://dx.doi.org/10.1038%2Fs41559-017-0280-x*

The last two are the state-of-the-art methods for phylogenetic analysis, and have become more and more popular as computing power has increased, as both methods are very demanding in that regard. 

For our project, we are going to use: 
- an implementation of the Maximum Likelihood approach called [IQ-TREE](http://www.iqtree.org/doc/Tutorial#first-running-example) 


As we mentioned earlier, any Maximum Likelihood approach is **based on a model**. In phylogenetics, this model **describes the probability of each substitution to happen**. [Here](http://evomics.org/resources/substitution-models/nucleotide-substitution-models/) you can find a list of the more common models, and [here](http://www.iqtree.org/doc/Substitution-Models) the ones that are implemented in IQ-TREE. 
![Substitution model representation](https://media.springernature.com/full/springer-static/image/art%3A10.1038%2Fnrg3186/MediaObjects/41576_2012_Article_BFnrg3186_Fig1_HTML.jpg?as=webp)

*Graphical representation of some substitution models from Yang & Rannala, 2012. Nature Reviews Genetics: https://doi.org/10.1038/nrg3186*

## IQ-Tree -- Generating ML trees

Now that we have a general picture of what we are doing, let's start working with IQ-TREE. The basic syntax for this software is:

```
iqtree -s ALIGNMENT -o OUTGROUP -m MODEL -pre OUTPUT_PREFIX -bb 1000
```
Replace the capitalized variables with your choices, e.g. replace `ALIGNMENT` with the name of your aligned FASTA file for the cytB gene.

Under OUTGROUP you should put the **name of your outgroup** as they appear in the alignment file. 
If you have multiple outgroups you can separate them with a comma (**make sure to have no spaces as separators!**) eg;

```
-o c_Vurs,H_sap

```

Now run IQ-TREE in your open terminal with the CytB data, and set your model to *-m MFP*. 
- *MFP* stands for ModelFinder Plus, and is an algorithm that automatically considers a list of substitution models & estimates which model is the one that fits our data better. 
- *-bb 1000* means that we want our algorithm to use [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)). 

## FigTree -- Create a visual representation of your Maximum Likelihood trees

In the .iqtree file, you have a representation of the trees. However, it is an unrooted tree. You can root the tree, and do many other things, with the program FigTree.

*If you can't get FigTree to work in a terminal you can try downloading it from https://github.com/rambaut/figtree/releases and installing it locally on your computer. It's very simple to run and even recommendable*
  
When you call FigTree, a ***visual interface will open***. In `File`, choose `Open` and select one of your Maximum Likelihood trees. If the software asks you to select a name for the labels on the tree, you can keep the default or choose a keyword, for example `bootstrap`. **Note that you do *not* want the `.iqtree`, that file is more of a logfile than an actual tree.**

The three important things you have to do are:
  
  1. Root the tree with your outgroup (select the branch and then select `Reroot`)
  2. Show the bootstrap values (using `Branch labels` or `Node labels` and selecting the right value to display)
  3. Make sure the tree can be easily understood. For example, you might need to change the name of the species, if you are using the short names that you used in [Session 1](Lab_1.md). 

You can use the script you used in Session 1 to change the names in your treefiles.
Once you are done with those, you can play around with the other options (for example Rotate and different type of trees).

Before you export your tree, think about what else you can do to show your results better. Look on Google for actually published trees, like the ones shown below
 
<p float ="left">
	<img src="./Figures/Phylogenetic-analysis-of-orchids-The-phylogenetic-tree-was-based-on-the-chloroplast.png" width="500">
	<img src="./Figures/Phylogenetic-tree-of-the-species-used-for-the-evolutionary-analysis-of-Hox-genes.png" width="500">
	<img src="./Figures/fig-3-corrected.png" width="500">
	<img src="./Figures/41598_2020_70287_Fig1_HTML.png" width="500">
</p>	


**Do not forget to export your trees as image files. You will have to show them during the presentation.**


**Question 1: Which files do IQ-TREE output? Explain briefly what each of them is.**

IQ-TREE creates several types of trees (e.g. a Neighbour Joining tree saved as .bionj file and an ML tree saved as .treefile). In order to properly visualize your tree, you'll need to use specific software, as trees are not represented in a way we can easily understand in our files. In order to plot them, we are going to use [FigTree](SRC/FigTree_v1.4.4). Download it onto your computer and start it. 


#####Question 2:
1. **Which model did ModelFinder choose? From all the criteria calculated by this software, which was used to determine the best-fitting model?**

2. **Briefly explain the best-fitting model.**

#####Question 4:

2. **In your tree, you can see a number at the base of each branch. That is the number of iterations that supported that branching during bootstrapping. Which is your least supported branch? What does that mean to your question?**


**Repeat these steps for the full mitochondrial genome alignments. Remember to adapt the command above to run IQ-TREE and be careful to not over-write your files.** 

# REPORT

Submit a file with the answers to all the questions and the *.iqtree* file for the CytB run.

---

This is the end of the lab, please make sure that you completed and wrote down the answers to all of the questions.


# Session 6 - Phylogenetic Analysis

## An introduction to Phylogenetics
Since the eve of Biology as a field of Science, one of the key questions has been how do the different organisms we see today relate to each other, and how they evolved. In the old days, we used anatomical similarities (also known as [homologies](https://en.wikipedia.org/wiki/Homology_(biology))) and dissimilarities to try to reconstruct their evolutionary history. 
![Example of Homologies](https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Homology_vertebrates-en.svg/1280px-Homology_vertebrates-en.svg.png)

With the dawn of genetic sequencing and the genomic era, we can now establish those relationships with quite more certainty and in a less biased way. Using genetic data for inferring thees relationships is known as Phylogenetics, and it is the "gold-standard" to stablish the relationship between modern species. 

### The Base of Phylogenetic Analysis 
The basic idea behind it all is quite simple: as species diverge over time, they accumulate mutations that the other groups don't share. So, when comparing several sequences, the bigger the number of differences between them, the larger the time since their common ancestor. However, this simple idea gets complicated quite soon, as we are working with really long sequences and, in some cases, long periods of time. This means that we will need to use robust statistical modeling in order to infer these relationships, that we will represent as a [phylogenetic tree](https://en.wikipedia.org/wiki/Phylogenetic_tree).

![Phylogenetic tree from Ersmark et al. 2016](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Phylogenetic_tree_for_wolves.jpg/468px-Phylogenetic_tree_for_wolves.jpg)

*Phylogenetic tree from Ersmark et al. 2016: https://doi.org/10.3389/fevo.2016.00134*

Each tree is a hypothesis of the relationship between our sequences, and our goal is to identify, from all the possible trees, the one that is most likely to be true according to our data. This may vary depending on the region you are looking at, the models that you use or how you preprocess and align your sequences. 

So, with this in our minds, let's get going. 

## Goals 
+ Test which substitution model works better with our data
+ Work with IQTree and learn how to extract information from its output
+ Understand substitution models and how to export them between tools
+ Run a basic model in BEAST
+ Create phylogenetic trees meaningful for our project's question

## Input
+ Aligned sequences of the complete mitochondrial DNA and CytB that we curated on Lab 6

## Output(s)
+ IQTree file with relevant info on out tree
+ Several tree files 

## Tools
+ Maximum Likelihood  program: [IQTree](http://www.iqtree.org/)
+ Bayesian Phylogenetic Inference program: [BEAST](https://www.beast2.org/)

## Details

For this Session, we are going to use the files that we created in the previous one. Make sure you followed the instructions properly and that you have all the files located. 


### Step 1:

As we performed the alignment of our sequences in the previous session, we can proceed to inferring which of all the possible trees is the most likely. We have several methods to do this:

+ [Parsimony](https://www.mun.ca/biology/scarr/2900_Parsimony_Analysis.htm): "the simplest explanation that can explain the data is to be preferred", so the hypothesis with the smallest number of changes is the most likely. However, this method has plenty of assumptions that we know are false, so it is not used anymore.
+ [Neighbour-joining](https://academic.oup.com/mbe/article/4/4/406/1029664): A slightly more refined version of parsimony in which we chose the best tree by minimizing branch lengths in the tree. More computationally intensive than parsimony, but still something that a modern computer can do fairly quickly.
+ [Maximum Likelihood](http://ib.berkeley.edu/courses/ib200a/lect/ib200a_lect11_Will_likelihood.pdf): "Likelihood is defined to be a quantity proportional to the probability of observing the data given the model". This means that, by providing a model of how DNA sequences change, we can determine which tree is the most probable to be true. 
+ [Bayesian Inference](https://www.sciencemag.org/site/feature/data/1050262.pdf): This method uses Bayesian Statistics to combine prior information that we know about our data (also known as Prior Probability Distribution) with the likelihood, in order to transform it into a more accurate probability distribution, known as the Posterior.
![](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5624502/bin/emss-73449-f001.jpg)

*Prior, likelihood and posterior distribution for a two-parameter phylogenetic example in Nascimento et al. 2017: https://dx.doi.org/10.1038%2Fs41559-017-0280-x*

The last two are the state-of-the-art methods for phylogenetic analysis, and have become more and more popular as computing power has increased, as both methods are very demanding in that regard. 

For our project, we are going to use an implementation of the Maximum Likelihood approach called [IQ-TREE](http://www.iqtree.org/doc/Tutorial#first-running-example). This software offers several methods to speed up the analysis. 

As we mentioned earlier, any Maximum Likelihood approach is based on a substitution model. In phylogenetics, this model describes the probability of each substitution (or mutation) to happen. [Here](http://evomics.org/resources/substitution-models/nucleotide-substitution-models/) you can find a list of the more common models, and [here](http://www.iqtree.org/doc/Substitution-Models) the ones that are implemented in IQ-TREE. 

![Substitution model representation](https://media.springernature.com/full/springer-static/image/art%3A10.1038%2Fnrg3186/MediaObjects/41576_2012_Article_BFnrg3186_Fig1_HTML.jpg?as=webp)


*Graphical representation of some substitution models from Yang & Rannala, 2012. Nature Reviews Genetics: https://doi.org/10.1038/nrg3186*

Now that we have a small picture of what we are doing, lets start working with IQ-TREE. The basic syntax for this software is:

```
iqtree -s ALIGNMENT -o OUTGROUP -m MODEL -pre OUTPUT_PREFIX -bb 1000
```

Under OUTGROUP you should put the name of your outrgroup as they appear in the alignment file. If you have multiple outgroups you can separate them with a comma (no spaces!) eg;

```
-o c_Vurs,H_sap

```

Now run IQ-TREE in your interactive session with the CytB data, and set your model to *-m MFP*. *MFP* stands for ModelFinder Plus, and is an algorithm that automatically considers a list of substitution models and estimates which is the one that fits our data better. *-bb 1000* means that we want our algorithm to use [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)).Remember to adapt the code above to run IQ-TREE  and be careful to not over-write your files. 

All the questions below refer only to the CytB output.

**Question 1: Which files do IQ-TREE output? Explain briefly what each of them is.** 

Now let's look at the *.iqtree* file. 

**Question 2: Which model did ModelFinder choose? From all the criteria calculated by this software, which was used to determine the best-fitting model?**

**Question 3: Briefly explain the best-fitting model.**

### Step 2:
BEAST2 is a program for doing Bayesian phylogenetic analysis. The program uses a Markov Chain Monte Carlo (MCMC) method for exploring the parameter space in a stepwise fashion. Each new step is either accepted or rejected based on the change in likelihood. The posterior probability for each parameter is based on the frequency with which the parameter values are observed.
Its input files are in the NEXUS or FASTA alignment format. You will work on your own two datasets (in nexus format).
BEAST2 uses different GUI apps for the different steps, so we will need to change the name of the app accordingly.
The first step is to create an XML file with the settings for our BEAST run. This is done with BEAUTi
`beauti`

Once the new window pop up, you have to import the alignment file. You can do it from the *File/ Import Dataset* menu or by clicking in the "+" symbol in the lower left corner.
Once you have the alignment loaded, we need to specify the settings we are going to run BEAST with. BEAUTi offers a lot of different options, and we can even subdivide our alignment to apply different models to different regions, estimate split times, etc.

However, as we are only interested on reconstructing the phylogeny of our sequences, we are going to modify only a few of the settings.
The first one is the Evolution Model, which can be done through the Site Model tab. As we are going to use the same model IQTree selected, and BEAST only have integrated models for JC69, TN93, HKY and GTR, you may need to modify one of these to adapt it to your actual model. This can be done by modifying the XML file (explained here: https://beast.community/custom_substitution_models) or from BEAUTi by following this table (source: https:// justinbagley.rbind.io/2016/10/11/setting-dna-substitution-models-beast/)

![BEAST Model Setup table](Figures\BEAST2-model-setup.png)

If your model has some other letters, like "+I" or "+R", you can find what they mean here: http:// www.iqtree.org/doc/Substitution-Models and modify the settings accordingly.
Once we have everything set up in the Site Model, we move to the Priors tab, select Calibrated Yule Model, and as a birth rate a Gamma distribution with an Alpha (shape) of 0.001 and a Beta (scale) of 1000.
The last step is to go to the MCMC tab to specify how many steps the MCM chain will take before stopping. This should be set to, at least, 100000.
Once this is done, we can save the XML file and close BEAUTi.

**Question 4: Which setup did you use in BEAST2?** 




####OPTIONAL:
BEAST offers many other options and tools to be sure our estimates are appropriate that were left out from this tutorial because the fall out of our scope, but if anyone is interested, you can check the tutorials in the software webpage or this great introduction https://taming-the-beast.org/tutorials/Introduction-to-BEAST2/

# REPORT

Submit a file with the answers to all the questions and the *.iqtree* file for the CytB run. 


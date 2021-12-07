# Session 3 - Identification of Coding Sequences

##### Goals of the practical session

The goal of this session is to be able to locate the functional regions of a given genome for which we don't have any previous annotation. 

##### Assessment of the practical session:

Work alone or in pairs during this lab. As you progress, take notes of answers to the questions highlighted in red in the designated black boxes, or on a paper sheet. At the end of the lab, you should approach one of the teaching assistants present, and ask them to check your answers. They will discuss incorrect answers with you. Once the assistants have approved your answers, they will mark your attendance and the practical session is considered completed. 

##### Preparing our session: 

For today’s lab we are going to work on Uppmax, so we’ll need to log in on our terminals and create an interactive session as we already explained in previous labs. Once we are on our interactive session, we need to run the next command to have all the modules available:

```
module load bioinfo-tools emboss artemis BioPerl
```

## The problem:

For this session and the next, we are going to work with a sample retrieved from a real patient in the context of an Enterohemorrhagic Escherichia coli (EHEC) outbreak. The sequence contains the complete plasmid sequence. Plasmids are small sequences of DNA present in some bacteria outside the circular chromosome. Bacteria can share them via horizontal gene transfer in a process called "conjugation" and, this plasmids have a huge influence on virulence, pathogenicity and antibiotic resistance. With that in mind, we want to fully characterize this sequence, in order to inform the doctors of how to properly combat this new outbreak of EHEC.



![Diagram of the process of bacterial conjugation.](C:\Users\pedmo131\Documents\GitHub\1MB438\Figures\DNA-processing-during-bacterial-conjugation-1-The-relaxase-R-cleaves-plasmid-DNA-at.png)

*Steps of the bacterial conjugation*

## Gene identification tools

Gene finding is a central aspect of bioinformatics, and a key issue when trying to make sense out of new and/or unknown sequence such as our plasmid. There are several different ways to do this and what is best will depend on what genome is being analyzed, especially whether it is prokaryotic or eukaryotic. Methods range from finding stretches without stop codons, via homology comparisons with other, closely related sequences, to highly sophisticated neural networks. Gene finding in eukaryotes is particularly difficult and typically requires cross-validation between several complex methods. In prokaryotes, though, it is quite more straightforward. In most cases a simple search for open reading frames (ORFs) is usually sufficient to get a good set of candidate genes for further analysis. 

#### Simple ORF search 

The most simple and naïve way to search for genes is to search your input sequence for the initiation codon ATG followed by a stretch of DNA free from an in-frame stop codon. Since almost all gene products are larger than 50 amino acids, it is reasonable to set the minimum length of your ORFs to 150 nucleotides.  

You will deal with the program getorf in the EMBOSS suite (EMBOSS suite.pdf) In order to use getorf with a minimum ORF size of 150 nucleotides and a search from ATG to stop, type  `% getorf XXX.fna -minsize 150 -find 3`  on the commandline. Genes might be located on the opposite strand to the sequenced one, but this is not a problem since getorf will still find it and note the direction of the gene in its output. Note that STOP codons are not included in the output. That issue, however, will be fixed by the script that 
parses program output to a format that can be used in the visualization tool Artemis (more details 
below).

**Now, run getorf on your plasmid. Save the result.** 








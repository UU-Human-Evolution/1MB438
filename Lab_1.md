# Bioinformatics project

Mitochondria are organelles present in all eukaryotic cells and their main function is to provide chemical energy to the cell or organism they belong to in the form of ATP (for a review, see [Roger et al. (2017)](https://doi.org/10.1016/j.cub.2017.09.015)). In humans, each cell can contain up to 1,000-2,000 mitochondria, and each mitochondria itself can contain a few (2-10) mitochondrial genomes. Mitochondrial genomes are nevertheless much smaller than nuclear genomes, with the human mitochondrial genome being 16,000 base pairs (bp) and containing 37 genes only. Additionally, mitochondrial genomes are quite conserved across species, specially in the protein-coding, rRNA and tRNA gene sequences. It's high abundance, small size and conservation degree make mitochondrial DNA (mtDNA) a great option for both laboratory and bioinformatic work in the field of comparative genomics.

In this lab, we will take advantage of these properties to conduct a small phylogenetic project from scratch.

<div align="center">
  <img src="https://www.researchgate.net/publication/388510620/figure/fig2/AS:11431281388599233@1745186284998/Molecular-structure-of-mtDNA-Mitochondrial-DNA-mtDNA-is-a-circular-double-stranded_W640.jpg" width="500"/>
</div>

**Figure 1: Simplified structure of a mitochondrion**  
Author: Kelvinsong, modified by Sowlos | CC BY-SA 3.0


## General instructions

You will work in groups on a bioinformatics project to answer one of the evolutionary biology questions below. Over the coming sessions, you will gather the genomic data necessary to answer this question, format it, align it and finally build a phylogenetic tree of your chosen taxa. You will then present the obtained results to the class. The teaching assistants will help and guide you through the project, but the decisions are ultimately yours and you will need to consider the potential downstream effects of your choices. 

We made a short checklist [here](Troubleshooting_checklist.md), which includes instructions to use `sftp` to transfer files to and from Solander.


## Research questions

1. What non-flying mammals are closely related to bats?
2. Both whales and sea cows originate from land-living animals. Do they have a common ancestor that transitioned from land-to-water or has this transition occurred twice independently?
3. Are salamanders more closely related to frogs than to lizards?
4. What are the closest relatives of octopuses and squids?
5. Is the guinea pig more closely related to rats than to pigs?
6. What other cat-like animal is most closely related to the cheetah?
7. Are egg-laying mammals (platypus and echidna) more closely related to birds than to placental mammals?
8. Are moose more closely related to reindeer than to other deer species?
9. Describe the phylogeny of primates!
10. What type of wolves is the ancestor of domestic dogs?
11. Are porcupines closer to pigs or hedgehogs?


# Session 1 - Database search

In this session, you will collect genomic data to work with during the coming sessions. When collecting genome sequences, you need to think about what specific species you want to compare. The questions above often do not include a particular species but rather groups of species, so you might need to collect multiple sequences per taxa. In addition to the species directly connected to your question, you should include one distantly related species to all of them (a so-called "outgroup") which is required for later analyses. The picture below helps to understand the concept of "ingroup" and "outgroup", we will get back to this in the phylogenetics part of the course: 

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/50/Outgroup.jpg?20171109021005" width="600"/>
</div>

**Figure 2: Outgroup(s) and ingroup(s)**  
Author: Ngilbert202 | CC BY-SA 4.0

A possible research question in the above figure would have been to see if `C` is more related to `B` or to `D`, and the answer would then be that `C` is phylogenetically closer to `D` because they share a more recent common ancestor. In this set up, `A` was of no scientific interest but served the purpose to correctly root the tree. If you are unsure what would be an appropriate outgroup for your question, ask the teaching assistants!


## Selecting species of interest

First start by actually selecting what species you should use to answer your research question. Discuss about what species you need to actually answer it and what species could serve as an outgroup. If you have a hard time coming up with good candidate species you can use the [NCBI taxonomy browser](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Root). You should end up with 10-20 species in your dataset, of which 1-2 should be an outgroup. 

**Question 1**: **Write down a few sentences on the selection of species and outgroup in your dataset. Which species did you choose and why? Explain how the species you picked would resolve the phylogenetic relationship the question posed.** 

It is possible that you do not find data for some of the species you initially choose. In that case, update your answer accordingly and add more species if needed. This will help you later to reflect upon the question and your results.

## Collecting DNA sequences

Your main task for the day is to collect:

- The full mitochondrial genome for all species in your dataset.
- The *CYTB* (cytochrome b) gene for all species in your dataset.

Below are the steps you should follow:

* Go to [NCBI Genbank](https://www.ncbi.nlm.nih.gov/nucleotide/), a database of DNA, RNA and protein sequences.
* Search for one species of interest in the search bar.
* On the left, under `Genetic compartments`, select `mitochondrion`. There you will find all entries of mitochondrial sequences for that species.
* Look for an entry listed as `complete genome`, which should be around **17,000 bp long**.
* Click on the entry, then on `FASTA`, and download the fasta file for the entry to your computer.
  - You will end up with two fasta files per species.
  - It's good to name them in an understandable way (e.g. `MT_monkey.fasta` and `CYTB_monkey.fasta`).
* Repeat the first two steps for *CYTB*.
  - A good option is to search for entries called `cytochrome b` and `complete cds`.
  - The second option is to take a full mitochondrial genome sequence that is annotated (scroll down and see if there are genes and coding sequences listed). There, you can sarch for "CYTB", right click on the link `gene` and choose `open link in new tab`. It should open a separate `Genbank` page specific to your gene of interest which you can then download as described above. Some mitochondrial genomes are not annotated and therefore that's not possible.

**Always check the length of the downloaded sequences... *cytB* should be much shorter than the 17,000 bp of the full mitogenome!**


### Incomplete cases

Preferably, you should get both the full mitochondria and the *CYTB* sequences for all species in your dataset. It might be that you cannot find both sequences for a given species. If the specific species is not crutial, try again with a close relative. If it is really difficult to find enough species with both sequences, ask a teaching assistant.

## Creating multifasta files

Once you have all sequences for your dataset, you will need to put them together in a single fasta file (**OBS!** One fasta file for the full mitochondria and one for the *CYTB* gene). Here, you can practice your bash coding to concatenate sequences from different files. Think about combining `cat`, `>>` and `*`. You should end up with two documents, one containing all fasta sequences for the full mitochondrial genome (e.g. `MT_ALL_SPECIES.fasta`) and one containing all fasta sequences for the *CYTB* gene (e.g. `CYTB_ALL_SPECIES.fasta`).

## Creating a name conversion table

Because most softwares won't recognise the fasta headers in your fasta files, you need to provide shorter, understandable names for each sequence. You can do this with two scripts that we have prepared and allow the substitution of a string (e.g. "J01415.2:14747-15887 Homo sapiens mitochondrion, complete genome") by another string (e.g. "Hsapiens").

- Locate the `python` script `x1_create_tab-delimited_file_from_fasta.py` in your directory ([SRC folder](SRC/x1_create_tab-delimited_file_from_fasta.py))
- Use it to create a tab-delimited file with three columns with the script:

```ruby
python /<YOUR_PATH>/x1_create_tab-delimited_file_from_fasta.py <YOUR_COMBINED_FASTA_FILE>
```

The above command should print a 3-column tab-separated output to the terminal ([see example](DATA/Lab5/worms_example_name_table.txt)).  
Write the output to a file:

```ruby
python /<YOUR_PATH>/x1_create_tab-delimited_file_from_fasta.py “YOUR_COMBINED_FASTA_FILE” > CYTB_species_names.tab
```

Each row contains information on each sequence in your data set, including: 

1. A field to be manually modified after the file has been generated.
   * This field should be maximum 8 characters long (e.g. "Hsapiens")
2. An easy-readable name (good for presentation to others: e.g. "Homo_sapiens").
   * You can manually modify this field too. **OBS!** Do not use spaces!
3. A globally unique identifier (e.g. "NC_026542.1:14178-15317")

You should modify the generated document to create nicer names that will be readable for all programs.

## Editing the fasta headers

With the name conversion table, you can now update the names in the multifasta very easily:

- Rename your sequences in the fasta files so that the headers contain the short names from your conversion table.
   * You can use the `python` script `x1_convert_to_short-names.py` ([SRC folder](SRC/x1_convert_to_short-names.py)):

```ruby
python /<YOUR_PATH>/x1_convert_to_short-names.py CYTB_ALL_SPECIES.fasta CYTB_species_names.tab > CYTB_ALL_SPECIES_nice_names.fasta
```

- You can use any other name, but should remember what each file contains. 


# STUDIUM QUIZZ

Submit the answer in the quizz to **Question 1** (text).

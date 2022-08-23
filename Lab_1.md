# Session 1 - Sequence retrieval using Entrez

##### Goals of the practical session

In this exercise you will search in the NCBI sequence databases using the search system [ENTREZ](https://www.ncbi.nlm.nih.gov/search/) (see [Using_Entrez](extra/using_entrez.md) for information about how to perform searches). Also have a look at the [introduction_to_biological_databases](extra/introduction_to_biological_databases.md) to get some background to this area.

##### Assessment of the practical session: 

Work alone or in pairs during this lab. As you progress, take notes of answers to the questions highlighted in red in the designated black boxes, or on a paper sheet. At the end of the lab, you should approach one of the teaching assistants present, and ask them to check your answers. They will discuss incorrect answers with you. Once the assistants have approved your answers, they will mark your attendance and the practical session is considered completed.


## Search for an accession number

Use this server for the online part: [Entrez](https://www.ncbi.nlm.nih.gov/search/)

Search the **Protein** database for the sequence with accession number *Q9ZAW3*. Take a look at the entry page from your search (see a GenBank entry for some help to understand the structure of the entry).

###### Question 1
1.  **From what organism is the sequence?**
2.  **What is the name of the protein?**
3.  **What is the function of the protein?**

#### Change display

The entry can be displayed in different formats. The most commonly used format for sequences is FASTA, it is a simple format which contains a one-line header and the sequence. The header starts with '>' and some information which is used as an identifier for the sequence.

`>NAME_OF_SEQUENCE
ACTGCTGTAGCTAGCTGCGCTGATCGCTAGCATC
GCTACTCGTACGATCGTAGCTACGTTACGCTGAT`

At the top of the entry, under the search box, you can choose different ways to display the query. Display the query as FASTA, by choosing 'FASTA' below the page headline.

###### Question 2
Report the sequence in FASTA format.

## Search by using Organism name

In most of the cases you would probably not know the accession number of the sequence that you are looking for. This means that you have to use other search terms to get your sequence from the database. 

You want to find a protein in the bacterium *Bartonella henselae*. Search the **Protein** database for *Bartonella henselae*.

###### Question 3
1. How many entries do you get?
2. Are all of them from *Bartonella henselae*?

## Search with Limits

Searching the database as done in in the previous step is not very efficient since in almost all cases you will get sequences that you don't want. This is because you are searching against all the words in the **GenBank** record for your query. This means that if, in this case, *Bartonella henselae* is present anywhere in the entry we will pick it up. As a result, we get a lot of false positives. To get a better result you can limit your search so that you only search for a word in a specific field in the GenBank record.
Since *Bartonella henselae* is the name of an organism, the field *Organism* in the GenBank record should contain the name *Bartonella henselae* to be a true positive.

Redo the same search as in **“Search by using Organism name"** but limit the search in 'Organism' field by choosing **Advanced->Search Field Tags->Organism**.

###### Question 4
1. How many entries do you get?
2. Are all of them from *Bartonella henselae*?

## Combining searches

You have now learnt how to limit your search, but for an even better result you can combine different searches. Let's say that you want to find a particular gene or protein in Bartonella henselae, in that case you can't use the limit organism and at the same time write both Bartonella henselae and the name of the gene or protein. You have to combine two different searches using two different limits.

You have already made a search using '*Bartonella henselae* Field: Organism'. Now do a search using the limit Gene Name and write **ftsA** in the query box. Then click on the link 'Advanced Search' and select the two searches histories that you want to combine under 'Search History'. You can read how to use it under the link 'Search History Instruction'. Click 'Search' when you have done with combing the searches.
Alternatively, you can combine searches directly in the 'Search details' box on the right, once you know the names of the fields and how to combine them.
**Hint: Use Display Settings on the search hit page to sort the hits by 'Date Released'. It's then sorted from latest to earliest.**

###### Question 5
1. What is the accession number of the earliest submitted protein record for ftsA from
*Bartonella henselae*?
2. What is the name of the first author of the article where that sequence was published?

## Using the links between the different databases

As mentioned earlier one of the best things with Entrez is that all databases have links between each other. Up until now you have used the protein database, but now you want to have the nucleotide sequence for the ftsA gene from *Bartonella henselae*.

In the entrez page do a search for ftsA. Now select 'Nucleotide' database under the “Genomes” header.
Alternative: If you have already done a protein search for ftsA you can in the search results pages change database in the dropdown menu to “Nucleotide”.

###### Question 6
1. What is the accession number of the earliest submitted nucleotide record for ftsA from *Bartonella henselae*?
2. What other genes are included in the same nucleotide sequence?

## Pairwise alignment 

![Example of a pairwise alignment scoring method](main/Figures/Scoring-a-pairwise-alignment-a-detailed-example.png)

Pairwise alignment consist on the comparation of two sequences from different individuals/species, with the goal of finding regions similar between the two. This regions may reflect conserved regions with functional, structural or evolutionary relevance. 

You can find a detailed tutorial on Pairwise alignment [here](https://teaching.healthtech.dtu.dk/teaching/index.php/ExPairwiseAlignment)

###### Question 7
1. Submit all the answer to the questions in the tutorial. 

**Submit the answers to all 7 questions to the Studium assignment.**


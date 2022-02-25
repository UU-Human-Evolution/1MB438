# Lab 4 - Genome Annotation 

##### Goals of the practical session

In this lab we well continue to work on our plasmid sequence. While in Lab 3 we identified putative gene regions, in this lab we are going to use existing tools and some basic knowledge on database building to annotate it. Then, we will validate our results with some external software. 

##### Assessment of the practical session:

Try to work in the same pairs you had in Lab 3 (if you had one). As you progress, take notes of answers to the questions highlighted on this protocol on a text document or on a paper sheet. At the end of the lab, you should approach one of the teaching assistants present, and ask them to check your answers. They will discuss incorrect answers with you. Once the assistants have approved your answers, they will mark your attendance and the practical session is considered completed. If there is not time for you to present your answers, you can submit them via Studium. 

##### Preparing our session: 

For today’s lab we are going to work on Uppmax, so we’ll need to log in on our terminals and create an interactive session as we already explained in previous labs. Once we are on our interactive session, we need to run the next command to have all the modules available:

```
module load bioinfo-tools ABINIT/8.10.3 BLAST+ sqlite/3.34.0 BioPerl artemis biopython 
```





### Genome annotation

In the context of genomics, an annotation is a definition of the genes, their characteristics and descriptions.   As raw sequencing data can't tell us what parts of it are functional or what function does each region plays, annotating a genome is, in its most basic sense, making our nucleotide sequence meaningful. As a process of identification of genes and coding regions' physical locations within the chromosome, genome annotation helps us have an insight on what these genes do  by stablishing structural aspects and relating them to functions of different proteins.  

We already started with this process in our previous session identifying putative coding regions and their associated promoters. In this session we will continue exploring those regions and try to end up with some useful information about our selected plasmids. 

### Workflow

Today you are going to use the output from GeneMarkS together with BLAST-searches on curated databases of regions associated with phenotypes of interest. You will put the results from both GeneMarkS and BLAST in a SQLite database and query the database to study different set of genes. 

##### SQLite

In this exercise you're going to use a database to store all your results. We will use SQLite since it is 
lightweight and easily portable since the database will be in a single file. Since SQLite is lightweight it 
is also possible to pack the database manager with different applications.  

You can simply open a database by typing:

`sqlite3 my_database.db`

If the database does not already exist it will be created. Now you will be presented with a new 
prompt, which looks something like this: `sqlite>`  

From this prompt you can do `select`,` create table` and all kinds of fun stuff. For example you can 
look at all created tables and the command used to create them using:  
`.schema`  

That should return nothing since nothing has been created in the database at this point. To create a 
table that contains three entries (store_id, name of the product and price) you can type the following 
command: 
`create table grocery_shop_stock( store_id INTEGER, name TEXT, value REAL, PRIMARY KEY(store_id));`

Now try again `.schema`



To quit SQLite you type: 

`.q  `

For more SQL see the reference links below, especially the SQL-commands will be useful to answer the 
questions.  It might be a good an idea to practice with the SQL tutorial (see links below). Most of the 
commands that you will need are in there.  To really get some utility out of the database it's best to call it from a script. 

Further info 

[SQLite homepage](https://www.sqlite.org/index.html)  

[SQLite data types](https://www.sqlite.org/datatype3.html) (for when creating tables) 

[W3School SQL Tutorial  ](https://www.w3schools.com/sql/default.asp) 

#### Extracting our ORFs

In order to annotate the regions we identified during the Gene Prediction in the last sessions, we need to extract the nucleotide sequence, the associated header and the coordinates. Something like this: 

```
>orf_1 23-455 
ATGCTGC.... 

>orf_2 489-782 
ATGACCA... 
```

This is done in the script called `ExtractORFs.py` which uses a python library called `biopython` to 
extract the ORF sequences from the genome and put them in a multifasta file. It names the ORFs 
orf_1, orf_2, orf_3 etc, and puts the genome coordinates in the fasta header.  

**Exercise:**   

1. Use `ExtractORFs.py` to extract the ORFs.
      ` python ExtractORFs.py <in_fasta_file> <genemark_file> `   
2. Save  the output as a new file. 

Now you want to load your results, as well as the translation of the ORFs into amino acids, into a 
database. The first step is to create a database and a table in the database. This table should 
store each ORF and relevant metadata, such as name, length and its' translation. The easiest way 
to do this is to use the SQLite program and create the table with the command create table (see 
SQL-commands).  

In the table that you will create the following information is required: 

* Name 
* Nucleotide sequence 
* Amino-acid sequence 
* Amino acid sequence length 

This can be done with the following commands:  

```
sqlite3 my.db 
create table orfs(orf_id CHAR, nucleotides CHAR, aminoacids CHAR, length INTEGER, PRIMARY KEY(orf_id)); 
```



**Exercise:** 

1. Create the ORFs table in your database that you named `my_database.db` (see above) 
2. Next you want to populate the table. Use `Gene2SQLite.py` that both translates your ORFs 
   into peptides and insert the data into the table you just created. Inspect `Gene2SQLite.py` 
   to see what arguments the scripts takes as input. OBS! Name the peptide translation as `x_orfs_peptides.fas` (where x is the plasmid you are looking at).  

3. **(Optional)**  Take a look at  `Gene2SQLite.py` and follow what the script do.  

Check the translation file, same way you were checking the correct translation from the 6 
possible ones in Lab 2, to make sure nothing went wrong! When you have the data in a 
database many of these comparisons are easy.  

You can check your beautiful table in sqlite by something like this :  

```
sqlite> SELECT orf_id FROM orfs; -- you will print all the orf names listed in the table –  
sqlite> SELECT * FROM orfs; -- you will print the entire table --  
sqlite> SELECT AVG(length) FROM orfs; -- Extract the average length of all orfs                        
sqlite> SELECT orf_id, length FROM orfs WHERE length > 100; -- print orfs with length above 500  
```


# Lab 4 - Genome Annotation 

##### Goals of the practical session

In this lab we well continue to work on our plasmid sequence. While in Lab 3 we identified putative gene regions, in this lab we are going to use existing tools and some basic knowledge on database building to annotate it. Then, we will validate our results with some external software. 

##### Assessment of the practical session:

Try to work in the same pairs you had in Lab 3 (if you had one). As you progress, take notes of answers to the questions highlighted on this protocol on a text document or on a paper sheet. At the end of the lab, you should approach one of the teaching assistants present, and ask them to check your answers. They will discuss incorrect answers with you. Once the assistants have approved your answers, they will mark your attendance and the practical session is considered completed. If there is not time for you to present your answers, you can submit them via Studium. 



### Genome annotation

In the context of genomics, an annotation is a definition of the genes, their characteristics and descriptions.   As raw sequencing data can't tell us what parts of it are functional or what function each region plays, annotating a genome is, in its most basic sense, making our nucleotide sequence meaningful. As a process of identification of genes and coding regions' physical locations within the chromosome, genome annotation helps us have an insight on what these genes do  by establishing structural aspects and relating them to functions of different proteins.  

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

#### Similarity search using BLAST
The next step will be to determine what is encoded in these genes. We will use BLAST to try to find putative functions, and we will do so using 2 different databases: one for virulence (genes that make the bacteria more dangerous) and resistance (genes that make the bacteria resistant to antibiotics). You'll find both **.fsa** files in `./DATA/Lab4/`, each one under their own folder. In addition, you will find a **notes.txt** file with a description of each of the genes included.

**Exercise**
1. Index the .fsa files for the virulence and resistance genes using `formatdb`.
2. Blast your ORF nucleotide sequences against both files using the output format XML*, save the output to a new file. 

*Hint: If you run blastall without arguments you will see the different output formats
under the –m parameter.

#### Inserting the results in a SQLite-database
Now you will run Blast2SQLite.py which takes your blast results and puts it in a datbase table (run this for both contig blast files). The first argument should contain the contig blast xml-file and the second the blast table name for the config (which you can pick freely) like this:

 `% python Blast2SQLite.py <xml-file> <blast_table_name>`
 
 The script will create a table for the blast file which contains the following:
 
 * Reference to query gene in the first table
 * Name of BLAST hit
 * E-Value
 * Length of hit sequence
 * Percent identity between the two sequences

### Annotation file
#### Visualization
To visualize the comparison between the finished genome and your contigs of choice you will use ACT (Artemis Comparison Tool). Artemis allows you to not only work with one sequence but also load in more sequences at the same time. This is very useful both for annotation and for comparative analysis, for example looking at the rearrangements. The principle is very similar to the 'art' program you have already used and you have to use 'act' in this case.

If you do not have it installed, start by downloading and installing ACT. If you have JAVA
installed, you could use a web based launch.To start ACT on Linux, type:
 
 `% act &`
 
In Windows or MacOS, do as prompted on the ACT web page.

#### How to compare sequences: step by step instruction

ACT takes information about sequence similarity from BLAST file and the important difference to a
'normal' BLAST run it to use output format compatible with ACT (-m 8). Usually you want to read in at
least one annotated sequence, so you have to remember to run blast on fasta file but open the embl
(or genbank) file in ACT.

The order of files does not matter as long as they are of different length (that's where you get the flip
comment from).

1. For this analysis we will use the antibiotic resistance genes in **.fsa** format that we have already indexed and the annotation in **.gbk**. 
3. Run BLAST again, but this time using the whole plasmid

	`blastall -p blastn -i <contig.fasta> -d <resistance.fasta> -m 8 -o <contig_vs_resistance.blastn>`
4. Run ACT
	
	either open an act window and use the menus "File->Open..." or specify the files to open in the command line:
	`act <contig.fasta> <contig_vs_resistance.blastn> <resistance.gbk> &`

Like in Artemis you see the sequences with the annotated features (if any), except now you look at more than one at the same time. Scroll the bars to move along the genome, you might want to 'unlock' the positions to be able to move the two sequences independently. Try right-click and then find lock in the drop-down menu and turn it off.

The window in the middle shows you the similarity between sequences. Intensity of the color corresponds to similarity. Red blocks have the same orientation (collinear parts) and blue ones have opposite orientations (rearranged). Click on the bars to check the details (score, length, evalue). You can filter out poor similarities by moving the middle bar and setting higher sScore. The broad overview immediately gives you an idea about large rearrangements or co-linearity of the two sequences.

Note the difference between BLAST blocks and genes. You can see similarity of a block shorter than one gene or containing several genes. You can read more in ACT manual [here](https://www.sanger.ac.uk/science/tools/artemis-comparison-tool-act).

#####Question 1
1. Describe the two contigs you chose. How long are they? How many genes were found?
You can either use Artemis or the script fastaNamesSizes.py to figure out the contig
lengths. Do not use Artemis to count genes, as this can be quite confusing.
2. Compare the contigs with the genome of Bartonella grahammi using ACT and describe
what you see: are they co-linear? Are there any rearrangements?
3. For each contig what is the average blast length hit sequence?
*Hint: use AVG()
4. Which of the contigs have most significant blast hits?( eval >1e-10)?
*Hint: look at the queries of the orfs-table, use COUNT()


#####Question 2
Does your sample contain any gene associated with antibiotic resistance? Validate your results using [ResFinder](https://cge.cbs.dtu.dk/services/ResFinder/). Just select `Acquired antimicrobial resistance genes` the appropiate species name and upload your plasmid sequence. 
#####Question 3
Does your sample contain any gene associated with a virulence factor that the doctors should be aware of? Validate your results using [VirulenceFinder](https://cge.food.dtu.dk/services/VirulenceFinder/) with standard settings and the proper species. 

	

**Submit your answers to Lab 4 Assignment on Studium**


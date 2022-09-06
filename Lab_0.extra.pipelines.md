# Pipelines exercise

## Copy files for lab

Now that you are familiar with the command line it's time to start doing things you might do if you are running analysis for real. First, let's create a new folder for this part of the lab in your `RESULTS` folder.

```bash
# go to the course folder
cd ~/1MB438/RESULTS

# create a new folder for this lab
mkdir linux_pipelines
cd linux_pipelines
```

Now we can copy the lab files to your folder.

:bulb: Remember to use tab-complete to avoid typos and too much writing.

```bash
cp ~/1MB438/DATA/Lab0/linux_pipelines/linux_pipelines.tar.gz .

# have a look at what was copied
ll

# unpack the tar.gz file
tar -xzvf linux_pipelines.tar.gz

# have a look at what was unpacked
ll
```

If you see files and folders, the copying and extraction was successful.

# Running dummy pipelines

Most of the work you will do in the future will be about running multiple programs after each other. This can be done manually, with you sitting by the computer and typing commands, waiting for them to finish, then start the next program. But what happens if the first program finished sometime during the night? You will not be there to start the next program, and the computer will stand idle until you have time to start the program.

To avoid this, scripts can be used. First, we'll do an analysis manually without scripts, just to get the hang of it. Then we'll start writing scripts for it!

## "Installing" the programs

In this exercise, we'll pretend that we are running analyses. This will give you a peek at what running programs in linux is like, and get you ready for the real stuff later in the course!

During this exercise we'll only run my dummy scripts that don't actually do any analysis, so they aren't installed by the sysadmins. What we can do instead is to temporarily tell the computer where to look for the programs, by modifying something called the `$PATH` variable.

The `$PATH` variable specifies directories where the computer should look for programs whenever you type a command.
For instance, when you type

```bash
nano
```

how does the computer know which program to start? You gave it the name `nano`, but that could refer to any file named `nano` in the computer, yet it starts the correct one every time. The answer is that it looks in the directories stored in the `$PATH` variable and start the first program it finds that is named `nano`.

To see which directories that are available by default, type

```bash
echo $PATH
```

It should give you something like this, a list of directories, separated by colon signs:

```bash
echo $PATH
/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/opt/bio/bin:/usr/share/bwa-0.7.13:/opt/mrtwig/
```

We will just add a the directory containing my dummy scripts to the `$PATH` variable, and it will be like we have the programs installed. Now, when we type the name of one of my scripts, the computer will look in all the directories specified in the `$PATH` variable, which now includes the location where i keep my scripts. The computer will now find programs named as my scripts are and it will run them.

```bash
export PATH=$PATH:~/1MB438/RESULTS/linux_pipelines/dummy_scripts
```

This will set the `$PATH` variable to whatever it is at the moment, and add a directory at the end of it. Note the lack of a dollar sign infront of the variable name directly after **export**. You don't use dollar signs when **assigning** values to variables, and you always use dollar signs when **getting** values from variables.

:exclamation: **IMPORTANT:** The export command affects only the terminal you type it in. If you have 2 terminals open, only the terminal you typed it in will have a modified path. If you close that terminal and open a new one, it will not have the modified path and you will have to run the whole `export` command again.

Enough with variables now. Let's try the scripts out!

# Running the programs

Let's pretend that we want to run an exome sequencing analysis using [high-throughput sequencing](https://en.wikipedia.org/wiki/DNA_sequencing#High-throughput_methods) data, also called Next Generation Sequencing (NGS) data. This kind of sequencing takes the DNA from many identical cells, fragments DNA molecules into smaller pieces (like 500-1000bp each), sequence these fragments individually (called *reads*), and then use the computer to assemble the fragmented sequences (*reads*) together to form the whole sequence of the original DNA molecules. The reason we have to fragment the pieces and lay this multi-million piece puzzle is that we don't yet have seqcuencing techniques that can read a whole genome from start to end.

The only difference between a [exome sequencing](https://en.wikipedia.org/wiki/Exome_sequencing) and a [whole genome sequencing](https://en.wikipedia.org/wiki/Whole_genome_sequencing) is that we limit the DNA we sequence to the known exomes of the organism we sequence. In humans this is about 1% of the whole genome, making it much cheaper to sequence per sample. With the same amount of sequencing you can analyze 100 exome samples per whole genome sample. The downside is that we only look at the areas we think are exomes. Any differences between the samples outside of the exome areas we have defined will be missed. Other than that, they are analyzed pretty much the same way.

This kind of analysis usually has the following steps:

1. Filter out low quality reads.
2. Align the reads to a reference genome.
3. Find all the [SNPs](https://en.wikipedia.org/wiki/Single-nucleotide_polymorphism) in the data.

To simulate this, I have written 3 programs:

* `filter_reads`
* `align_reads`
* `find_snps`

To find out how to run the programs type

```bash
<program name> -h

#or

$ <program name> --help
```

This is useful to remember, since most programs has this function. If you do this for the filter program, you get

```bash
filter_reads -h
Usage: filter_reads -i <input file> -o <output file> [-c <cutoff>]

Example runs:

# Filter the reads in <input> using the default cutoff value. Save filtered reads to <output>
filter_reads -i <input> -o <output>
Ex.
filter_reads -i my_reads.rawdata.fastq -o my_reads.filtered.fastq

# Filter the reads in <input> using a more relaxed cutoff value. Save filtered reads to <output>
filter_reads --input <input> --output <output> --cutoff 30
Ex.
filter_reads --input ../../my_reads.rawdata.fastq --output /home/dahlo/results/my_reads.filtered.fastq --cutoff 30


Options:
  -h, --help            show this help message and exit
  -i INPUT, --input=INPUT
                        The path to your unfiltered reads file.
  -o OUTPUT, --output=OUTPUT
                        The path where to put the results of the filtering.
  -c CUTOFF, --cutoff=CUTOFF
                        The cutoff value for quality. Reads below this value
                        will be filtered (default: 35).

```

This help text tells you that the program has to be run a certain way. The options `-i` and `-o` are mandatory, since they are explicitly written. The hard brackets `[ ]` around `-c <cutoff>` means that the cutoff value is NOT mandatory. They can be specified if the user wishes to change the cutoff from the default values.

Further down, in the `Options:` section, each of the options are explained more in detail. You can also see that each option can be specified in two way, a short and a long format. The cutoff value can be specified either by the short `-c`, or the long `--cutoff`. It doesn't matter which format you choose, it's completely up to you, which ever you feel more comfortable with.

Right, so now you know how to figure out how to run programs (just type the program name, followed by a `-h` or `--help`). Try doing a complete exome sequencing analysis, following the steps below.

First, go to the exome directory in the lab directory that you copied to your folder in step 2 in this lab:

```bash
cd ~/1MB438/RESULTS/linux_pipelines/data/exomeSeq/
```

In there, you will find a folder called `raw_data`, containing a fastq file: `my_reads.rawdata.fastq`. This file contains the raw data that you will analyse.

* Filter the raw data using the program `filter_reads`, to get rid of low quality reads.

* Align the filtered reads with the program `align_reads`, to a fake human reference genome located here: `~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa`

* Find SNPs in your aligned data with the program `find_snps`. To find SNPs we have to have a reference to compare our data with. The same reference genome as you aligned to is the one to use.

Do one step at a time, and check the `--help` of the programs to find out how they are to be run. Remember to name your files logically so that you don't confuse them with each other.

Most pipelines work in a way where the output of the current program is the input of the next program in the pipeline.
In this pipeline, raw data gets filtered, the filtered data gets aligned, and the aligned data gets searched for SNPs. The intermediate steps are usually not interesting after you have reached the end of the pipeline. Then, only the raw data and the final result are worth keeping.

<details>
  <summary>Solution</summary>

```bash
# filter reads
filter_reads -i raw_data/my_reads.rawdata.fastq -o my_reads.filtered.fastq

# align reads
align_reads -i my_reads.filtered.fastq -o my_reads.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa

# SNP calling
find_snps -i my_reads.filtered.aligned.sam -o my_reads.filtered.aligned.snpcalled.pileup -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa

```

</details>

# Scripting a dummy pipeline

To run the pipeline in a script, just do exactly as you just did, but write the exact same commands to a file instead of directly to the terminal. When you run the script, the computer will run the script one line at a time, until it reaches the end of the file. Just like you did manually in the previous step.

The simplest way to work with scripts is to have 2 terminals open. One will have `nano` started where you write your script file, and the other will be on the command line where you can test your commands to make sure they work before you put them in the script. When you are sure a command works, you copy/paste it to the terminal with the script file in it.

Start writing you script with `nano`:

```bash
cd ~/1MB438/RESULTS/linux_pipelines/data/exomeSeq/
nano exome_analysis_script.sh
```

The `.sh` ending is commonly used for **sh**ell scripts which is what we are creating. The default shell at most Linux systems is called `bash`, so whenever we write `sh` the computer will use `bash`. If the default shell would change for some reason, maybe to `zsh` or any other type of shell, `sh` would point the the new shell instead.

![](DATA/Lab0/imgs/dualTerminals.png)

Since our memory is far from perfect, try to **always comment your scripts**. The comments are rows that start with a hash sign `#`. These lines will not be interpreted as a command to be run, they will just be skipped. They are only meant for us humans to read, and they are real lifesavers when you are reading old scripts you have forgotten what they do. Commands are hard for humans to read, so try to write a couple of words explaining what the command below does. You'll be thankful later!

When you are finished with your script, you can test run it. To do that, use the program `sh`:

```bash
$ sh exome_analysis_script.sh
```

If you got everything right, you should see the whole pipeline being executed without you having to start each program manually. If something goes wrong, look at the output and try to figure out which step in the pipeline that get the error, and solve it.

A tip is to read the error list from the top-down. An error early in the pipeline will most likely cause a multitude of errors further down the pipeline, so your best bet is to start from the top. Solve the problem, try the script again, until it works. The real beauty of scripts is that they can be re-run really easily. Maybe you have to change a variable or option in one of the early steps of the pipeline, just do it and re-run the whole thing.

# RNAseq Analysis

The next step is to do a complete RNAseq analysis. Just like the exome seq data, the RNAseq data is based on high-throuput sequencing, meaning the raw data will be millions of sequenced DNA fragments, called reads, and we will have to use the computer to piece them together. The main difference between exome seq and RNA seq is that in RNA seq, only [messenger RNA (mRNA)](https://en.wikipedia.org/wiki/Messenger_RNA) has been sequenced and not DNA like in exome sequencing.

In exome sequencing you expect an even coverage of reads (the average number of times each basepair has been sequenced) over your whole exome. In RNA seq, the coverage will not be even, as all genes are not expressed to the same degree. Lots of coverage = lots of expression. This makes it interesting to do time series experiments when you can track how the coverage, or expression level, for genes change over time. This is called differential expression analysis, or [gene expression profiling](https://en.wikipedia.org/wiki/Gene_expression_profiling)

The steps involved start off just like the exome analysis, but has a few extra steps. The goal of this part is to successfully run the pipeline using a script. To do this, you must construct the commands for each step, combine them in a script, and execute it. Much like what we did in the previous step, but using a differential expression analysis software as the last step instead of a SNP caller.

Typical RNAseq analysis consists of multiple samples / time points:

* Filter the reads for each sample.
* Align the filtered reads for each sample to the same reference genome as before.
* Do a differential expression analysis by comparing multiple samples.

The difficulty here is that you have not just 1 sample, you have 3 of them. And they all need to be filtered and aligned separately, and then compared to each other. The program that does the differential expression analysis in this exercise is called `diff_exp`.


<details>
  <summary>Solution</summary>

```bash
# go to the rna seq folder
cd ~/1MB438/RESULTS/linux_pipelines/data/rnaSeq/

# filter the samples one by one
filter_reads -i raw_data/sample1.fastq -o sample1.filtered.fastq
filter_reads -i raw_data/sample2.fastq -o sample2.filtered.fastq
filter_reads -i raw_data/sample3.fastq -o sample3.filtered.fastq

# align the samples one by one
align_reads -i sample1.filtered.fastq -o sample1.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa
align_reads -i sample2.filtered.fastq -o sample2.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa
align_reads -i sample3.filtered.fastq -o sample3.filtered.aligned.sam -r ../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa

# do a differential expression on all samples together
diff_exp -i sample1.filtered.aligned.sam,sample2.filtered.aligned.sam,sample3.filtered.aligned.sam -o sample.diff_exp.out

```

</details>

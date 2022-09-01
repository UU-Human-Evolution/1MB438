### Playing around with files

```
w3m -dump https://en.wikipedia.org/wiki/Principal_component_analysis > PCA.txt
```


The above command reads the Wikipedia page for Principal Component Analysis and extracts the body text and saves it to the file `PCA.txt`. The `>` is used to redirect output to a file.


Now that we have some text to work here are some tools for inspecting files, try them out on `PCA.txt`.

```
cat - concatenates the file contents to standard out (the screen)
less - a nice and easy file viewer, press q to quit!
head - look at the head of a file, by default the first 10 lines.
tail - looks at the tail of a file, by default the 10 last lines.
```

It turns out that the PCA article is quite big, how big?
Counting is hard and slow for humans but easy for machines. Use the word count command `wc` on the file to figure out how many lines and words it contains. 

**Question 1: What did you get? How many lines and words?**

Hmm, it's not that clear, is it? Have a look at the manual for `wc` to try and figure it out. 
All core UNIX commands have an inbuilt manual you can access it through the `man` command:

```
man wc 
```

Now that you figured that out, use the manual for `head` to figure out how to save the first 100 lines of `PCA.txt` and save them into `short_pca.txt`.

You can use `wc` to figure out if you did it correctly.

#### grep
`grep` is a useful tool that prints lines matching a provided pattern.
In our example we can use it to figure out how many lines contain the word `PCA`:

```
grep PCA short_pca.txt
```


### Pipes and multiple commands
One of the fundamental concepts behind UNIX from the beginning was an emphasis on small task-specific programs. These programs could then be chained together into pipelines to perform more complex tasks.

Imagine that you have a machine that cuts down trees, de-barks them, and cuts them into planks. If you have trees and want planks then this is fine, but what happens if you want to cut down the tree and keep the whole log? Your big fancy machine only makes planks.
In the UNIX world, your one machine would consist of smaller machines chained together. One that cuts down the tree, one that removed the bark, and one that cuts into planks. 
If you get a pile of logs from your neighbor then you can use one of your machines to make planks, etc.

This type of chaining together is called piping in UNIX and is done by the pipe character `|`. e.g.

```
command 1 | command 2 | command3 > output_file
```

By using `grep`, `pipe`, and `wc` we can now easily figure out how many lines of the Wikipedia article about Principle Component Analysis contains the word `PCA`:

```
grep PCA short_pca.txt | wc -l
```

Try it for the full article as well!
**Question 2:** Write down how many times `PCA` appears in both the full `PCA.txt` and the `short_pca.txt` files.

### Hidden word exercise 
**Question 3:**
Now that you have some basic UNIX tools at your disposal go and do the [hidden word_exercise](hidden_word_exercise_instructions.md).
Submit the hidden word.

Do not continue with the next part until you are done with the hidden word exercise. 

### BAM files

Ok time for something perhaps a bit more fun. Some genetic data!

The SAM/BAM (Sequence Alignment/Map & Binary Alignment Map) format is a very popular format for storing nucleotide data that is aligned to a reference. 

If you want to read more about the file format(s) you can have a look at the official documentation:
https://samtools.github.io/hts-specs/SAMv1.pdf

If you want a simpler (and easier to read) text to give you an overview have a look at the Wikipedia article: 
https://en.wikipedia.org/wiki/SAM_(file_format)

The main tool for working with SAM/BAM files is called `samtools` and it's already installed on the computer you are using.

The **BAM** file and corresponding **SAM** file can be found here:

```
/proj/uppmax2021-2-12/private/1MB438/DATA/Lab0/
```

Before using it have a look at the file sizes of the two different formats.

```
ls -lh 
```

With that information, you can probably see why it's a generally good idea to store data in binary formats as much as possible. The original full file was **117 GB** for reference.

##### The `.bam` file is just for a small part of the genome, which one? 
**Question 4:** use `samtools view` and `head` and `tail` to **figure out the first and last position in the file**. Also include the exact command you used!


##### Use `cut` to extract only the name and nucleotide sequence from the `.bam` file. 

First, figure out which fields it is that you want and then investigate `man cut` to figure out how to access them.

**Question 5:** Write down the command you used to extract the name and nucleotide sequence!




### sed and regex
Regular expressions(regex) are used to catch and match certain words or phrases. E.g
^
`^P[0-9]+` will match at the beginning of a line(`^`) the letter P literally, any  number (`[0-9]`) repeating (`+`)
it will thus catch the top line but not the second:

```
P674353
454646464 P 
```
These types of expression can be very useful and powerful 


`sed` is a powerful tool for editing streams of files. It is a common way of using rexes in Unix. It's often used to replace one thing with another:

if `My_file.txt ` contains:

`dog dog dog`

Then:

```
sed 's/dog/cat/' My_file.txt. # s is for substitute
cat dog dog
```
the first instance of `dog` is replaced with `cat`. We can also replace all instances using the `g` global flag:

```
sed 's/dog/cat/g' My_file.txt. # sg - substitute globally
cat cat cat
```


You can use `sed` on piped output from another program or straight on a single file. For a summary of some things that you can do with it have a look at [this link](https://github.com/tldr-pages/tldr/blob/master/pages/common/sed.md).



**Question 6 :**
You have been given a that has been exported from excel in an odd format (something that is all too common in the life of a bioinformatician). Your task is to transform the file [orange.csv](example_data/orange.csv) into a normally formatted `.csv`-file. That is the decimal point should be a `.` and the delimiter (what separates one column from another) should be `,`. It also looks like someone has accidentally inserted some letters among the numbers, they also need to be removed.

Submit what `sed` command(s) you used to clean the file. (Make sure that it looks correct)

_You will probably have to look up more information on how to do this. You can use `man sed` or `info sed` for more information, or google your way to it. As long as you know what your command does_

Note that if you want to upload the file to your Uppmax results you can use the `scp` command, you can find an example of how to use it at the bottom of the page.

### Basic bash scripting for future reference 
Bash is a programming language in itself so it is possible to set up quite advanced workflows with it. The most simple bash script is just a normal command you would type on the command line saved to a file. Or more realistically you might want to run a couple of things that take a few minutes or hours after each other.
This is something that you definitely will do in your future bioinformatics career.

An example of something like that:

```

echo “Wait for 5 seconds”
sleep 5
echo “Completed”

```

Add the above text to a file called `sleep.sh` and execute it with:

```
bash sleep.sh
```

You can see that the code is executed sequentially, it does not progress to the next line until the previous one has finished.

An example of a use case could be that you have data on a local server that you want to transfer to a remote server where you want to perform some kind of analysis and then transfer the results back to your local server. That would look something like this:


```
### Standing at the remote server copy the local files there
scp my_user@remote_server:local_file .
### Do the analysis
run_analysis.sh local_file > output_file
### Copy results back
scp output_file my_user@remote_server:
```


---

This is the end of the lab, please make sure that you did and wrote down the answers to all of the questions.
Also, make sure to delete any files that you no longer need - you can copy them somewhere else if you want to keep them.

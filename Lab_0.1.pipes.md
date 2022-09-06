# Pipes exercise

## Hand-in instructions
Time to start working on the hand-in for the linux part of the course! The hand-in will be the commands used to complete the [hidden word exersise](Lab_0.1.hidden_words.md) below, as well as which word the letters form. Put them all in a text file which you name the same as your username. Once you are finished, copy this file to the following location: `/home/martdahl/hand-in/`

We won't judge the formatting of the file or anything, so don't sweat it if the file is ugly :)

Example of how it could look:
```bash
# first letter
cd folder1
ls -la

# letter: a

# second letter
cd ../folder2
tail file1

# letter: b


# word formed: ab
```


### Playing around with files

Start with moving to the folder with all the course files so that we keep everything in the same place. If you come back to have a look at these exercises in a month you will have forgotten where you placed things and which files belong together, unless you av the files in a structured way.

```bash
# go to the course folder
cd ~/1MB438/RESULTS

# create a new folder for today's lab and enter it
mkdir linux_pipes
cd linux_pipes
```

Now we will need files to experiment with. Let's download a text we can work with from Wikipedia using a program called `w3m`. It is a terminal-based web browser that can save the HTML as plain text. It will by default print the text to the terminal, so we have to tell `bash` to redirect the output to a file using the `>` character.

```bash
w3m -dump https://en.wikipedia.org/wiki/Principal_component_analysis > PCA.txt
```

The above command reads the Wikipedia page for Principal Component Analysis and extracts the body text and saves it to the file `PCA.txt`.

:bulb: You can try out browsing the web using `w3m` instead of just using it to dump the text of a web site as a text file. Scroll up and down using `k` and `j`, jump between clickable links using the `up` and `down` arrows, click links using `enter`, and go back in your browsing history using the `left` arrow. When you want to close `w3m`, press `q` and answer `y` to confirm.

```bash
w3m https://en.wikipedia.org/wiki/Principal_component_analysis
# or
w3m https://www.ebc.uu.se/?languageId=1
```

Now that we have some text to work here are some tools for inspecting files, try them out on `PCA.txt`.

```
cat - concatenates the file contents to standard out (the screen)
less - a nice and easy file viewer, press q to quit!
head - look at the head of a file, by default the first 10 lines.
tail - looks at the tail of a file, by default the 10 last lines.
```

It turns out that the PCA article is quite big, how big?
Counting is hard and slow for humans but easy for machines. Use the word count command `wc` on the file to figure out how many lines and words it contains. 

:clipboard: What did you get? How many lines and words?

<details>
  <summary>Solution</summary>

```bash
wc PCA.txt

  2395  17076 126443 PCA.txt

# 2395 lines, 17076 words, 126443 characters
```
</details>

Hmm, it's not that clear, is it? Have a look at the manual for `wc` to try and figure it out. 
All core UNIX commands have an inbuilt manual you can access it through the `man` command:

```
man wc 
```

Now that you figured that out, use the manual for `head` to figure out how to save the first 100 lines of `PCA.txt` and save them into `short_pca.txt`.

You can use `wc` to figure out if you did it correctly.

<details>
  <summary>Solution</summary>

```bash
head -n 100 PCA.txt > short_pca.txt
wc short_pca.txt

 100  703 4758 short_pca.txt

# 100 lines, 703 words, 4758 characters
```

</details>

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

:clipboard: How many times does `PCA` appears in both the full `PCA.txt` and the `short_pca.txt` files?


<details>
  <summary>Solution</summary>

```bash
# short file
grep PCA short_pca.txt | wc -l
15

# full file
grep PCA PCA.txt | wc -l
168
```

</details>

### Hidden word exercise 

:clipboard: Now that you have some basic UNIX tools at your disposal go and do the [hidden word_exercise](Lab_0.1.hidden_words.md).
Submit the hidden word and the commands used to find it as described in the [hand-in instructions](#hand-in-instructions).

Do not continue with the next part until you are done with the hidden word exercise. 

### BAM files

Ok time for something perhaps a bit more fun. Some genetic data! Start by going back to the lab folder for this lab, `~/1MB438/RESULTS/linux_pipes`

```bash
cd ~/1MB438/RESULTS/linux_pipes

# and create a new directory names sam
mkdir sam

# and cd to that directory
cd sam
```

The SAM/BAM (Sequence Alignment/Map & Binary Alignment Map) format is a very popular format for storing nucleotide data that is aligned to a reference. 

If you want to read more about the file format(s) you can have a look at the official documentation:
https://samtools.github.io/hts-specs/SAMv1.pdf

If you want a simpler (and easier to read) text to give you an overview have a look at the Wikipedia article: 
[https://en.wikipedia.org/wiki/SAM_(file_format)](https://en.wikipedia.org/wiki/SAM_(file_format))

The main tool for working with SAM/BAM files is called `samtools` and it's already installed on the computer you are using.

Let's convert the `sam` file from the `linux_tutorial` exercise to a `bam` file and see why you should never have files in the `sam` format. First, we want to create a **hard link** to the `sam` file so it will look like we have that file in the same folder as we are standing now. [This answer](https://stackoverflow.com/a/29786294) on stackoverflow explains the difference between symbolic links and hard link way better than i could, so please read that one instead :) It is useful in this example since we will see the size of the file, unlink a symbolic link which will just show us the size of the linkfile instead (you **can** get around this by giving `ls` the `-L` option as well, but let's use the hard link approach instead).

```bash
# link the file
ln ../../linux_tutorial/a_better_name/sample_1.sam .
```

Now convert the `sam` file to a `bam` file using `samtools`:

```bash
samtools view -b sample_1.sam > sample_1.bam
```

The `-b` option tells `samtools` to print its output in `bam` format, which we then redirect to a file using `>`

Have a look at the file sizes of the two different formats:

```
ll -h 
```
:bulb: The `-h` option to `ll` tells it to print file sizes in a human readable format.

With that information, you can probably see why it's a generally good idea to store data in binary formats as much as possible. Usually the `bam` file is ~25% of the `sam` file's size. In this lab it's a bit more extreme difference, only 2% of `sam` file's size, because I created a `sam` file with lots of repetition in it to keep down the size of the course material (more repetition = better compression).

##### The `.bam` file is just for a small part of the genome, which one? 
:clipboard: Use `samtools view` on the `bam` file together with `head` and `tail` to **figure out the first and last position in the file**. Have a look at [the wikipedia page for the sam format](https://en.wikipedia.org/wiki/SAM_(file_format))for an explaination of what the columns are.

<details>
  <summary>Solution</summary>

```bash
samtools view sample_1.bam | head
# chr1, position 10536

samtools view sample_1.bam | tail
# chr1, position 981386
```

</details>

##### Use `cut` to extract only the name and nucleotide sequence from the `.bam` file. 

:clipboard: Figure out which fields it is that you want and then investigate `man cut` to figure out how to access them.

<details>
  <summary>Solution</summary>

```bash
samtools view sample_1.bam | cut -f 1,10
```

</details>

## Extra material
If you finish the previous exercises and want to learn more linux, feel free to continue on with the extra material [pipeline exercise](Lab_0.extra.pipelines.md)

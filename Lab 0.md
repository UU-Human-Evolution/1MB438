# Session 0 - Basic command line tutorial

Original lab by Rickard Hammaren at [1MB335](https://github.com/Hammarn/1MB335/blob/master/Lab1.md). Modified by Pedro Morell Miranda.

### What is UNIX?
Unix is an operating system that was originally developed at Bell Labs in the 1970s. It is based around a "modular design" 
where tools do very distinct and narrow tasks. To complete more complex tasks multiple modules are then combined through the use of"pipes" 
-more about those later. If you are interested in learning more about UNIX then you can have a look at the [Wikipedia article](https://en.wikipedia.org/wiki/Unix) 
for UNIX, it's quite thorough and well written.

### Why are Unix systems so popular in science?
While there is no straightforward answer to this question there are some things that are often brought up. UNIX (and Unix-like systems) in its design is quite simple and is nowadays very portable. This has lead to it being used to run anything from massive high-performance computer clusters to tiny single-board computers such as Arduino & raspberry pis. This ubiquity and popularity is probably one reason why it is still so popular. Since the year 2000 Mac computers are also running on Apple's own Unix system, another popular Unix-like system is the Android mobile operating system. While the original UNIX operating system is a commercial system there are many Unix-like operating systems such as Linux which are free and open-source (these are generally based on the Linux kernel). The ecosystem of open source and free distribution suits the academic world very well. It is not science if you aren't charing your findings and how you came to your conclusions - that generally includes your code.

##### Using UNIX
Interaction with UNIX-style systems is typically done through a command-line interface (CLI) - a `terminal` of some sort. There is generally no GUI (graphical user interface), though there exist protocols to display graphics through the terminal such as `X11`.

To communicate with the system there needs something to interpret the user's command. In a UNIX-like system, this is called a shell, one of the most common ones - and the one found on `Uppmax` is called Bourn-Again shell or simply `bash`. It's an interpreter and it's own (basic) programming language.

Enough exposition, let's get going. Open up the terminal and proceed with the exercise.

![Figure 1](Figures/Version_7_Unix_SIMH_PDP11_Emulation_DMR.png)

**Terminal display for version 7 of Unix**

*(By Huihermit - Own work, CC0, https://commons.wikimedia.org/w/index.php?curid=30560188)*

#### For Mac users
The macOS operating system is a Unix-system so modern Macs can natively interact with other Unix systems. macOS comes with an inbuilt terminal application called simply `Terminal`. 
It is functional and gets the job down, we, however, recommend that you instead install `iTerm2`, which comes with several quality of life improvements.
Download it from [https://iterm2.com/](https://iterm2.com/)

MacOS comes with a very bare-bones version of Unix which lacks many tools that most Unix installations come with. Thus we recommend that you install [Homebrew](https://brew.sh/) which is a package manager for Mac which makes it super easy to install missing programs and tools.

To install `Homebrew`; open the terminal and run:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
*Note that this will take around 5 min to complete and you will be prompted for your user password. The installation requires around 10GB of space*

Then you can install some useful tools:

```
 brew install wget
 brew install w3m
 brew install tree
```

#### For Windows users
If you are on a Windows machine then the easiest option for you is to download `MomaXterm`.

[https://mobaxterm.mobatek.net/](https://mobaxterm.mobatek.net/)

Another option is to use the Ubuntu app from the Windows app store or to set up a dedicated Linux partition. If you know how to do that then go for it, if not stick to MobaXterm.

Open a local terminal and run the following command to install `w3m` which we will use in today's lab:

```
apt-get install -y w3m-img
```

### Before starting
If you have problem with missing software on your installation of Unix/Linux you can choose to work on `Uppmax` directly. You can read the instructions under Working remotely then continue for here.



Okay. Everything is set up? Good. Let's start, then.

#### Moving around
When you connect to a system you usually end up in your home directory. To see the path to where you stand use the `pwd` command. Try it now:

```
pwd
```

it should return something like:

```
/home/user_name
```

As you move around in the systems directories this will of course change.

To make a directory (called folders on other systems) use the command `mkdir`, try the following out:

```
mkdir directory1
```

To figure out what happened use the `ls` command which lists the content of the current working directory:

```
ls
```

As you can see `mkdir` makes directories, all (or at least most) UNIX commands are named after their function. 

To go to your new directory use `cd` (change directory);

```
cd directory1
```

Now try to create another directory called `directory 2`

```
mkdir directory 2
```

Take a look at what you did using the `ls` command.

Looks like you created two directories, one called `2` and another called `directory`. Since the basic syntax for UNIX commands is:

```
command option1 option2 option3
```

Each extra option to the command is separated by a space, which means that spaces and other white characters, such as tabs, are not allowed in file or directory names!

To fix this issue use `rm` for, you guessed it - remove.
We can remove both at the same time:

```
rm directory 2
```

Ouch, `rm` by default only removes files, not directories. You need to tell `rm` that you want it to work recursively, using what's typically called a flag, in this case `-r`.

```
rm -r directory 2
```

Check that is worked using `ls`.


Ok, let's try and make a second directory again:

```
mkdir directory2
```

change into it using `cd` 

```
cd directory2
```

So now your current directory should be `home/your_usename/directory1/dirextory2`, to find out use `pwd`. If you want to go one directory up, in our case from directory2 to directory1 you can use `..` notation:

```
cd ..
```

Check that it took you to the right place. Here are two need things to know about `cd`

```
cd -
```

takes you back to the last place you were standing.
Just `cd` with no options takes you to your home directory.





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

--

### Hidden word exercise 
**Question 3:**
Now that you have some basic UNIX tools at your disposal go and do the [hidden word_exercise](hidden_word_exercise_instructions.md).
Submit the hidden word.

Do not continue with the next part until you are done with the hidden word exercise. 


### Working remotely 

The next part of this exercise will take place on the computational cluster Rackham on UPPMAX (Uppsala Multidisciplinary Center for Advanced Computational Science). 
To connect to a remote Unix server the protocol `ssh` is typically used.

Given that you have an account with Uppmax do the following to connect to Rackham:

```
ssh your_user_name@rackham.uppmax.uu.se
```

After entering that command you will be prompted to enter your password.

Our teaching project is called `g2021007`

Navigate to the RESULTS folder (using `cd`):
to:

```
/proj/g2021007/private/RESULTS
```

There you need to make a directory for you to work in. Call it your first name underscore your last name:

`FirstName_LastName`

For the rest of your exercises, you should be working in that directory. I.e copy data there and work on it. 

---


Ok time for something perhaps a bit more fun. Some genetic data!


### BAM files

The SAM/BAM (Sequence Alignment/Map & Binary Alignment Map) format is a very popular format for storing nucleotide data that is aligned to a reference. 

If you want to read more about the file format(s) you can have a look at the official documentation:
https://samtools.github.io/hts-specs/SAMv1.pdf

If you want a simpler (and easier to read) text to give you an overview have a look at the Wikipedia article: 
https://en.wikipedia.org/wiki/SAM_(file_format)

The main tool for working with SAM/BAM files is called `samtools` and it's installed through the module system on Uppmax. To get access to it:

```
module load bioinfo-tools
module load samtools/1.9
```

The **BAM** file and corresponding **SAM** file can be found here:

```
/proj/g2021007/private/DATA/BAM
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

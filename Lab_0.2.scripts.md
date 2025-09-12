# Scripts exercise

The first thing we're going to do is to update the git repo in case there has been any changes to the lab instructions since you updated the repo in the previous lab. It should be as easy as running this command while standing anywhere inside the course repo:

```bash
# go to the course repo
cd ~/1MB438

# run the update command
git pull
```

If you get any error message, raise your hand and an assistant will come and help you out.

## Copy files for lab

Now, you will need some files. To keep your files organized, make your own copy of the needed files. The files are located in the folder `~/1MB438/DATA/Lab0/linux_scripts`.

Copy the lab files from this folder. `-r` means recursively, which means all the files including sub-folders of the source folder. Without it, only files directly in the source folder would be copied, NOT sub-folders and files in sub-folders.

:bulb: Remember to use tab-complete to avoid typos and too much writing.

```bash
# syntax:
#  cp -r <source> <destination>
cp -r ~/1MB438/DATA/Lab0/linux_scripts ~/1MB438/RESULTS/
```

Have a look in `~/1MB438/RESULTS/linux_scripts`

```bash
cd ~/1MB438/RESULTS/linux_scripts

ll
```

If you see a `.tar.gz` file, the copying was successful. Now we need to extract the files from it to get the files we need for this lab.

```bash
# extract
tar -xzvf linux_scripts.tar.gz

# look at the extracted content
ll
```

Now we are ready to continue with the rest of the lab.

## Using variables

Variables are like small notes you write stuff on. If you want to save the value of something to be able to use it later, variables is the way to go. Let's try assigning values to some variables and see how we use them.

```bash
a=5
```

Now the values 5 is stored in the variable named `a`. To use the variable we have to put a `$` sign in front of it so that bash knows we are referring to the variable `a` and not just typing the letter `a`. To see the result of using the variable, we can use the program `echo`, which prints whatever you give it to the terminal.

```bash
echo print this text to the terminal
echo "you can use quotes if you want to"
```

As you see, all the words you give it are printed just the way they are. Try putting the variable somewhere in the text.

```bash
echo Most international flights leave from terminal $a at Arlanda airport
```

Bash will see that you have a variable there and will replace the variable name with the value the variable have before sending the text to echo. If you change the value of `a` and run the exact command again you will see that it changes.

```bash
a="five"
echo Most international flights leave from terminal $a at Arlanda airport
```

So without changing anything in the echo statement, we can make it output different things, all depending on the value of the variable `a`. This is one of the main points of using variables, that you don't have to change the code or script but you can still make it behave differently depending on the values of the variables.

You can also do mathematics with variables, but we have to tell bash that we want to do calculations first. We do this by wrapping the calculations inside a dollar sign (telling bash it's a variable) and double parentheses, i.e. `$((5+5))`.

```bash
a=4
echo $a squared is $(($a*$a))
```

:clipboard: Write a echo command that will print out the volume of a [rectangular cuboid](https://www.mathsisfun.com/cuboid.html), with the side lengths specified by variables named `x`, `y`, and `z`. To see that it works correctly, the volume of a rectangular cuboid with sides 5,5,5 is 125, and for 4,5,10 is 200. *Give it a couple of tries on your own first. If you get completely stuck you can see a suggested solution below.*

<details>
  <summary>Solution</summary>

```bash
x=4
y=5
z=10
echo The volume of the rectangular cuboid with the sides $x,$y,$z is $(($x*$y*$z)).
```

</details>


## Exercises

First off, let's open another terminal so that you have 2 of them open. Scripting is a lot easier if you have one terminal on the command line ready to run commands and test things, and another one with a text editor where you write the actual code. That way you will never have to close down the text editor when you want to run the script you are writing on, and then open it up again when you want to continue editing the code.

So open a new terminal window and make sure both terminals are in the `~/1MB438/RESULTS/linux_scripts` directory, and start editing a new file with `nano` where you write your script. Name the file whatever you want, but in the examples I will refer to it as `loop_01.sh`. Write your loops to this file (or create a new file for each new example) and test run it in the other terminal.

The most simple loops are the ones that loop over a predefined list. You saw examples of this in the lecture slides, for example:

```bash
for i in "Print these words" one by one;
do
    echo $i
done
```

which will print the value of `$i` in each iteration of the loop. Write this loop in the file you are editing with `nano`, save the file, and then run it in the other terminal you have open.

```bash
bash loop_01.sh
```

As you see, the words inside the quotation marks are treated as a single unit, unlike the words after. You can also iterate over numbers, so erase the previous loop you wrote and try this instead:

```bash
for number in 1 2 3;
do
    echo $number
done
```

If everything worked correctly you should have gotten the numbers `1 2 3` printed to the screen. As you might guess, this way of writing the list of numbers to iterate over will not be usable once you have more than 10 or so numbers you want to loop over. Fortunately, the creators of bash (and most other computer languages) saw this problem coming a mile away and did something about it. To quickly create a list of numbers in bash, you can use something called a sequence expression to create the list for you.

```bash
for whatevernameyouwant in {12..72};  
do  
    echo $whatevernameyouwant  
done  
```

### Exercise 1

:clipboard: Let's say it's New Year's Eve and you want to impress your friends with a computerized countdown of the last 10 seconds of the year (don't we all?).

Start off with getting a loop to count down from 10 to 0 first. Notice how fast the computer counts? That won't do if it's seconds we want to be counting down. Try looking the man page for the `sleep` command (`man sleep`) and figure out how to use it. The point of using `sleep` is to tell the computer to wait for 1 second after printing the number, instead of rushing to the next iteration in the loop directly. Try to implement this on your own.

<details>
  <summary>Solution</summary>

```bash
# declare the values the loop will loop over
for secondsToGo in {10..0};
do
    # print out the current number
    echo $secondsToGo

    # sleep for 1 second
    sleep 1

done

# Declare the start of a new year in a festive manner
echo Happy New Year everyone!!
```

</details>

### Exercise 2

Let's try to do something similar to the example in the lecture slides, to run the same commands on multiple files. In the [Pipes exercise](Lab_0.1.0.pipes.md), we learned how to use samtools to convert BAM files to SAM files so that humans can read them.
In real life you will never do this, instead you will most likely always do it the other way around. SAM files take up ~4x more space on the hard drive compared to the same file in BAM format, so as soon as you see a SAM file you should convert it to a BAM file instead to conserve hard drive space. If you have many SAM files that needs converting you don't want to sit there and type all the commands by hand like some kind of animal.

:clipboard: Write a script that converts all the SAM files in a specified directory to BAM files. Incidentally, you can find 50 SAM files in need of conversion in the folder called `sam` in the folder you extracted to your folder earlier in this lab `~/1MB438/RESULTS/linux_scripts/sam`. Bonus points if you make the program take the specified directory as an argument, and another bonus point if you get the program to name the resulting BAM file to the same name as the SAM file but with a `.bam` ending instead of `.sam` (e.g. `sample_4.sam` -> `sample_4.bam`).

The way you get samtools to convert a SAM file to a BAM file is by typing the following command:

```bash
samtools view -b sample_1.sam > sample_1.bam
```

The `-b` option tells samtools to output BAM format.

:bulb: Remember, Google is a good place to get help. If you get stuck, google "bash remove file ending" or "bash argument to script" and look for hits from [StackOverflow/StackExchange](https://stackoverflow.com/) or similar pages. There are always many different way to solve a problem. Try finding one you understand what they do and test if you can get them to work the way you want. If not, look for another solution and try that one instead.

<details>
  <summary>Basic solution, without bonus points</summary>


```bash
# move to the SAM files directory to start with
cd sam

# use ls to get the list to iterate over
for file in *.sam;
do
    # do the actual converting, just slapping on .bam at the end of the name
    samtools view -b $file > $file.bam
done
```
</details>

<details>
  <summary>Advanced solution,with bonus point</summary>

```bash
# move to the SAM files directory to start with.
# $1 contains the first argument given to the program
cd $1

# use ls to get the list to iterate over.
for file in *.sam;
do

    # print a message to the screen so that the user knows what is happening.
    # $(basename $file .sam) means that it will take the file name and remove .sam
    # at the end of the name.
    echo "Converting $file to $(basename $file .sam).bam"

    # do the actual converting
    samtools view -b $file > $(basename $file .sam).bam
done
```
</details>

### Exercise 3

Let's add a small thing to the exercise we just did. If there already exists a BAM file with the same name as the SAM file it's not necessary to convert it again. Let's use an `if` statement to check if the file already exists before we do the conversion.

The following `if` statement will check if a given filename exists, and prints a message depending on if it exists or not.

```bash
FILE=$1

if [ -f $FILE ];
then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist."
fi
```

What we want to do is to check if the file **doesn't** exists. The way to do that is to invert the answer of the check if the file does exist. To do that in bash, and many other languages, is to use the exclamation mark, `!`,  which in these kinds of logical situations means **NOT** or **the opposite of**.

```bash
FILE=$1

if [ ! -f $FILE ];
then
    echo "File $FILE does not exist."
fi
```

:clipboard: Now, modify the previous exercise to only do the conversion if a file with the intended name of the BAM file doesn't already exists. *i.e*; if you have `a.sam` and want to create a BAM file named `a.bam`, first check if `a.bam` already exists and only do the conversion if it does not exist.

<details>
  <summary>Basic solution</summary>

```bash
# move to the SAM files directory to start with.
cd sam

# use ls to get the list to iterate over.
for file in *.sam;
do
    # check if the intended output file does not already exists
    if [ ! -f $file.bam ];
    then
        # do the actual converting, just slapping on .bam at the end of the name
        samtools view -b $file > $file.bam
    fi
done
```
</details>

<details>
  <summary>Advanced solution</summary>

```bash
# $1 contains the first argument given to the program
cd $1

# use a pattern to get the list to iterate over.
for file in *.sam;
do

    # basename will remove the path information to the file, and will also remove the .sam ending
    filename_bam=$(basename $file .sam)

    # add the .bam file ending to the filename
    filename_bam=$filename_bam.bam

    # check if the intended output file does not already exists.
    if [ ! -f $filename_bam ];
    then

        # print a message to the screen so that the user knows what is happening.
        echo "Converting $file to $filename_bam"

        # do the actual converting
        samtools view -b $file > $filename_bam

    else
        # inform the user that the conversion is skipped
        echo "Skipping conversion of $file as $filename_bam already exist"
    fi
done
```
</details>

### Bonus exercise 1  

Math and programming are usually a very good combination, so many of the examples of programming you'll see involve some kind of math. Now we will write a loop that will calculate the factorial of a number. As [wikipedia will tell you](https://en.wikipedia.org/wiki/Factorial), *"the factorial of a non-negative integer n, denoted by n!, is the product of all positive integers less than or equal to n"*, i.e. multiply all the integers, starting from 1, leading up to and including a number with each other.

The factorial of 5, written 5!, would be `1*2*3*4*5=120`. Doing this by hand would start taking its time even after a couple of steps, but since we know how to loop that should not be a problem anymore.

:clipboard: Write a loop that will calculate the factorial of a given number stored in the variable `$n`.

:bulb:
A problem that you will encounter is that the sequence expression, `{1..10}`, from the previous exercise doesn't handle variables. This is because of the way bash is built. The sequence expressions are handled before handling the variables so when bash tries to generate the sequence, the variable names have not yet been replaced with the values they contain. This leads to bash trying to create a sequence from 1 to `$n`, which of course doesn't mean anything.

To get around this we can use a different way of generating sequences (there are **always** alternatives). There is a program called `seq` that does pretty much the same thing as the sequence expression, and since it is a program it will be executed **after** the variables have been handled. It's as easy to use as the sequence expressions; instead of writing `{1..10}` just write `$( seq 1 10 )`.

The `$()` tells bash to run something in a **subshell**, which pretty much means it will run the command within the paratheses and then take whatever that command printed to the screen and replace the parantheses expression:

```bash
echo $(seq 1 5)

# becomes

echo 1 2 3 4 5
```

<details>
  <summary>Solution</summary>

```bash
# set the number you want to calculate the factorial of
n=10

# could also be supplied through an argument to the program
# n=$1

# you have to initialize a variable before you can start using it.
# Leaving this empty would lead to the first iteration of the loop trying
# to use a variable that has no value, which would cause it to crash
factorial=1

# declare the values the loop will loop over (1 to whatever $n is)
for i in $( seq 1 $n );
do

    # set factorial to whatever factorial is at the moment, multiplied with the variable $i
    factorial=$(( $factorial * $i ))

    # an alternative solution which gives exactly the same result, but makes it a bit more readable maybe
    # temporary_sum=$(( $factorial * $i ))
    # factorial=$temporary_sum

done

# print the result
echo The factorial of $n is $factorial
```
</details>

### Bonus exercise 2

Now, let's combine everything you've learned so far in this course.

:clipboard: Write a script that runs the exome sequencing pipeline from the [Pipelines extra exercise](Lab_0.extra.pipelines.md#running-the-programs) for each `fastq` file in a specified directory, using the same reference genome as in the pipelines extra exercise. If you have not yet done the pipeline extra exercise, please follow the instructions in that lab from the beginning and up until you reach the section called "*Running the programs*". This will ensure you have all the files copied and the environment setup correctly to do the analysis. 

When the analysis is done, only fastq files and called SNP files should be in your folder.

There is a bunch of `fastq` files in the directory `~/1MB438/RESULTS/linux_scripts/fastq/` that is to be used for this exercise. Once you have your loop running, make sure you don't get any error messages printed and that each of the 3 steps of the pipeline are carried out. Since there are 120 samples to be analyzed and it takes 12 seconds per sample, it will run for about 20 minutes. Once you see that it is running without errors and all the steps are carried out, feel free to terminate the program by holding `ctrl-c` until it stops.

<details>
  <summary>Basic solution</summary>

```bash
# make the dummy pipeline available
export PATH=$PATH:~/1MB438/RESULTS/linux_pipelines/dummy_scripts

# go to the input files
cd $1

# loop over all the fastq files
for file in *.fastq;
do

    # filter the reads
    filter_reads -i $file -o $file.filtered

    # align the reads
    align_reads -r ~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -i $file.filtered -o $file.filtered.aligned.sam

    # call SNPs
    find_snps -r ~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -i $file.filtered.aligned.sam -o $file.filtered.aligned.snpcalled.pileup 

done

# remove intermediate files
rm *.sam *.filtered
```
</details>

<details>
  <summary>Advanced solution</summary>

```bash
# make the dummy pipeline available
export PATH=$PATH:~/1MB438/RESULTS/linux_pipelines/dummy_scripts


# go to the input files
cd $1

# loop over all the fastq files
for file in *.fastq;
do

    # print status report
    echo Processing $file

    # save the file name without the file ending for convenience
    file_prefix=$(basename $file .fastq)

    # filter the reads
    filter_reads -i $file -o $file_prefix.filtered.fastq

    # align the reads
    align_reads -r ~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -i $file_prefix.filtered.fastq -o $file_prefix.filtered.aligned.sam

    # call SNPs
    find_snps -r ~/1MB438/RESULTS/linux_pipelines/data/ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa -i $file_prefix.filtered.aligned.sam -o $file_prefix.filtered.aligned.snpcalled.pileup 
done

# remove intermediate files
rm *.sam *.filtered.fastq
```
</details>

Alright, all done! You should now know more than enough to complete the rest of the course.

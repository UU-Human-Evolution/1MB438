# Hidden word quest

_This exercise was modifed from an original idea by Kristian Rother, see www.academis.eu._ 

## Introduction

The goal of this exercise is to use and test what you have learned today about interacting with the command line on Unix/Linux.

You will have to:

* Navigate directories and files
* Edit text files
* Copy and remove files
* Process text data


### Requirements
Before starting, the [hidden\_word\_exercise.zip](DATA/Lab0/linux_pipes/hidden_word_exercise.zip) file with the exercise material must be unpacked into your lab folder. The file is located here `~/1MB438/DATA/Lab0/linux_pipes/hidden_word_exercise.zip` Use `unzip` on the command line to extract it to the folder you are standing in.

```
# make sure you are standing in the correct directory
cd ~/1MB438/RESULTS/linux_pipes

# using a relative path
unzip ../../DATA/Lab0/linux_pipes/hidden_word_exercise.zip  

# or using an absolute path
unzip ~/1MB438/DATA/Lab0/linux_pipes/hidden_word_exercise.zip
```

This will create the folder `hidden_words` which contains the files we will be working with, so `cd` your way into that directory.

### Task
In this exercise, you will be searching for 12 characters making two words. All characters are hidden in the exercises below. All exercises should be solved using the Unix command line only.
Write down the letters you acquire and the commands used to find them!

NOTE: In these exercises, you will run several small Perl scripts. If you are curious, don't hesitate to open them and try to understand what they do.




## 1 Directories and files

### 1.1 Navigating directories
The first character is hidden in a file somewhere in the `exercise_1` directory. Use the commands `cd` and `ls` to find the directory with the name `solution_1.1`. If you went to a wrong directory, you can always type `cd ..` to go back one level, or `cd` to go back to the beginning.

### 1.2 Show a hidden file
Some files are not visible immediately but are instead hidden. Hidden files are recognized by the `.` in front of their name. To see hidden files, you need to issue the `ls -a` command. This will allow you to find the second character, hidden in the same directory as the first character.

### 1.3 Execute a program
Go back to the directory `exercise_1/directoryB/`. When listing its contents, you should see a Perl program. To find the next character, you need to execute the program. You can do this with the command `perl <program_name>` and the character should appear on your Terminal window.

### 1.4 Find out how big a file is
Go now to `exercise_1/directoryC/`. To find the fourth character, you first need to find out how big the `text_file.txt` in the directory is. This is done with the command `ls -l`. This will produce a long format list, where you can see the file size (in bytes), the file's owner, permissions to read and modify it, and the date/time of the last modification. To obtain the fourth character, execute the Perl program `file_size_check.pl` - the program will ask you to enter the size of the file.

**HINT**: When typing names of directories or files, try typing the first three characters, and press `<TAB>`. Unix will try to guess what you are typing.
## 2 Edit text files
To find out more letters, navigate to the directory `exercise_2`.
### 2.1 See the content of a file
In the directory `exercise_2/`, you will find the text file `solution_2.1.txt`. The fifth character is inside that file. By now you should know at least one way of viewing files.


### 2.2 Edit text files
To find character number six, you will need to create a text file in the `exercise_2` directory. On Linux and MacOS, you can do this using for example the editor `nano`. You can start this program by typing the name of the program followed by the name of the file you want to create (we will name this file solution_2.2.txt): 
```
nano solution_2.2.txt
```
 Add now the exact text `Please give me solution 2.2`, then save and quit `nano`. To save a file in `nano`, press `Ctrl+o`, to quit `Ctrl+x`. Afterwards, run the Perl program `text_file_check.pl`.
## 3 Copy and remove files
Please go to the directory `exercise_3`.
### 3.1 Create a directory and copy a file to it
To find the next two characters, you will have to create a subdirectory named `solution` in `exercise_3` and copy the file `codes.txt` to it. Use the command `mkdir` to make directories . For copying files, you can use the command `cp <filename from> <filename to>`. Use the command ls solution/ afterwards to verify that the file `codes.txt` is there. Finally, run the Perl program `check_code.pl` to find the characters.
### 3.2 Removing files
In the same directory, there is a file `junk.txt` that does not contain anything useful, and we would like to delete it. To delete it, use the `rm <filename>` command. Also, there are more files to be deleted in the `data` directory. To remove more than one file at once, you can use the wildcard `*`, for example from the directory `exercise_3`:

```
rm data/junk*
```

 will remove all the files in `data/` which filenames start with `junk`, all at once.

**WARNING**: On the command line, it is not possible to recover files once deleted. Use the `rm` command wisely!
To get characters number nine and ten, run the Perl program `check_junk.pl` after removing all the files.
## 4 Find text and combine commands
To find the last 2 characters, move to the directory `exercise_4`.
### 4.1 grep and pipe
`exercise_4` contains a text file, which corresponds to the Wikipedia page for Bioinformatics. Have a look at the content of this file with less. As you can
see, it is a rather long file with 269 lines (you can run the command `wc -l text.txt` to convince yourself). You can also use the command grep to search this file, for example `grep bioinformatics text.txt` will output to your Terminal all the lines that contain the word `bioinformatics`.
To discover the last 2 hidden characters, you need to run the Perl program `get_last2char.pl`, which requires as argument on the command line the number of lines in `text.txt` that contain the word `bioinformatics`. Combine `grep` and `wc` to help you find this number (hint: the `|` symbol can be used to combine commands).
Now you should have all the letters you need to make out the hidden word. 

Voilà! This is the end of this tutorial.

 

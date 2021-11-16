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

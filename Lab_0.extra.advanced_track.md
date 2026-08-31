# Extra material: for people who already know Linux

This file is entirely optional. If you came into this course already comfortable with `cd`, `ls`, `grep`, pipes and basic bash loops, the exercises below go a bit further, while staying in the same "biology files on the command line" world as the rest of the course.

None of this is required for the hand-in. Do as much or as little of it as you like.

## `find` and `xargs`

You've used wildcards (`*`) to match files, but wildcards are handled by the shell *before* the command runs, and only match files directly in the folder you specify. `find` searches recursively and can filter on much more than a name pattern: type, size, age, permissions, and so on.

```bash
cd ~/1MB438/RESULTS
find . -name "*.bam"
```

:clipboard: Use `find` to locate every `.sam` file anywhere under `~/1MB438/RESULTS`, regardless of how deeply nested it is, and count how many there are in total.

<details>
  <summary>Solution</summary>

```bash
find ~/1MB438/RESULTS -name "*.sam" | wc -l
```

</details>

`find` can also run a command on every match it finds, using `-exec`. The `{}` is replaced with the matched file, and the command must end with `\;`.

```bash
find . -name "*.sam" -exec ls -lh {} \;
```

`xargs` does something similar but is often faster, since it can batch many files into a single command call instead of starting a new process per file.

```bash
find . -name "*.sam" | xargs ls -lh
```

:clipboard: Use `find` piped into `xargs` to convert every `.sam` file under `~/1MB438/RESULTS/linux_scripts/sam` to `.bam`, in a single line, without writing a loop.

:bulb: `xargs -I{}` lets you place the matched item anywhere in the command, which is needed here since the output filename for `samtools` has to go after a `>`, not just at the end of the command.

<details>
  <summary>Solution</summary>

```bash
find ~/1MB438/RESULTS/linux_scripts/sam -name "*.sam" | xargs -I{} sh -c 'samtools view -b {} > {}.bam'
```

</details>

## Makefiles: only redo the work that changed

The bash scripts you've written so far redo every step, every time you run them. `make` (built originally for compiling code, but useful for any pipeline) only reruns a step if its inputs are newer than its output. That's exactly what you want when you're iterating on a pipeline and don't want to wait 20 minutes to reprocess samples that haven't changed.

A `Makefile` consists of rules:

```makefile
output_file: input_file
	command that produces output_file from input_file
```

:bulb: The indentation before the command **must** be a literal tab character, not spaces. This trips up everyone the first time.

:clipboard: Go to `~/1MB438/RESULTS/linux_pipelines/data/exomeSeq/`, and write a `Makefile` with rules for the 3-step exome pipeline from the [pipelines lab](Lab_0.extra.pipelines.md) (filter -> align -> find SNPs), so that running `make` produces the final `.pileup` file. Remember to do the `export PATH` step in the [pipelines lab](Lab_0.extra.pipelines.md) to have access to the scripts needed to run the analysis:

```bash
export PATH=$PATH:~/1MB438/RESULTS/linux_pipelines/dummy_scripts
```

<details>
  <summary>Solution</summary>

```makefile
REF=../ref_data/Homo_sapiens.GRCh37.57.dna_rm.concat.fa

my_reads.filtered.fastq: raw_data/my_reads.rawdata.fastq
	filter_reads -i raw_data/my_reads.rawdata.fastq -o my_reads.filtered.fastq

my_reads.filtered.aligned.sam: my_reads.filtered.fastq
	align_reads -i my_reads.filtered.fastq -o my_reads.filtered.aligned.sam -r $(REF)

my_reads.filtered.aligned.snpcalled.pileup: my_reads.filtered.aligned.sam
	find_snps -i my_reads.filtered.aligned.sam -o my_reads.filtered.aligned.snpcalled.pileup -r $(REF)
```

Run `make my_reads.filtered.aligned.snpcalled.pileup`, then run it again immediately — `make` reports there's nothing to do, since none of the inputs changed. Now `touch raw_data/my_reads.rawdata.fastq` and run it once more: since the input now looks newer than the outputs, `make` reruns the whole chain.

</details>

## Backgrounding and process management

You've used `top` to look at running programs, but you can also control them from the shell. Starting a program normally leaves your terminal stuck waiting for it (it runs "in the foreground"). Adding `&` at the end sends it to the background instead, freeing up your terminal.

```bash
sleep 60 &
```

```bash
jobs        # list background jobs started from this terminal
fg          # bring the most recent background job back to the foreground
```

If you close the terminal, background jobs die with it — unless you started them with `nohup` and detached them with `disown`, in which case they survive even after you log out.

```bash
nohup sleep 300 &
disown
```

:clipboard: Start 3 `sleep` commands of different lengths in the background in the same terminal, list them with `jobs`, and figure out how to bring a *specific* one (not just the most recent) to the foreground.

<details>
  <summary>Solution</summary>

```bash
sleep 30 &
sleep 60 &
sleep 90 &
jobs
# [1]  Running   sleep 30 &
# [2]-  Running   sleep 60 &
# [3]+  Running   sleep 90 &

fg %2   # brings job number 2 to the foreground
```

</details>

## A git mini-challenge

You've already used `git clone` and `git pull` to get the course material. Git is also useful for your own scripts, not just for downloading other people's code.

:clipboard: In your `RESULTS` folder, turn `linux_scripts` into its own git repository, and commit the scripts you wrote during the [scripts lab](Lab_0.2.scripts.md).

```bash
cd ~/1MB438/RESULTS/linux_scripts
git init
git add loop_01.sh   # and whichever other scripts you wrote
git commit -m "First version of my SAM to BAM conversion scripts"
```

:clipboard: Now write the hardened version of the script from the [scripts lab advanced extension](Lab_0.2.scripts.md), commit it as a second commit, and use `git log` and `git diff` to compare the two versions.

:bulb: This is genuinely how you should track your own analysis scripts in real projects. It costs three commands and gives you a full history of every version, which matters a lot once "it worked last week" turns out to be important.

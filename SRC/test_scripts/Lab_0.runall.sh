# crash on errors and print commands used
set -x
set -e
shopt -s expand_aliases

alias ll='ls -lh'

# go to the test script folder
cd ~/1MB438/SRC/test_scripts

# run the scripts in order
bash Lab_0.0.intro.test.sh
bash Lab_0.1.hidden_words.sh
bash Lab_0.extra.pipelines.test.sh
bash Lab_0.extra.permissions.test.sh
bash Lab_0.1.pipes.test.sh
bash Lab_0.2.scripts.test.sh

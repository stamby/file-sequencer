# file-sequencer

Renames files to make a sequence with them, in the order in which they were
passed as arguments.

Usage: run `./file-sequencer.sh --help`


```shell
# This will rename every 'txt' file to a sequence of 01.txt, 02.txt and up
./file-sequencer.sh '%02d.txt' new_dir *.txt

# This will sort them by date so that the oldest file becomes '01.txt' and so on
ls -tr *.txt | xargs ./file-sequencer.sh '%02d.txt' new_dir
```

To see the newly copied files in the last example, do:

```shell
cd new_dir
ls
```

<p align="center">
  <img
       src="https://cdn.discordapp.com/attachments/390248863841255434/586208084305903661/unknown.png">
</p>

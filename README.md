# file-sequencer

Renames files to make a sequence with them, in the order in which they were
passed as arguments.

Usage: run `./file-sequencer.sh --help`

Recommended usage: sorting them by date

```shell
ls -tr | xargs ./file-sequencer.sh '%04d.txt' new_dir
```

Result of the above command:

- Oldest file named *0001.txt* under new directory *new_dir*
- Newest file named the maximum file sequence number, plus extension.

To-do:

- Preserve old names, only changing them by adding the sequence number in FORMAT.

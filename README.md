# file-sequencer

Renames files to make a sequence with them.

Recommended usage: to sort them by date

```shell
ls -tr | xargs ./file-sequencer.sh "%04d.txt"
```

Result:

- Oldest file named *0001.txt*
- Newest file named the maximum file sequence number, plus the extension.

To-do:

- Preserve old names, only changing them by adding the sequence number in FORMAT.

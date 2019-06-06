#!/bin/sh

name="`basename $0`"

usage() {
    cat << EOF >&2
usage: $name FORMAT DIRECTORY FILES...

Rename the given FILES to a sequence of numbers, as per FORMAT.

FORMAT should be written the way it is with 'printf', leaving room for a single
number to appear in the file names. For instance, supposing you have 100 files:

"%d.txt" to name files 1.txt, 2.txt, [...] 100.txt
"DSC_%04d.JPG" to name them DSC_0001.JPG, DSC_0002.JPG, [...] DSC_0100.JPG

DIRECTORY is where the renamed FILES will be copied, will be created if non
existent.
EOF
    exit 1
}

if [ "$1" = --help ] || [ $# -lt 3 ]; then
    usage
fi

# Either 'cp' or 'mv' will do
COMMAND='cp -pv'
format="$1"
resulting_dir="$2"

printf "%s" "$format" | grep -qE '%[0-9]*[di]'

if [ $? != 0 ]; then
    printf "error: '%s' is not a valid format specifier.\n" "$format" >&2
    printf "Type '$name --help' for details.\n" >&2
    exit 1
fi

resulting_dir="$(printf "$resulting_dir" | sed 's./$..')"
if [ ! -e "$resulting_dir" ]; then
    mkdir -v "$resulting_dir"
    if [ ! -d "$resulting_dir" ]; then
        printf "error: the directory '%s' could not be created.\n" \
            "$resulting_dir" >&2
        exit 2
    fi
fi

count=-2

for item in "$@"; do
    count=$(($count+1))
    # Will ignore the first two arguments
    if [ $count -lt 1 ]; then
        continue
    fi

    command $COMMAND "$item" "$resulting_dir/$(printf "$format" $count)"
done

rmdir "$resulting_dir" 2> /dev/null
if [ $? = 0 ]; then
    printf "error: no files were copied into '%s', removing directory.\n" \
       "$resulting_dir" >&2
    exit 3
fi

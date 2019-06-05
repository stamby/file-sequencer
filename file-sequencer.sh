#!/bin/sh

usage() {
    cat << EOF >&2
usage: $0 FORMAT DIRECTORY FILES...

Rename the given FILES to a sequence of numbers, as per FORMAT.

FORMAT examples:
"%04d" to name files 0001, 0002, [...] 0100
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
COMMAND=cp
format="$1"
resulting_dir="$2"

printf "%s" "$format" | grep -qE '%[0-9]*d'

if [ $? != 0 ]; then
    printf "Error: '%s' is not a valid format specifier.\n" "$format" >&2
    printf "Type '$0 --help' for details.\n" >&2
    exit 1
fi

resulting_dir="$(printf "$resulting_dir" | sed 's./$..')"
if [ ! -e "$resulting_dir" ]; then
    mkdir -v "$resulting_dir"
    if [ ! -d "$resulting_dir" ]; then
        printf "Error: the directory '%s' could not be created.\n" \
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

    command $COMMAND -pv "$item" "$resulting_dir/$(printf "$format" $count)"
done

rmdir "$resulting_dir" 2> /dev/null
if [ $? = 0 ]; then
    printf "Error: no files were copied into '%s', removing directory.\n" \
       "$resulting_dir" >&2
    exit 3
fi

#!/bin/sh

usage() {
    cat << EOF >&2
usage: $0 [FORMAT] [DIRECTORY] FILES...

Rename the given FILES to a sequence of numbers, as per FORMAT.

FORMAT examples:
"%04d" to name files 0001, 0002, [...] 0100
"DSC_%04d.JPG" to name them DSC_0001.JPG, DSC_0002.JPG, [...] DSC_0100.JPG

DIRECTORY is where FILES will be copied to, will be created if non existent.
EOF
    exit 1
}

if [ "$1" = --help ]; then
    usage
fi

# Validate arguments

if [ $# -lt 3 ]; then
    printf "Error: %d argument(s) supplied, 3 needed.\n" $#
    printf "Type '$0 --help' for details.\n" >&2
    exit 1
fi

# Either 'cp' or 'mv' will do
COMMAND=cp
format="$1"
resulting_dir="$2"

printf "$format" | grep -qE '%[0-9]*d'

if [ $? != 0 ]; then
    printf "Error: '$format' is not a valid format specifier.\n" "$format" >&2
    printf "Type '$0 --help' for details.\n" >&2
    exit 1
fi

if [ ! -d "$resulting_dir" ]; then
    mkdir -v "$resulting_dir"
    if [ ! -d "$resulting_dir" ]; then
        printf "Error: the directory '%s' could not be created.\n" \
            "$resulting_dir" >&2
        exit 2
    fi
    resulting_dir="$(printf "$resulting_dir" | sed 's./$..')"
fi

count=-2

for item in "$@"; do
    count=$(($count+1))
    # Will ignore the first two arguments
    if [ $count -lt 1 ]; then
        continue
    fi

    command $COMMAND -v "$item" "$resulting_dir/$(printf "$format" $count)"
done

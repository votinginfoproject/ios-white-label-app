#!/bin/bash

# This script searches for strings files in the .lproj i8ln directories,
# and converts their encodings from acii types to UTF-16, the preferred
# format for strings files, according to the Apple resources documentation:
# https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html

# do not expand glob if no matches found
shopt -s nullglob

# go to main source directory
cd ../../objc/VotingInformationProject/VotingInformationProject

# find the strings files in lproj directories
for lp in *.lproj
do
    cd "$lp"
    for f in *.strings
    do
        if file --mime "$f" | grep us-ascii; then
            echo "Converting $f in $lp from US-ASCII to UTF-16..."
            mv "$f" "$f.bkp"
            iconv -f US-ASCII -t UTF-16 "$f.bkp" > "$f"
	    rm "$f.bkp"
        elif file --mime "$f" | grep ascii; then
            echo "Converting $f in $lp from ASCII to UTF-16..."
            mv "$f" "$f.bkp"
	    iconv -f ASCII -t UTF-16 "$f.bkp" > "$f"
            rm "$f.bkp"
        fi
    done
    cd ..
done
echo "All done!"

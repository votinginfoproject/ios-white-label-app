#!/bin/bash

# Looks for all instances of xcode generated copyright strings in our source files

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
regex='//\s*Copyright \(c\) [0-9]{4}[^.]*.\s*All rights reserved.\s*'

cd "$CWD/../../objc/VotingInformationProject/"
egrep -R "$regex" ./VotingInformationProject*/*

# If egrep fails that means there are no copyright strings and all is well
test $? -eq 1
exit $?

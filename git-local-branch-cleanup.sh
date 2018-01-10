#!/bin/bash

decorator="***********"
echo "$decorator Ni hao, $(whoami) $decorator"  # if $USER not working; can also be $(id -n -u)
echo -e "$decorator Today is \c";date   # get date
echo "You have the following files in the current directory, $PWD"
ls   # list some effin files





if [git ls-remote --heads ${REPO} ${BRANCH} | wc -l]     # check if remote branch exists - 1 = yes, 0 = no



# list all local branches
git branch

# get repo url
git config --get remote.origin.url

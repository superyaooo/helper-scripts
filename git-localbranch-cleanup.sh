#!/bin/bash

decorator="***********"
echo "$decorator Ni hao, $(whoami) $decorator"  # if $USER not working; can also be $(id -n -u)
echo Current directory: `pwd`
echo -en '\n'

# loop through all local branches; double quote needed here
echo "Local branches found:"
branches=$(git branch | sed 's/*//')     # `git branch` lists all local branches; `sed 's/*//'` removes "*" from string
for x in $branches
do
  echo $x
done

echo -en '\n'     # `e` interprets `\n`; `n` prevents empty/extra line on the end

# remove outdated local branches
echo "Searching for outdated local branches..."
echo -en '\n'
repo=$(git config --get remote.origin.url)    # back tick works too; `git config --get remote.origin.url` gets repo url
outdatedBranchCounter=0

for x in $branches
do
  remoteExists=$(git ls-remote --heads $repo $x | wc -l)   # check if remote branch exists - 1 = yes, 0 = no
  if [ $remoteExists = 0 ]; then    # space after & before square brackets is needed!!!
    echo "Outdated local branch found: $x"
    ((outdatedBranchCounter++))    # counter + 1
    deleteBranch=$(git branch -d "$x" | wc -l)
    if [ $deleteBranch = 1 ]; then
      echo ":) local branch $x deleted successfully"
    else
      echo "!! error occurred while deleting local branch $x"
    fi
  fi
done

if [ $outdatedBranchCounter = 0  ]; then
  echo ":) no outdated branch found"
fi

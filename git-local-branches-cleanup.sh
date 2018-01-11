#!/bin/bash

decorator="***********"
echo "$decorator Ni hao, $(whoami) $decorator"  # if $USER not working; can also be $(id -n -u)

# loop through all local branches; double quote needed here
echo "Local branches found:"
branches=$(git branch)     # `git branch` lists all local branches
for x in "$branches"
do
  echo "$x"
done

# remove outdated local branches
echo "Searching for outdated local branches..."
repo=$(git config --get remote.origin.url)    # back tick works too; `git config --get remote.origin.url` gets repo url
for br in "$branches"
do
  remoteExists=$(git ls-remote --heads $repo $br | wc -l)   # check if remote branch exists - 1 = yes, 0 = no
  if [ "$remoteExists" = 0 ]; then    # space after & before square brackets is needed!!!
    echo "Outdated local branch found: $br"
    deleteBranch=$(git branch -d "$br" | wc -l)
    if [ "$deleteBranch" = 1 ]; then
      echo "local branch $br deleted successfully"
    else
      echo "error occurred while deleting local branch $br"
    fi
  fi
done

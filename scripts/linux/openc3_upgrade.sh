#!/bin/bash

set -e

if ! command -v git &> /dev/null
then
  echo "git not found!!!"
  exit 1
fi

usage() {
  echo "Usage: openc3.sh upgrade <tag> --preview" >&2
  echo "e.g. openc3.sh upgrade v6.4.1" >&2
  echo "The '--preview' flag will show the diff without applying changes." >&2
  exit 1
}

if [ "$#" -eq 0 ]; then
  usage $0
fi

# Setup the 'cosmos' remote if it doesn't exist
# This allows us to pull the latest cosmos-project updates
if ! git remote -v | grep -q '^cosmos[[:space:]]'; then
  echo "Adding 'cosmos' remote to the current git repository."
  git remote add cosmos https://github.com/OpenC3/cosmos-project.git
fi

# Fetch the latest changes from the 'cosmos' remote
echo "Fetching latest changes from 'cosmos' remote."
git fetch cosmos

# Check the first argument is a valid git tag
if ! git tag | grep -q "^$1$"; then
  echo "Error: '$1' is not a valid git tag." >&2
  echo "Available tags:" >&2
  git tag | sort
  usage $0
fi

# If the --preview flag is set, show the diff without applying changes
if [ "$2" == "--preview" ]; then
  git diff HEAD $1
  exit 0
fi

git diff HEAD $1 | git apply --whitespace=fix
echo "Applied changes from tag '$1'."
echo "We recommend committing these changes to your local repository."
echo "e.g. git commit -am 'Upgrade to $1'"
echo "You can now run 'openc3.sh run' to start the upgraded OpenC3 environment."
echo

#!/bin/bash

# Only deploy if not PR
if [[ $TRAVIS_PULL_REQUEST = "false" && $TRAVIS_BRANCH = "master" ]]
  then
  cd _site || exit

  git init
  git checkout -b gh-pages
  git remote add origin "https://${GH_TOKEN}@github.com/urn/urn-history-project-gh-pages.git"

  # commit and push generated content to built branch
  # since remote was added with token auth - we can push there
  git config user.email "history@urn1350.net"
  git config user.name "URN Bot"
  git add -A .
  git commit -a -q -m "Travis Build $TRAVIS_BUILD_NUMBER for $TRAVIS_COMMIT"
  git push --quiet -f origin gh-pages > /dev/null 2>&1 # Hiding all the output from git push command, to prevent token leak.
fi

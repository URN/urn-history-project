#!/bin/bash

# enable error reporting to the console
set -e

echo "Bundle path: $BUNDLE_PATH"
echo "Event: $GITHUB_EVENT_NAME"

if [[ $RESET = "true" ]]
then
  rm -rf _site
  rm -rf tmp
fi

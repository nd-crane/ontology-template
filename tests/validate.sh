#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"/.. &> /dev/null && pwd )

if [ -f "/usr/local/jena/bin/riot" ]; then
    RIOT="/usr/local/jena/bin/riot"
else
    RIOT="riot"
fi
ONTPATHS=$(cat $ROOT_DIR/tests/modules.txt | awk -F, '{print $2}')


echo "Validating Ontology Modules"
for path in "$ONTPATHS"
do
  "$RIOT" --validate ./$path
done

# Build optional shapes if shapes.txt has content
if [ -s $ROOT_DIR/tests/shapes.txt ]; then
  echo "Validating Module Shapes"
  SHAPEPATHS=$(cat $ROOT_DIR/tests/shapes.txt | awk -F, '{print $2}')
  for path in "$SHAPEPATHS"
  do
    "$RIOT" --validate ./$path
  done
fi
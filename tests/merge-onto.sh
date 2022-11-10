#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )"/.. &> /dev/null && pwd )

mergecmd="rdfx"
files=$(cat $ROOT_DIR/tests/modules.txt | awk -F, '{print $2}')


VERSION=` grep -i versionInfo modules/core/metadata.ttl | sed 's/[^"]*"\([^"]*\).*/\1/'`

mkdir /tmp/ontology

if [ -f "/tmp/merged.ttl" ]; then
    rm /tmp/ontology/merged.ttl
fi

echo "Merging Ontology"
$mergecmd merge data $files -f ttl -o /tmp/ontology

# Build optional shapes if shapes.txt has content
if [ -s $ROOT_DIR/tests/shapes.txt ]; then
    echo "Merging Shapes"
    mkdir /tmp/shapes
    shapefiles=$(cat $ROOT_DIR/tests/shapes.txt | awk -F, '{print $2}')
    $mergecmd merge $shapefiles -f ttl -o /tmp/shapes
fi
#!/bin/bash

prefix=$1
maxpage=$2
dir=$3

echo "p = $prefix m = $maxpage"


for counter in $( seq 1  $maxpage)
do
    movedcounter="$(($maxpage - $counter + 1 ))"

    originalfile="$prefix$(printf '%04d' $counter)".jpeg
    movedfile="$prefix$(printf '%04d' $movedcounter)".jpeg
    cp $originalfile $dir/$movedfile

done


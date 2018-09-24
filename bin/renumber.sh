#!/bin/bash

# If you need to add additional files to fill in for missing files
# name them so that they will sort between them. For example, 
# if you  want to add one between ABCD0078.jpg and ABCD0079.jpg 
# name it ABCD0078a.jpg then run with:
# 
# renumber.sh ABCD destination_directory ABCD jpg

originalprefix=$1
destdir=$2
destprefix=$3
extension=$4
if [ -z "$destdir" ]
then
  exit "Can't use the same directory"
else
  destdir="$destdir/"
fi

counter=0

for file in  $(ls -p  $originalprefix* )  
do
    counter="$(( $counter + 1))"

    destinationfile="$destdir$destprefix$(printf '%04d' $counter)".$extension
    if [ "$destinationfile" != "$file" ] 
    then
      #echo "would cp -p $file $destinationfile"
      cp -p $file $destinationfile
    fi
done

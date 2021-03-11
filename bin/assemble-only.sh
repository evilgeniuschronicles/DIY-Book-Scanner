#!/bin/bash

prefix=$1
EXTENSION=png

# Get the count of the files in each of the incoming directories
numfiles=($prefix/$prefix*)
numfiles=${#numfiles[@]}

ocrdir="$prefix-ocr"
finaldir="$prefix-final"

mkdir -p $ocrdir
mkdir -p $finaldir

for counter in $( seq 1  $(($numfiles)) )
do
    paddedcounter="$(printf '%03d' $counter)"
    originalfilename=$prefix/$prefix$paddedcounter.$EXTENSION
    ocrfilename=$ocrdir/$prefix$paddedcounter
 
    echo "OCR on page $counter"
    tesseract $originalfilename $ocrfilename
done

echo "Assembling OCR version"

cat $ocrdir/* > $finaldir/$prefix.txt

echo "Cleaning up characters in OCR version"

uni2ascii -B $finaldir/$prefix.txt > $finaldir/$prefix-ascii.txt

#echo "Assembling PDF version"

#convert $pdfrenumbereddir/*.$EXTENSION $finaldir/$prefix.pdf

echo "Finished"

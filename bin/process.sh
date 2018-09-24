#!/bin/bash

EXTENSION=tif

prefix=$1

if [ -z $prefix ]
then
    echo "Usage: $0 prefix"; 

    exit 1; 
fi

# Get the count of the files in each of the incoming directories
numfilesstR=($prefix-stR/*)
numfilesstR=${#numfilesstR[@]}

numfilesstL=($prefix-stL/*)
numfilesstL=${#numfilesstL[@]}

numfilespdfR=($prefix-pdfR/*)
numfilespdfR=${#numfilespdfR[@]}

numfilespdfL=($prefix-pdfL/*)
numfilespdfL=${#numfilespdfL[@]}

if [ $numfilesstL -ne $numfilesstR ] || [ $numfilespdfL -ne $numfilespdfR ]
then
    echo "The number of files in the incoming directories is different. Please reconcile and try again."
    exit
fi

exit

renumbereddir="$prefix-renumbered"
pdfrenumbereddir="$prefix-pdf-renumbered"
ocrdir="$prefix-ocr"
finaldir="$prefix-final"

mkdir -p $renumbereddir
mkdir -p $pdfrenumbereddir
mkdir -p $ocrdir
mkdir -p $finaldir

for counter in $( seq 1  $maxpage)
do
    paddedcounter="$(printf '%04d' $counter)"
    lcounter="$(($maxpage *2 - (($counter -1) * 2) ))"
    rcounter="$(($counter * 2 -1 ))"

    lfile="$prefix$(printf '%04d' $lcounter)".$EXTENSION
    rfile="$prefix$(printf '%04d' $rcounter)".$EXTENSION
    cp $prefix"-stL"/$prefix"L"$paddedcounter.$EXTENSION $renumbereddir/$lfile
    cp $prefix"-stR"/$prefix"R"$paddedcounter.$EXTENSION $renumbereddir/$rfile
    cp $prefix"-pdfL"/$prefix"L"$paddedcounter.$EXTENSION $pdfrenumbereddir/$lfile
    cp $prefix"-pdfR"/$prefix"R"$paddedcounter.$EXTENSION $pdfrenumbereddir/$rfile

done

for counter in $( seq 1  $(($maxpage*2)) )
do
    paddedcounter="$(printf '%04d' $counter)"
    originalfilename=$renumbereddir/$prefix$paddedcounter.$EXTENSION
    ocrfilename=$ocrdir/$prefix$paddedcounter
 
    echo "OCR on page $counter"
    tesseract $originalfilename -psm 3 $ocrfilename  
done

echo "Assembling OCR version"

cat $ocrdir/* > $finaldir/book.txt

echo "Cleaning up characters in OCR version"

uni2ascii -B $finaldir/book.txt > $finaldir/book-ascii.txt

echo "Assembling PDF version"

convert $pdfrenumbereddir/*.tif $finaldir/book.pdf

echo "Finished"
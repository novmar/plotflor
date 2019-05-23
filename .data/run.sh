#! /bin/bash

# Radek Liboska 20190322

if [ "$1" == "" ]; then                          # parameter (filename) is mandatory	
 echo "Usage: run.sh filename"
 echo " (where filename is a 3-column tab delimited fluorescence datafile)"
 exit 2
fi

if [[ ! -f "$1" ]]                               # test the existence of input csv file
 then
 echo "File $1 not found"
 echo "Usage: run.sh filename"
 echo " (where filename is a 3-column tab delimited fluorescence datafile"
 exit 2
fi

nlines=$(wc -l <"$1")                            # get number of input file lines
blocklines=$(( nlines / 96 ))                    # divide by 96 (calculate block size)
sed -i.bkp '1~'$blocklines'i\\' "$1"             # separate blocks with newline, create backup file
                                                 # call gnuplot - generate plots
gnuplot -e "datafile='$1';blocksize='$blocklines'" fluorescence.gnuplot

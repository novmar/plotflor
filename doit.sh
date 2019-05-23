#!/bin/bash

tmpdir=tmp
tmpfile=$tmpdir/prepared
inputdir=input
outputdir=graphs
datadir=.data
plotfile=fluorescence.gnuplot
plottemplate=$datadir/$plotfile




function confirm_me {
	question=$@

	read -r -p "$question " response

	case "$response" in
		[Yy])
			result=1;
			;;
		[Nn])
			result=0;
			;;

		*)
			confirm_me "$question"
			;;
	esac


}

for directory in $tmpdir $inputdir $outputdir ; do # prepare directory
	if [[ ! -e $directory ]]; then
		confirm_me "Directory $directory doesn't exist. Create ?(Y/N) "
		if [[ $result == 0 ]] ; then
			echo "ok, You have to prepare directory \"$directory\"! "
			exit 1
		else
		mkdir $directory
		echo $directory created.
	fi
	fi
done


function graphfile {
	#prepare txt file
	#␣prepare␣TXT␣file¬
>·······tail␣+3␣"$vstup"␣|␣awk␣'{␣print␣$1␣"␣"$8"␣"$9␣}␣'␣>␣␣$tmpfile~¬                                                                                                                                                   
¬
>·······nlines=$(wc␣-l␣<"$tmpfile")␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣#␣get␣number␣of␣input␣file␣lines¬
>·······blocklines=$((␣nlines␣/␣96␣))␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣␣#␣divide␣by␣96␣(calculate␣block␣size)¬
>·······sed␣-i␣'1~'$blocklines'i\\'␣"$tmpfile"␣␣␣␣␣␣␣␣␣␣␣␣␣#␣separate␣blocks␣with␣newline,␣create␣backup␣fil¬
>·······gnuplot␣-e␣"datafile='$tmpfile';blocksize='$blocklines'"␣$plottemplate¬
>·······echo␣"Gnuplot␣done,␣Making␣␣png"¬
>·······montage␣$tmpdir/*.png␣-tile␣12x8␣-frame␣2␣-shadow␣-geometry␣'800x600+2+2>'␣test.png~¬
>·······echo␣"png␣done"¬
>·······rm␣-rfv␣tmp/*¬
¬
done¬










IFSBAK=$IFS
files=($(find $inputdir -type f -iname "*.txt"))
IFS=$IFSBAK
filescount=${#files[@]}

echo -e "\n\n Working on files: \n"
for ((i=0; i<$filescount; i++)); do
	echo "`basename "${files[$i]}"` "
	done
result=0;
confirm_me "Is that ok ? (Yy/Nn)"

if [[ $result == 0 ]]; then exit 1
	fi

for vstup in "$files"; do 
	filename="`basename "$vstup" .txt`"
echo "File $vstup " 

	rm -rf $tmpdir
	mkdir $tmpdir
	# prepare TXT file
	tail +3 "$vstup" | awk '{ print $1 " "$8" "$9 } ' >  $tmpfile 

	nlines=$(wc -l <"$tmpfile")                            # get number of input file lines
	blocklines=$(( nlines / 96 ))                    # divide by 96 (calculate block size)
	sed -i '1~'$blocklines'i\\' "$tmpfile"             # separate blocks with newline, create backup fil
	gnuplot -e "datafile='$tmpfile';blocksize='$blocklines'" $plottemplate
	echo "Gnuplot done, Making  png"
	montage $tmpdir/*.png -tile 12x8 -frame 2 -shadow -geometry '800x600+2+2>' test.png 
	echo "png done"
	rm -rfv tmp/*

done



##! /bin/bash
#
## Radek Liboska 20190322
#
#if [ "$1" == "" ]; then                          # parameter (filename) is mandatory
# echo "Usage: run.sh filename"
# echo " (where filename is a 3-column tab delimited fluorescence datafile)"
# exit 2
#fi
#
#if [[ ! -f "$1" ]]                               # test the existence of input csv file
# then
# echo "File $1 not found"
# echo "Usage: run.sh filename"
# echo " (where filename is a 3-column tab delimited fluorescence datafile"
# exit 2
#fi
#
#nlines=$(wc -l <"$1")                            # get number of input file lines
#blocklines=$(( nlines / 96 ))                    # divide by 96 (calculate block size)
#sed -i.bkp '1~'$blocklines'i\\' "$1"             # separate blocks with newline, create backup fil
#                                                 # call gnuplot - generate plots
#

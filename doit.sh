#!/bin/bash

export tmpdir=.data/tmp
export tmpfile=$tmpdir/prepared
export inputdir=input
export outputdir=graphs
export datadir=.data
export plotfile=fluorescence.gnuplot
export plottemplate=$datadir/$plotfile




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
	# prepare TXT file
	tail +3 "$tmpfile" | awk '{ print $1 " "$8" "$9 } ' >  $tmpfile".tmp"
	mv $tmpfile".tmp" $tmpfile

	nlines=$(wc -l <"$tmpfile")                            # get number of input file lines
	blocklines=$(( nlines / 96 ))                    # divide by 96 (calculate block size)
	sed -i '1~'$blocklines'i\\' "$tmpfile"             # separate blocks with newline, create backup fil
	gnuplot -e "datafile='$tmpfile';blocksize='$blocklines'" $plottemplate
	echo "Gnuplot done, Making  png"
	montage $tmpdir/*.png -tile 12x8 -frame 2 -shadow -geometry '800x600+2+2>' $outputdir"/done.png"
	rm -rf $tmpdir/*
	echo "png done"
}









echo -e "\n\n Working on files: \n"
find $inputdir -type f -iname "*.txt"
result=0;
confirm_me "Is that ok ? (Yy/Nn)"

if [[ $result == 0 ]]; then
echo -e "\nOk, take a time, prepare and run again!! "
exit 1
	fi

export -f graphfile

find $inputdir -type f -iname "*.txt" -exec sh -c '
for file do
    rm -rfv $tmpdir/*
    cp "$file" $tmpfile
    graphfile
    mv $outputdir/done.png "$outputdir/`basename "${file%.*}"`.png"
    mv "$file" "done/`basename "${file}"`"
    done
' sh {} +



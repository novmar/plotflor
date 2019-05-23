# gnuplot -e "datafile='test.csv';blocksize=267" test.gnuplot


unset title
set xlabel "Temperature [°C]"
set ylabel "Fluorescence [R.F.U.]"
set grid x
set grid y
set term png size 800,600
do for [t=0:95] {
 outfile = sprintf(datafile.'_%02.0f.png',t+1)
 set output outfile
 l = 2+(blocksize+1)*t
 s = 'echo $(awk ''FNR=='.l.' {print $1}'' '.datafile.')' 
 print system(s)
 plot datafile using 2:3 every :::t::t with lines title system(s)
# plot datafile using 2:3 every :::t::t with lines title sprintf('#%02.0f',t+1)
}


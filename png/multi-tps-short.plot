set terminal postscript eps size WIDTH,10 enhanced color font 'Helvetica,12'
set output 'FILE.eps'

set title "TITLE" font 'Helvetica,24'

set xrange [0:300]
set yrange [0:]
set key off

set multiplot layout 4,FSCOUNT rowsfirst

set terminal postscript eps size WIDTH,10 enhanced color font 'Helvetica,12'
set output 'FILE.eps'

set title "TITLE" font 'Helvetica,24'

set xrange [0:7200]
set yrange [0:]
set logscale y

set multiplot layout 4,FSCOUNT rowsfirst

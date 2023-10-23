set terminal postscript eps size 10,4 enhanced color font 'Helvetica,12'
set output 'tps-short.eps'

set title "TITLE" font 'Helvetica,24'

set xrange [0:300]

plot 'tps.data' using 1:3 with lines

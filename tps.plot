set terminal postscript eps size 10,4 enhanced color font 'Helvetica,12'
set output 'tps.eps'

set title "TITLE" font 'Helvetica,24'

set xrange [0:7200]

plot 'tps.data' using 1:3 with lines lc rgb '#cccccc', \
     'tps.data' using 1:4 with lines lc rgb '#cc0000'

set terminal postscript eps size 10,4 enhanced color font 'Helvetica,12'
set output 'latencies.eps'

set title "TITLE" font 'Helvetica,24'

set xrange [0:7200]
set logscale y

plot 'summary.data' using 1:7 with lines title 'p99', \
     'summary.data' using 1:6 with lines title 'p95', \
     'summary.data' using 1:5 with lines title 'p75', \
     'summary.data' using 1:4 with lines title 'p50', \
     'summary.data' using 1:3 with lines title 'p25'

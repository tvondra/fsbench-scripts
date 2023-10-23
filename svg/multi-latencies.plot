set terminal svg size WIDTH,1200 enhanced background rgb 'white' font 'Helvetica,12'
set output 'FILE.svg'

set title "TITLE" font 'Helvetica,24'

set xrange [0:7200]
set yrange [0:]
set logscale y

set multiplot layout 4,FSCOUNT rowsfirst

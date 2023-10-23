set title 'FS / TYPE / SCALE'
plot 'FS/SCALE/TYPE/CLIENTS/tps.data' using 1:3 with lines lc rgb '#cccccc', \
     'FS/SCALE/TYPE/CLIENTS/tps.data' using 1:4 with lines lc rgb '#cc0000'

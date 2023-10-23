set title 'FS / TYPE / SCALE'
plot 'FS/SCALE/TYPE/CLIENTS/summary.data' using 1:8 with lines title 'p99', \
     'FS/SCALE/TYPE/CLIENTS/summary.data' using 1:7 with lines title 'p95', \
     'FS/SCALE/TYPE/CLIENTS/summary.data' using 1:6 with lines title 'p75', \
     'FS/SCALE/TYPE/CLIENTS/summary.data' using 1:5 with lines title 'p50', \
     'FS/SCALE/TYPE/CLIENTS/summary.data' using 1:4 with lines title 'p25'

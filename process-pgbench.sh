#!/usr/bin/bash -x

set -e

DIR=`pwd`
SRCDIR=`dirname $0`
DBNAME=$1

for f in `find ./ -iname pgbench.tgz | sort -r`; do

	DESTDIR=`dirname $f`
	DESTDIR=`realpath $DESTDIR`

	if [ -f "$DESTDIR/summary.data" ]; then
		continue
	fi

	WORKDIR=`mktemp -d`

	pushd $WORKDIR

	rm -f pgbench_log.*

	tar -xf $DIR/$f

	psql $DBNAME -c "drop table if exists pgbench_log"

	psql $DBNAME -c "create table pgbench_log (client_id bigint, transaction_no bigint, transaction_time bigint, script_no bigint, time_epoch bigint, time_us bigint)"

	for x in pgbench_log.*; do
		cat $x | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6}' > $x.csv &
	done

	wait

	for x in pgbench_log.*.csv; do
		psql $DBNAME -c "copy pgbench_log from '$WORKDIR/$x' with (format csv, delimiter ' ')" &
	done

	wait

	psql $DBNAME -c "vacuum analyze pgbench_log"

	min=`psql $DBNAME -t -A -c "select min(time_epoch) from pgbench_log"`

	psql -t -F ' ' -A $DBNAME > $DESTDIR/summary.data.tmp <<EOF
SELECT
    ts, tps,
    avg(tps) over (order by ts rows between 5 preceding and 5 following) AS tps_avg,
    p25, p50, p75, p95, p99
FROM (
    SELECT
        (time_epoch - $min) as ts,
        (20 * count(*)) as tps,
        percentile_disc(0.25) within group (order by transaction_time) as p25,
        percentile_disc(0.50) within group (order by transaction_time) as p50,
        percentile_disc(0.75) within group (order by transaction_time) as p75,
        percentile_disc(0.95) within group (order by transaction_time) as p95,
        percentile_disc(0.99) within group (order by transaction_time) as p99
    FROM pgbench_log GROUP BY time_epoch) foo
    ORDER BY ts
EOF

	mv $DESTDIR/summary.data.tmp $DESTDIR/summary.data

	popd

	rm -Rf $WORKDIR

done

for f in `find ./ -iname stat-database.csv | sort -r`; do

	DESTDIR=`dirname $f`
	DESTDIR=`realpath $DESTDIR`

	if [ -f "$DESTDIR/tps.data" ]; then
		continue
	fi

	echo $f

	cat $f | $SRCDIR/process-tps.py > $DESTDIR/tps.data.tmp

	mv $DESTDIR/tps.data.tmp $DESTDIR/tps.data

done

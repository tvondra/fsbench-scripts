
for m in i5 xeon; do

	for run in `ls $m | grep run-2`; do

		echo "* $run"
		echo ""
		echo "  * tps: [eps]($m/$run/tps.eps) [svg]($m/$run/tps.svg)"
		echo "  * latencies: [eps]($m/$run/latencies.eps) [svg]($m/$run/latencies.svg)"

		latencies=""
		tps=""

		for fs in btrfs btrfs-no-compress ext4 xfs zfs zfs-no-compress zfs-no-fpw; do

			if [ -f "$m/$run/tps-$fs.eps" ]; then
				latencies="$latencies [$fs]($m/$run/latencies-$fs.eps)"
				tps="$tps [$fs]($m/$run/tps-$fs.eps)"
			fi

		done

		echo "  * latencies (eps): $latencies"
		echo "  * tps (eps): $tps"

		latencies=""
		tps=""

		for fs in btrfs btrfs-no-compress ext4 xfs zfs zfs-no-compress zfs-no-fpw; do

			if [ -f "$m/$run/tps-$fs.svg" ]; then
				latencies="$latencies [$fs]($m/$run/latencies-$fs.svg)"
				tps="$tps [$fs]($m/$run/tps-$fs.svg)"
			fi

		done

		echo "  * latencies (svg): $latencies"
		echo "  * tps (svg): $tps"

	echo ""

	done

done

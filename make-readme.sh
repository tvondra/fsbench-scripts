
for m in i5 xeon; do

	for run in `ls $m | grep run-2`; do

		echo "$m / $run"
		echo "========================="

		echo "tps: [eps]($m/$run/tps.eps) [svg]($m/$run/tps.svg)"
		echo "![$m / $run]($m/$run/tps.svg)"

		echo ""

		echo "latencies: [eps]($m/$run/latencies.eps) [svg]($m/$run/latencies.svg)"
		echo "![$m / $run]($m/$run/latencies.svg)"

		echo ""

		latencies="|latency|"
		tps="|tps|"
		header="| |"
		hline="|---|"

		for fs in btrfs btrfs-no-compress ext4 xfs zfs zfs-no-compress zfs-no-fpw; do

			if [ -f "$m/$run/tps-$fs.eps" ]; then
				header="$header $fs |"
				hline="$hline---|"
				latencies="$latencies [eps]($m/$run/latencies-$fs.eps) [svg]($m/$run/latencies-$fs.svg) |"
				tps="$tps [eps]($m/$run/tps-$fs.eps) [svg]($m/$run/tps-$fs.svg) |"
			fi

		done

		echo $header
		echo $hline
		echo $tps
		echo $latencies

	echo ""

	done

done

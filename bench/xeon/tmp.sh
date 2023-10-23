for opts in optimized; do
#for opts in none nobarrier compress nodatacow nodiscard all; do

	RESULTS=$OUTDIR/btrfs

	if [ -d "$RESULTS" ]; then
		continue
	fi

	mkdir -p $RESULTS

	sysctl -a > $RESULTS/sysctl.log 2>&1

        # recreate the LVM device
        lvm_cleanup $MAIN_DEVICE
        lvm_create $MAIN_DEVICE $RESULTS

	sudo mkfs.btrfs -f $DEVICE > $RESULTS/mkfs.log 2>&1

	lsblk > $RESULTS/lsblk.log 2>&1

	# sudo mdadm --detail /dev/md127 > $RESULTS/mdadm.log 2>&1

	sudo smartctl -a /dev/nvme0n1 > $RESULTS/smartctl.nvme0n1.log 2>&1
	#sudo smartctl -a /dev/nvme1n1 > $RESULTS/smartctl.nvme1n1.log 2>&1

	mount_opts="defaults,relatime,nobarrier,compress=lzo,nodiscard"

	sudo mount -o $mount_opts $DEVICE $MOUNT
	sudo chown postgres:postgres $MOUNT

	sudo btrfs filesystem df $MOUNT > $RESULTS/filesystem-df.log 2>&1
	sudo btrfs filesystem show $MOUNT > $RESULTS/filesystem-show.log 2>&1
	sudo btrfs filesystem usage $MOUNT > $RESULTS/filesystem-usage.log 2>&1

	mount > $RESULTS/mount.log 2>&1

	./run-one-fs.sh $RESULTS $MOUNT

	sudo umount $DEVICE

        # remove the LVM device
        lvm_cleanup $MAIN_DEVICE

done

for opts in optimized; do
#for opts in none nobarrier compress nodatacow nodiscard all; do

        RESULTS=$OUTDIR/btrfs-no-compress

        if [ -d "$RESULTS" ]; then
                continue
        fi

	mkdir -p $RESULTS

	sysctl -a > $RESULTS/sysctl.log 2>&1

        # recreate the LVM device
        lvm_cleanup $MAIN_DEVICE
        lvm_create $MAIN_DEVICE $RESULTS

        sudo mkfs.btrfs -f $DEVICE > $RESULTS/mkfs.log 2>&1

        lsblk > $RESULTS/lsblk.log 2>&1

        # sudo mdadm --detail /dev/md127 > $RESULTS/mdadm.log 2>&1

        sudo smartctl -a /dev/nvme0n1 > $RESULTS/smartctl.nvme0n1.log 2>&1
        #sudo smartctl -a /dev/nvme1n1 > $RESULTS/smartctl.nvme1n1.log 2>&1

        mount_opts="defaults,relatime,nobarrier,nodiscard"

        sudo mount -o $mount_opts $DEVICE $MOUNT
        sudo chown postgres:postgres $MOUNT

        sudo btrfs filesystem df $MOUNT > $RESULTS/filesystem-df.log 2>&1
        sudo btrfs filesystem show $MOUNT > $RESULTS/filesystem-show.log 2>&1
        sudo btrfs filesystem usage $MOUNT > $RESULTS/filesystem-usage.log 2>&1

        mount > $RESULTS/mount.log 2>&1

        ./run-one-fs.sh $RESULTS $MOUNT

        sudo umount $DEVICE

        # remove the LVM device
        lvm_cleanup $MAIN_DEVICE

done

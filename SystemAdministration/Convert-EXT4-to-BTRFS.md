The partition to be converted should not be mounted when attempting conversion.

Boot up in a live environment.

Find your partition
```bash
lsblk
```

Check the filesystem:
```bash
fsck -f /path/to/partition
```

Run the conversion utility:
```bash
btrfs-convert /path/to/partition
```

> __*NOTE:*__ If you encounter a core dump here, then you may need to build a special branch of btrfs-progs:
>
> ```bash
> git clone https://github.com/kdave/btrfs-progs.git
> cd btrfs-progs
> git fetch
> git checkout delayed_ref_fix 
> ./autogen.sh
> make
> ./btrfs-convert /path/to/partition
>```

Chroot into the system

Edit `/etc/mkinitcpio.conf`:
* Add "/usr/bin/btrfs" to the `BINARIES` list
* In the `HOOKS`, Add `btrfs` between `lvm2` and`filesystems`

Rebuild the ram image:
```bash
Arch Linux:
===========
mkinitcpio -p linux
```

Edit `/etc/fstab`:
* Change the root partition filesystem from `ext4` to `btrfs`
* Change the mount options to `noatime,compress=lzo,defaults`

Reboot to make sure it all boots up properly.

> __*NOTE:*__ Adding `compress=lzo` to the mount options will only compress new files

To compress pre-existing files:
```bash
btrfs filesystem defragment -c lzo -v -r /
```

In a test VM, this yielded a 36% reduction in space utilization.

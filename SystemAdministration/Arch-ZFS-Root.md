
# Preparation

Either customize the Arch Linux installation medium with the `archzfs` repository and `zfs-linux` or `zfs-dkms` packages. (https://wiki.archlinux.org/index.php/ZFS#Embed_the_archzfs_packages_into_an_archiso)

OR

Obtain an installation medium that already has it, such as the ALEZ installer (https://github.com/danboid/ALEZ).

> __*NOTE:*__ Of course you could use the ALEZ installer itself, but the following tutorial will afford more control over the zpool setup, the choice of encryption, as well as being an opportunity to learn how all the pieces work together. 

> __*NOTE:*__ If you decide to customize your own ISO, then check out how to add the `archzfs` repo in `pacman.conf` -- https://github.com/archzfs/archzfs/wiki#using-the-archzfs-repository

# Partitioning

Boot from your chosen installation medium.

For UEFI, create two partitions with cfdisk:

* `/dev/sda1` of at least 512MB size and of type ef00 (EFI)
* `/dev/sda2` of remaining space on disk and of type bf00 (Solaris Root)

> __*NOTE:*__ THIS TUTORIAL DOES NOT COVER GRUB2.

# Pool and Dataset Creation

Format the EFI partition, which will sit at `/boot`:

```bash
mkfs.vfat /dev/sda1
```

> __*NOTE:*__ For the next part, you could also use `/dev/disk/by-path/<path-to-partition>`

Create the pool:

```bash
zpool create -o ashift=12 -f zroot /dev/disk/by-id/<id-for-partition-partx>
```

If encryption is preferred:
```bash
zfs create -o mountpoint=none -o encryption=on -o keyformat=passphrase -o compression=lz4 zroot/local
```
Otherwise:

```bash
zfs create -o mountpoint=none zroot/local
```

Create sub-datasets for `/` and `/home`:
```bash
zfs create -o mountpoint=none zroot/local/ROOT
zfs create -o mountpoint=none zroot/local/data
zfs create -o mountpoint=/ zroot/local/ROOT/default
zfs create -o mountpoint=/home zroot/local/data/home
```

> At this time, feel free to create more datasets for different folder structures you may use.

Unmount any which may have mounted upon creation:
```bash
zfs umount -a
```

Configure a few options on the datasets:
```bash
zfs set mountpoint=none zroot
zfs set mountpoint=/ zroot/local/ROOT/default
zfs set mountpoint=/home zroot/local/data/home
zpool set bootfs=zroot/local/ROOT/default zroot
```

Export the pool:
```bash
zpool export zroot
```

# Prepare to Install

Re-import the pool, specifying a mount point of `/mnt` to get ready for pacstrap and so that all the options are now in effect.
```bash
zpool import -d /dev/disk/by-id/<id-for-partition-partx> -R /mnt zroot
```

Check that `zroot/local/<paths>` are mounted to their respective places with `df -h`

If you used encryption, you will need to load the key, entering the passphrase if prompted.
```bash
zfs load-key zroot/local
zfs mount -a
```

Mount the EFI partition for the new system:
```bash
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

Download an appropriate mirrorlist to speed up installation using your country code:
```bash
curl -o /etc/pacman.d/mirrorlist 'https://www.archlinux.org/mirrorlist/?country=<Country Code>&protocol=https'
sed -i 's/^#Server/Server/g' /etc/pacman.d/mirrorlist
```

Enable multilib:
```bash
vi /etc/pacman.conf
```
> Uncomment the `[multilib]` line and the line below it

Refresh the package databases
```bash
pacman -Syu
```

# Install and Configure

Install (This will take a bit):
```bash
pacstrap /mnt base base-devel
```

Copy the pacman.conf and mirrorlist to the newly installed system
```bash
cp /etc/pacman.conf /mnt/etc/pacman.conf
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
```

Run genfstab to put mountpoints in /etc/fstab:
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Change root into the newly installed system:
```bash
arch-chroot /mnt
```

Reload the package database and install zfs-linux package into the new system:
```bash
pacman -Syu
pacman -S zfs-linux
```

> It may be necessary, depending on when the latest `zfs-linux` was built, to downgrade to the kernel version it depends on. To do this:
> ```bash
> pacman -S wget
> wget https://archive.archlinux.org/packages/l/linux/linux-<version required>-x86_64.pkg.tar.xz
> pacman -U ./linux-<version required>-x86_64.pkg.tar.xz
> ```
> 
> Then you can install `zfs-linux` (command above)

# Make the System Bootable

Edit `mkinitcpio.conf` so that the kernel can boot to the zfs pool:
```bash
vi /etc/mkinitcpio.conf
```

* Find the 'HOOKS=' line 
* Move `'keyboard'` to be before 'filesystems'
* Put 'zfs' after 'keyboard'
* :wq (write and quit)


Generate the kernel and initramfs images using the listed HOOKS:
```bash
mkinitcpio -p linux
```

Install the bootloader:
```bash
bootctl --path=/boot install
```

Add a bootloader entry for the linux kernel with the following lines:
```bash
vi /boot/loader/entries/arch.conf
```

`/boot/loader/entries/arch.conf`:
```
title    Arch Linux
linux    vmlinuz-linux
initrd   initramfs-linux.img
options  zfs=zroot rw
```

Modify the loader.conf to point to the new bootloader entry:
```bash
vi /boot/loader/loader.conf
```
`/boot/loader/loader.conf`:
```
default arch
timeout 1
editor yes
```

> __*NOTE:*__ Once the system boots reliably, `editor yes` can be changed to `editor no`, to prevent unauthorized changes to the kernel parameters at boot time.

Update the bootloader:
```bash
bootctl --path=/boot update
```

Enable the zfs.target service to look for pools / datasets to mount at boot time:
```bash
systemctl enable zfs.target
```

Enable other services to make sure that vdevs are mounted properly:
```bash
systemctl enable zfs-import-cache 
systemctl enable zfs-import-scan 
systemctl enable zfs-mount
systemctl enable zfs-share
systemctl enable zfs-zed
```

Set the ZFS cachefile for all pools you want to mount at boot time (zroot in this case):
```bash
zpool set cachefile=/etc/zfs/zpool.cache zroot
```

Comment out the entries for the zpool from /etc/fstab:
```bash
sed -i 's/^zroot/local/# zroot/local/g' /etc/fstab
```

# Finishing up the install

Leave the `arch-chroot` environment:
```bash
exit
```

Unmount /boot and all ZFS datasets:
```bash
umount /mnt/boot
umount -a
zfs umount -a
```
> __*NOTE:*__ `umount -a` may return an error here. We just run it to be sure.

Export the pool to (system will not boot if it is not exported):
```bash
zpool export zroot
```

Reboot the system
```bash
reboot
```

# Further Customization, Adding a User, Etc...
* Time zone and localization -- https://wiki.archlinux.org/index.php/Installation_guide#Time_zone
* Network Configuration -- https://wiki.archlinux.org/index.php/Installation_guide#Network_configuration
* User Management -- https://wiki.archlinux.org/index.php/Users_and_groups#User_management
* Allowing users `sudo` privileges -- https://wiki.archlinux.org/index.php/Sudo#Example_entries

# Swap volume

ZFS does not allow to use swapfiles, but users can use a ZFS volume (ZVOL) as swap. It is important to set the ZVOL block size to match the system page size, which can be obtained by the `getconf PAGESIZE` command (default on x86_64 is 4KiB). Another option useful for keeping the system running well in low-memory situations is not caching the ZVOL data.

For example, to create an 8 GiB zfs volume:
```bash
zfs create -V 8G -b $(getconf PAGESIZE) -o logbias=throughput -o sync=always -o primarycache=metadata -o com.sun:auto-snapshot=false <pool>/swap
```

Prepare it as swap partition:
```bash
mkswap -f /dev/zvol/<pool>/swap
swapon /dev/zvol/<pool>/swap
```

To make it permanent, edit `/etc/fstab`. ZVOLs support discard, which can potentially help ZFS's block allocator and reduce fragmentation for all other datasets when/if swap is not full.

> __*NOTE:*__ If using encryption, it may be adviseable to not use the `discard` mount option.

Add a line to `/etc/fstab`:
```
/dev/zvol/<pool>/swap none swap discard 0 0
```

# Snapshots

One very useful feature of ZFS is snapshots. To make use of snapshots, one could simply issue the following command:
```bash
zfs snapshot zroot/local/ROOT/default@now
```

To see this snapshot:
```bash
zfs list -t snapshot
```

Options for managing snapshots:
* There are programs in the AUR which can automate the taking of snapshots. One is called Sanoid ()
* There are also some hooks which have been made for filesystems like btrfs to take a snapshot before and after a system update / software change. Perhaps soon, there will be some which support ZFS. Or one could make their own pacman hook.

For the automated management of snapshots, Sanoid is recommended:
```bash
yay -S sanoid
```

> __*NOTE:*__ If you do not have the Arch Linux AUR helper, `yay`, installed, then you may install it like so:
> 
> ```bash
> git clone https://aur.archlinux.org/yay.git
> cd yay
> sudo pacman -si PKGBUILD
> ```
> Accept installation of dependencies (Go at the time of this writing).

Documentation on how to configure sanoid is at https://github.com/jimsalterjrs/sanoid/

A way to manage `cron` jobs will be required, so:
```bash
sudo pacman -S cronie
```

Create the `cron` job:
```bash
sudo crontab -e -u root
```
Adding the entry:
```bash
* * * * * TZ=UTC /usr/bin/sanoid --cron
```

Edit `/etc/sanoid/sanoid.conf`:
```bash
[zroot/local/ROOT]
	use_template = production
  recursive = yes
[zroot/local/data]
	use_template = production
	recursive = yes

#############################
# templates below this line #
#############################

[template_production]
  frequently = 0
  hourly = 36
  daily = 30
  monthly = 3
  yearly = 2
  autosnap = yes
  autoprune = yes
```

Enable and start the `cronie` service
```bash
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
```

After a bit of time, the autogenerated snapshots will begin to be seen with:
```bash
zfs list -t snapshot
```

# Rolling Back to a Snapshot

In the course of maintaining the system, it may become necessary to rollback to a snapshot. For non-root datasets, this can be done while the system is running, by unmountig the dataset, performing the rollback operation, and then remounting. For a root dataset, the operation will need to be done in a rescue environment. 

To do this, boot up on the installation media.

Import the pool:
```bash
zpool import -R /mnt zroot
```

If you opted for encryption:
```bash
zfs load-key zroot/local
```

A list of snapshots can be obtained with:
```bash
zfs list -t snapshot
```

Choose the one you want to restore to and run:
```bash
zfs rollback zroot/local/ROOT/default@<snapshot name>
```

You may get a notice that doing this requires deletion of subsequent snapshots. Either select a later snapshot or add the `-r` switch to recursively rollback the snapshot.
```bash
zfs rollback -r zroot/local/ROOT/default@<snapshot name>
```

> If this rollback affects a recently installed kernel, then you will need to rebuild your initramfs. To do that we'll need to chroot into the system and run `mkinitcpio`.
> 
> Import your pool, mounting it relative to `/mnt`, just as during the installation process.
> 
> Mount the ZFS datasets
> ```bash
> zfs mount -a
> ```
> 
> Mount `/boot`:
> ```bash
> mount /dev/sda1 /mnt/boot
> ```
> 
> `arch-chroot` into the system:
> ```bash
> arch-chroot /mnt
> ```
> 
> Rebuild the ram image:
> ```bash
> mkinitcpio -p linux
> ```
> 
> Exit the chroot environment:
> ```bash
> exit
> ```

Unmount all mount points:
```bash
umount -a
zfs umount -a
```

Export the pool:
```bash
zpool export zroot
```

Reboot and remove installation media:
```bash
reboot
```

# Further Reading
Arch Linux ZFS Wiki page -- https://wiki.archlinux.org/index.php/ZFS

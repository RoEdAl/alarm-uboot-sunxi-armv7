# Arch Linux ARM - U-Boot bootloaders for Allwinner-based boards [32-bit]

## Supported boards:

 Board | U-Boot package | WiFi package(s) | Bootlog
:-----:|:--------------:|:---------------:|:-------:
[OrangePi Zero](http://www.orangepi.org/orangepizero/)|`uboot-orangepi-zero`|[`xradio-dkms`](//github.com/RoEdAl/alarm-wifi-dkms/tree/master/xradio-dkms), [`xradio-firmware`](//github.com/RoEdAl/alarm-wifi-dkms/tree/master/xradio-firmware)|[here](bootlog/orangepi-zero.log)
[OrangePi One](http://www.orangepi.org/orangepione/)|`uboot-orangepi-one`|N/A|[here](bootlog/orangepi-one.log)
[OrangePi R1](http://www.orangepi.org/OrangePiR1)|`uboot-orangepi-r1`|[TODO]|[here](bootlog/orangepi-r1.log)
[NanoPi Neo](http://www.friendlyarm.com/index.php?route=product/product&product_id=132)|`uboot-nanopi-neo`|N/A|[here](bootlog/nanopi-neo.log)
[A10 oLinuXino Lime](http://www.olimex.com/Products/OLinuXino/A10/A10-OLinuXino-LIME-n4GB/open-source-hardware)|`uboot-a10-olinuxino-lime-dt`|N/A|[here](bootlog/a10-olinuxino-lime.log)
[A20 oLinuXino Lime](http://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-LIME/open-source-hardware)|`uboot-a20-olinuxino-lime-dt`|N/A|[here](bootlog/a20-olinuxino-lime.log)
[BananaPi M2 Zero](http://www.banana-pi.org/bpi-zero.html)|`uboot-bananapi-m2-zero`|[`ap6212-wifi-firmware`](//github.com/RoEdAl/alarm-wifi-dkms/tree/master/ap6212-wifi-firmware)|[here](bootlog/bananapi-m2-zero.log)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](//github.com/armbian/sunxi-DT-overlays).
See [this](//github.com/RoEdAl/alarm-sunxi-dt-overlays-armv7) repository for more info.

All bootloaders requires Linux kernel version >=*4.15.0*.

---

## SD Card preparation

### Classic way

Replace **sdX** in the following instructions with the device name for the SD card as it appears on your computer.

1. Zero the beginning of the SD card:
   ```
   dd if=/dev/zero of=/dev/sdX bs=1M count=8
   ```
1. Start fdisk to partition the SD card:
   ```
   fdisk /dev/sdX
   ```
1. At the fdisk prompt, delete old partitions and create a new one:
   1. Type **o**. This will clear out any partitions on the drive.
   1. Type **p** to list partitions. There should be no partitions left.
   1. Now type **n**, then **p** for primary, **1** for the first partition on the drive, **2048** for the first sector,
      and then press **ENTER** to accept the default last sector.
   1. Write the partition table and exit by typing **w**.
1. Create the ext4 filesystem:
   ```
   mkfs.ext4 /dev/sdX1
   ```
1. Mount the filesystem:
   ```
   mkdir root
   mount /dev/sdX1 root
   ```
1. Download and extract the root filesystem:
   ```
   wget http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz
   bsdtar -xpf ArchLinuxARM-armv7-latest.tar.gz -C root
   sync
   ```
1. Download download appropriate U-Boot package from [releases](//github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases).
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases/download/vyyy.mm-r/uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz
   ```
1. Extract required U-Boot binary and compiled script from package:
   ```
   bsdtar -xf uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz boot/u-boot-sunxi-with-spl.bin boot/boot.scr
   ```
   For *BananaPi P2 Zero* board you must also extract DTB:
   ```
   bsdtar -xf uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz boot/dtbs-extra
   ```
1. Install the U-Boot bootloader:
   ```
   mv boot/boot.scr root/boot
   [ -d boot/dtbs-extra ] && mv boot/dtbs-extra root/boot
   umount root
   dd if=boot/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=1024 seek=8
   ```
1. Insert the micro SD card into the board, connect ethernet, and apply 5V power.
1. Use the serial console or SSH to the IP address given to the board by your router.
   - Login as the default user *alarm* with the password *alarm*.
   - The default *root* password is *root*.
1. After logging into the system initialize the pacman keyring and populate the Arch Linux ARM [package signing](//archlinuxarm.org/about/package-signing) keys:
   ```
   pacman-key --init
   pacman-key --populate archlinuxarm
   ```
1. Install *U-Boot* package:
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases/download/vx-y/uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz
   pacman -U uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz
   ```
### Separate boot (ext4) and root (f2fs) partitions

Replace **sdX** in the following instructions with the device name for the SD card as it appears on your computer.

1. Zero the beginning of the SD card:
   ```
   dd if=/dev/zero of=/dev/sdX bs=1M count=8
   ```
1. Start fdisk to partition the SD card:
   ```
   fdisk /dev/sdX
   ```
1. At the fdisk prompt, delete old partitions and create a new one:
   1. Type **o**. This will clear out any partitions on the drive.
   1. Type **p** to list partitions. There should be no partitions left.
   1. Type **n**, then **p** for primary, **1** for the first partition on the drive, **2048** for the first sector, and then type **+256M** for the last sector.
   1. Now type **n**, then **p** for primary, **2** for the first partition on the drive and then press **ENTER** twice to accept the default first and last sector.
   1. Write the partition table and exit by typing **w**.
1. Create the boot filesystem:
   ```
   mkfs.ext4 /dev/sdX1
   ```
1. Mount the boot filesystem:
   ```
   mkdir boot
   mount /dev/sdX1 boot
   ```
1. Create the root filesystem:
   ```
   mkfs.f2fs /dev/sdX2
   ```
1. Mount the boot filesystem:
   ```
   mkdir root
   mount /dev/sdX2 root
   ```
1. Download and extract the root filesystem:
   ```
   wget http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz
   bsdtar -xpf ArchLinuxARM-armv7-latest.tar.gz -C root
   sync
   ```
1. Move boot files to the first partition:
   ```
   mv root/boot/* boot
   ```
1. Download download appropriate U-Boot package from [releases](//github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases).
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases/download/vyyy.mm-r/uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz
   ```
1. Extract required U-Boot binary and compiled script from package:
   ```
   bsdtar -xf uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz boot/u-boot-sunxi-with-spl.bin boot/boot.scr
   ```
   For *BananaPi P2 Zero* board you must also extract DTB:
   ```
   bsdtar -xf uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz boot/dtbs-extra
   ```
1. Install the U-Boot bootloader:
   ```
   dd if=boot/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=1024 seek=8
   sync
   rm boot/u-boot-sunxi-with-spl.bin
   ```
1. Inform bootloader that root filestystem is on second partition: 
   ```
   touch boot/root-is-on-2nd-partition
   ```
1. Add `fstab` entry to mount boot partition:
   ```
   echo '/dev/mmcblk0p1 /boot ext4 defaults 0 2' >> root/etc/fstab
   ```
1. Optionally configure *systemd-journald* service to store log data only in memory:
   ```
   mkdir -p root/usr/lib/systemd/journald.conf.d
   echo '[Journal]' > root/usr/lib/systemd/journald.conf.d/storage-volatile.conf
   echo 'Storage=volatile' >> root/usr/lib/systemd/journald.conf.d/storage-volatile.conf
   ```
1. Umount the partitions:
   ```
   umount root boot
   ```
1. Insert the micro SD card into the board, connect ethernet, and apply 5V power.
1. Use the serial console or SSH to the IP address given to the board by your router.
   - Login as the default user *alarm* with the password *alarm*.
   - The default *root* password is *root*.
1. After logging into the system initialize the pacman keyring and populate the Arch Linux ARM [package signing](//archlinuxarm.org/about/package-signing) keys:
   ```
   pacman-key --init
   pacman-key --populate archlinuxarm
   ```
1. Install *U-Boot* package:
   ```
   wget https://github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases/download/vx-y/uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz
   pacman -U uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz
   ```
1. Install `f2fs-tools` package and rebuild *initcpio*:
   ```
   pacman -Syu f2fs-tools
   mkinitcpio -p linux-armv7
   ```
## Build issues:

* Due to `git-apply` behaviour packages must be built **outside** a git repository - 
  specify **BUILDDIR** in [`~/.makepkg.conf`](//www.archlinux.org/pacman/makepkg.conf.5.html) file.

# Arch Linux ARM - U-Boot Bootloaders for Allwinner based boards

## Supported boards:

* [OrangePi Zero](http://www.orangepi.org/orangepizero/) - `uboot-orangepi-zero` (optionally uses tweaked DTB from `orangepi-dtbs`)
* [NanoPi Neo](http://www.friendlyarm.com/index.php?route=product/product&product_id=132) - `uboot-nanopi-neo` (optionally uses tweaked DTB from `nanopi-dtbs`)
* [A10 oLinuXino Lime](http://www.olimex.com/Products/OLinuXino/A10/A10-OLinuXino-LIME-n4GB/open-source-hardware) - `uboot-a10-olinuxino-lime-dt` (optionally uses tweaked DTB from `olinuxino-lime-dtbs`)
* [A20 oLinuXino Lime](http://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-LIME/open-source-hardware) - `uboot-a20-olinuxino-lime-dt` (optionally uses tweaked DTB from `olinuxino-lime-dtbs`)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](http://github.com/armbian/sunxi-DT-overlays).
See [this](http://github.com/RoEdAl/alarm-sunxi-dt-overlays-armv7) repository for more info.

All bootloaders requires Linux kernel version >=*4.15.0*.

---

## SD Card preparation

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
1. Install the U-Boot bootloader:
   ```
   dd if=boot/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=1024 seek=8
   cp boot/boot.scr root/boot
   umount root
   sync
   ```
1. Insert the micro SD card into the board, connect ethernet, and apply 5V power.
1. Use the serial console or SSH to the IP address given to the board by your router.
   - Login as the default user *alarm* with the password *alarm*.
   - The default *root* password is *root*.
1. After logging into the system install U-Boot and DTBS packages:
   ```
   pacman -U pacman -U https://github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases/download/vx-y/uboot-<your board name>-yyyy.mm-r-armv7h.pkg.tar.xz https://github.com/RoEdAl/alarm-uboot-sunxi-armv7/releases/download/vx-y/<brand-name>-dtbs-x.yy-r-armv7h.pkg.tar.xz
   ```
---

Build issues:

* Due to `git-apply` behaviour packages must be built **outside** a git repository - 
  specify **BUILDDIR** in [`~/.makepkg.conf`](http://www.archlinux.org/pacman/makepkg.conf.5.html) file.

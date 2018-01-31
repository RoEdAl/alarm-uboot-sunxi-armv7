# Arch Linux ARM - U-Boot Bootloaders for Allwinner based boards

## Supported devices:

* [OrangePi Zero](http://www.orangepi.org/orangepizero/) - `uboot-orangepi-zero` (requires additional DTB from `orangepi-dtbs`)
* [NanoPi Neo](http://www.friendlyarm.com/index.php?route=product/product&product_id=132) - `uboot-nanopi-neo` (requires additional DTB from `nanopi-dtbs`)
* [A10 oLinuXino Lime](https://www.olimex.com/Products/OLinuXino/A10/A10-OLinuXino-LIME-n4GB/open-source-hardware) - `uboot-a10-olinuxino-lime-dt` (requires additional DTB from `olinuxino-lime-dtbs`)

Theese bootloaders are ready to apply additional DT overlays from [Armbian's Device Tree overlays for sunxi devices](http://github.com/armbian/sunxi-DT-overlays).
See [this](http://github.com/RoEdAl/alarm-sunxi-dt-overlays-armv7) repository for more info.

---

All bootloaders requires Linux kernel version *4.15.0* or above.

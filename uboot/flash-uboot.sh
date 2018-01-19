#!/bin/bash

dd if=/boot/u-boot-sunxi-with-spl.bin of=/dev/mmcblk0 bs=1024 seek=8 conv=notrunc status=noxfer

mansa-RK3288

How to build it
===============

  $ make mansa_rk3288_defconfig

Then you can edit the build options using

  $ make menuconfig

Compile all and build rootfs image:

  $ make

Result of the build
-------------------

After building, you should get a tree like this:

  output/images/
  ├── rk3288-mansa.dtb
  ├── rootfs.ext2
  ├── rootfs.ext4 -> rootfs.ext2
  ├── sdcard.img
  ├── u-boot-dtb.img
  ├── u-boot-spl-nodtb.bin
  ├── u-boot-spl-nodtb.img
  └── uImage

Prepare your SDCard
===================

Buildroot generates a ready-to-use SD card image that you can flash directly to
the card. The image will be in output/images/sdcard.img.
You can write this image directly to an SD card device (i.e. /dev/xxx):

  $ dd if=output/images/sdcard.img of=/dev/xxx

Finally, you can insert the SD card to the mansa RK3288 board and boot it.

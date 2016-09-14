#!/bin/sh

# Can be used to customize existing files, remove unneeded files to save
# space, add new files that are generated dynamically (build date, etc.)

set -e


echo ">>>   Post-build script start"

BOARD_DIR="$(dirname $0)"

# install uboot-spl and uboot.img
if [ ! -f "$BINARIES_DIR/u-boot-spl-nodtb.bin" ]; then
echo ">>>   Install prebuilt u-boot-spl-nodtb.bin"
install -m 0644 -D $BOARD_DIR/bin/u-boot-spl-nodtb.bin $BINARIES_DIR/u-boot-spl-nodtb.bin
fi


if [ ! -f "$BINARIES_DIR/u-boot-dtb.bin" ]; then
echo ">>>   Install prebuilt u-boot-dtb.bin"
install -m 0644 -D $BOARD_DIR/bin/u-boot-dtb.bin $BINARIES_DIR/u-boot-dtb.bin
fi

# install kernel img and dtb
if [ ! -f "$TARGET_DIR/boot/uImage" ]; then
echo ">>>   Install prebuilt uImage"
install -m 0644 -D $BOARD_DIR/bin/uImage $TARGET_DIR/boot/uImage
fi


if [ ! -f "$TARGET_DIR/boot/rk3288-mansa.dtb" ]; then
echo ">>>   Install prebuilt rk3288-mansa.dtb"
install -m 0644 -D $BOARD_DIR/bin/rk3288-mansa.dtb $TARGET_DIR/boot/rk3288-mansa.dtb
fi



install -m 0644 -D $BOARD_DIR/extlinux.conf $TARGET_DIR/boot/extlinux/extlinux.conf



# Generate a file identifying the build (git commit and build date)
echo $(git describe) $(date +%Y-%m-%d-%H:%M:%S) > $TARGET_DIR/etc/build-id

echo ">>>   Post-build script done"

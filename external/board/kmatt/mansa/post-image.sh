#!/bin/sh


set -e


echo ">>>   Post-image script start"



MKIMAGE=$HOST_DIR/usr/bin/mkimage

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/sd-image.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

$MKIMAGE -n rk3288 -T rksd -d $BINARIES_DIR/u-boot-spl-nodtb.bin $BINARIES_DIR/uboot.img
cat $BINARIES_DIR/u-boot-dtb.bin >> $BINARIES_DIR/uboot.img

rm -rf "${GENIMAGE_TMP}"

genimage							\
	--rootpath "${TARGET_DIR}"		\
	--tmppath "${GENIMAGE_TMP}"		\
	--inputpath "${BINARIES_DIR}"	\
	--outputpath "${BINARIES_DIR}"	\
	--config "${GENIMAGE_CFG}"

echo ">>>   Post-image script done"

exit $?

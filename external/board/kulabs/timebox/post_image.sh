#!/bin/sh

# Extract the root filesystem to do NFS booting
# Generate a final firmware image
# Start the fashing process

set -e

IMAGES_DIR=$1


cd $1

# build android style boot.img ?
# /path/to/mkbootimg


# pack all imgage into kulabs format
# /path/to/pack -c /path/to/image.conf -o /path/to/kulab_boardname.img

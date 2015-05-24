#!/bin/sh

# Can be used to customize existing files, remove unneeded files to save
# space, add new files that are generated dynamically (build date, etc.)


TARGET_DIR=$1
BOARD_DIR=board/kulabs/timebox

# Generate a file identifying the build (git commit and build date)
echo $(git describe) $(date +%Y-%M-%d-%H:%m:%S) > $TARGET_DIR/etc/build-id

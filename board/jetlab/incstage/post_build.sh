#!/bin/sh

echo ">>>   Post-build script start"

TARGETDIR="$1"
set -x


# make sure ssh keys aren't readable by anybody except owner
chmod go-rwx $TARGETDIR/etc/ssh_*_key

set +x
echo ">>>   Post-build script done"

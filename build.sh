#!/bin/sh

set -e

[ $# != 2 ] && echo "build.sh <theme_path> <version>" && exit 1

version=$2
cd $1
find usr/share/icons -name icon-theme.cache -exec rm {} \;
sed -i "s/Version: .*/Version: $version-1/" DEBIAN/control
size=$(du -sk usr/ | cut -f1)
sed -i "s/Installed-Size: .*/Installed-Size: $size/" DEBIAN/control
find usr -type f -exec md5sum {} \; > DEBIAN/md5sums

dpkg-deb --build --root-owner-group . ../$(basename $1)_$version-1_all.deb
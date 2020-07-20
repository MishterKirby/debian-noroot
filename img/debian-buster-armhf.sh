#!/bin/sh

DIR=dist-debian-buster-armhf/img
CHROOT="qemu-arm-static $DIR/lib/ld-linux-arm.so.1 --library-path $DIR/lib/arm-linux-gnu $DIR/usr/sbin/chroot $DIR"
sudo rm -r -f $DIR
mkdir -p $DIR
APT_CACHER=
[ -e /etc/init.d/apt-cacher ] && APT_CACHER=/localhost:3142
[ -e /etc/init.d/apt-cacher-ng ] && APT_CACHER=/localhost:3142
sudo qemu-debootstrap --arch=armhf --verbose \
        --components=main,contrib,non-free \
        buster $DIR http:/$APT_CACHER/ftp.de.debian.org/debian/ \
&& cat sources-jessie.list | sed 's/jessie/buster/g' | sudo tee $DIR/etc/apt/sources.list > /dev/null \
&& sudo $CHROOT apt-get update \
&& sudo $CHROOT apt-get install -y `cat img-debian-buster.pkg` \
&& sudo ./prepare-img-proot.sh --xz $DIR armhf

#!/bin/bash
loopdev=/dev/loop111
function mnt(){
    echo "Creating mount points"
    mkdir boot
    mkdir rootfs
    echo the image is $2
    echo "Umounting everything that could be mounted"
    sudo umount * > /dev/null 2>&1
    sudo losetup -d $loopdev > /dev/null 2>&1
    sudo partprobe $loopdev
    echo "Associating loopback device to $2"
    sudo losetup $loopdev $2
    echo "Mounting boot..."
    sudo mount ${loopdev}p1 boot
    echo "Mounting rootfs"
    sudo mount ${loopdev}p2 rootfs
}
function umnt(){
    echo the image is $2
    echo "Umounting everything that could be mounted"
    sudo umount * > /dev/null 2>&1
    sudo losetup -d $loopdev > /dev/null 2>&1
    echo "Deleting folders"
    rm -rf boot
    rm -rf rootfs
}

if [ "$1" == "-m" ] && [ -n "$2" ] ;
then
    mnt $1 $2
elif [ "$1" == "-u" ] && [ -n "$2" ];
then
    umnt $1 $2
else
    echo "For example: rpi_mount.sh -m disk.img"
    echo ""
    echo 1st parameter : ${1}
    echo 2nd parameter : ${2}
fi
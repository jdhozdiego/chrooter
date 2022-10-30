#!/bin/bash
# Mount Kernel Virtual File Systems
TARGETDIR="/usr/local/chroot"

mkdir $TARGETDIR 2>/dev/null
mkdir $TARGETDIR/dev/ 2>/dev/null

#Required commands to execute before entering chroot first time
mkdir $TARGETDIR/proc/ 2>/dev/null
mkdir $TARGETDIR/sys/ 2>/dev/null
mkdir $TARGETDIR/dev/null 2>/dev/null
mkdir $TARGETDIR/etc 2>/dev/null

mount -t proc proc $TARGETDIR/proc
mount -t sysfs sysfs $TARGETDIR/sys
mount -t devtmpfs devtmpfs $TARGETDIR/dev
mount -t tmpfs tmpfs $TARGETDIR/dev/shm
mount -t devpts devpts $TARGETDIR/dev/pts

# Copy /etc/hosts
/bin/cp -f /etc/hosts $TARGETDIR/etc/

# Copy /etc/resolv.conf
/bin/cp -f /etc/resolv.conf $TARGETDIR/etc/resolv.conf

# Link /etc/mtab
chroot $TARGETDIR rm /etc/mtab 2> /dev/null
#chroot $TARGETDIR /usr/bin/ln -s /proc/mounts /etc/mtab
/usr/bin/ln -s $TARGETDIR/proc/mounts $TARGETDIR/etc/mtab

rm $TARGETDIR/dev/urandom
rm  $TARGETDIR/dev/null
rm $TARGETDIR/dev/zero
rm $TARGETDIR/dev/tty 

mknod $TARGETDIR/dev/urandom c 1 9
mknod -m 666 $TARGETDIR/dev/null    c 1 3
mknod -m 666 $TARGETDIR/dev/zero    c 1 5
mknod -m 666 $TARGETDIR/dev/tty     c 5 0

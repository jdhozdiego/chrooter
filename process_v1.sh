#!/bin/bash

CARPETA="chroot"

mkdir /usr/local/$CARPETA

#archivo de comandos a leer
filename=comando.txt
declare -a myArray
myArray=(`cat "$filename"`)

for (( i = 0 ; i < 25 ; i++))
do
echo "Element [$i]: ${myArray[$i]}"

#script.sh se encarga de crear todas las carpetas, copiar librerias, etc para que el comando deseado funcione
bash script.sh `which "${myArray[$i]}"` /usr/local/$CARPETA/ >> log.txt
done

#se crean carpetas para resolver problema  /dev/null/
 mkdir /usr/local/$CARPETA/proc
 mkdir /usr/local/$CARPETA/sys
 mkdir /usr/local/$CARPETA/dev
 mkdir /usr/local/$CARPETA/dev/shm
 mkdir /usr/local/$CARPETA/dev/pts
 mkdir /usr/local/$CARPETA/etc

#chmod 777 preparacion_chroot.sh
#bash preparacion_chroot.sh >>log.txt

#Comandos que hay que hacer siempre antes de entrar al chroot por primera vez
#mount -t proc proc /usr/local/chroot/proc/
#mount -t sysfs sys /usr/local/chroot/sys/
#mount -o bind /dev /usr/local/chroot/dev/

# Mount Kernel Virtual File Systems
TARGETDIR="/usr/local/"$CARPETA
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
chroot $TARGETDIR ln -s /proc/mounts /etc/mtab


# se crean carpetas necesarias, se copian librerias y llaves
mkdir /usr/local/$CARPETA/etc/ssh
cp /etc/passwd usr/local/$CARPETA/etc/ssh/
cp -f /etc/ssh/ssh_config /usr/local/$CARPETA/etc/ssh/
cp -f /etc/ssh/* /usr/local/$CARPETA/etc/ssh/
mkdir /usr/local/$CARPETA/var
mkdir /usr/local/$CARPETA/var/run
cp /var/run/sshd.pid /usr/local/$CARPETA/var/run/
cp -r /var/run/sshd /usr/local/$CARPETA/var/run/
cp /etc/passwd /usr/local/$CARPETA/etc/
cp -r /etc/shadow /usr/local/$CARPETA/etc/
cp /etc/nsswitch.conf /usr/local/$CARPETA/etc
cp /lib/i386-linux-gnu/*nss* /usr/local/$CARPETA/lib/i386-linux-gnu/
cp -r /usr/lib/sudo /usr/local/$CARPETA/usr/lib/
cp /lib/i386-linux-gnu/*pam* /usr/local/$CARPETA/usr/lib/i386-linux-gnu/
cp -r /etc/ld.so* /usr/local/$CARPETA/etc
cp -r /lib/i386-linux-gnu/i686/cmov/*nss* /usr/local/$CARPETA/lib/i386-linux-gnu/i686/cmov/
cp -r /etc/pam* /usr/local/$CARPETA/etc/
cp -r /lib/security /usr/local/$CARPETA/lib/
cp -r /lib/i386-linux-gnu/security /usr/local/$CARPETA/lib/i386-linux-gnu/
cp -r /lib/i386-linux-gnu/*libcap* /usr/local/$CARPETA/lib/i386-linux-gnu/
cp -r /lib/i386-linux-gnu/i686/cmov/*librt* /usr/local/$CARPETA/lib/i386-linux-gnu/i686/cmov/
cp /etc/sudoers /usr/local/$CARPETA/etc/
mkdir /usr/local/$CARPETA/home
cp -r /home/pi /usr/local/$CARPETA/home/
cp /etc/login.defs /usr/local/$CARPETA/etc/
cp -r /usr/lib/locale /usr/local/$CARPETA/usr/lib/
cp /var/run/utmp /usr/local/$CARPETA/var/run/
cp /etc/group /usr/local/$CARPETA/etc/
cp -r /etc/security /usr/local/$CARPETA/etc/
cp -r /etc/environment /usr/local/$CARPETA/etc/
cp -r /etc/motd /usr/local/$CARPETA/etc/
cp -r /etc/securetty /usr/local/$CARPETA/etc/


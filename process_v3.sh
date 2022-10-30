#!/bin/bash

#Find static and dynamic libraries
# strings -a /usr/bin/cec-client | grep '\.so.' | xargs -I {} find_library.sh {}


#List the path of the libraries (all)
#/sbin/ldconfig -N -v $(sed 's/:/ /' <<< $LD_LIBRARY_PATH)


CARPETA="chroot"

mkdir /usr/local/$CARPETA

#command filename to read
filename=comando.txt

declare -a myArray
myArray=(`cat "$filename"`)
lineas=(`wc -l "$filename"`)

for (( i = 0 ; i < $lineas  ; i++))
do
	echo "Element [$i]: ${myArray[$i]}"

	#script.sh reads all folders, copy libraries, etc. so that the command works (but it is not perfect)
	bash script.sh `which "${myArray[$i]}"` /usr/local/$CARPETA/ >> log.txt
        comando=(`which "${myArray[$i]}"`)

        #`strings -a $comando | grep '\.so.' | xargs -I {} ./find_library.sh {} 2>/dev/null` 
        #I set that into a variable
	#Then, one by one I cp --parents $elemento /usr/local/$CARPETA


	cp --parents `strings -a $comando | grep '\.so.' | xargs -I {} ./find_library.sh {} 2>/dev/null` /usr/local/$CARPETA/  2>/dev/null
	cp --parents `strings -a $comando | grep '\.so.' | xargs -I {} ./find_library.sh {} 2>/dev/null`.* /usr/local/$CARPETA/ 2>/dev/null
done


###--------------------- Now, the script looks for all other related libraries from the already included libraries ---------------

find /usr/local/$CARPETA | grep '\.so\.' | sed -e "s#/usr/local/$CARPETA##g" > lista_lib.txt



### TODO: Make an automatic list of the commands that need strace annalysis.
# A strace analysis looks for dynamic linked files, libraries and other dependences in runtime
# The script executes these commands to find out these dependences. The commands required strace so far are:
# ssh client
# sshd server
# whoami
# passwd
# These commands include the required libraries to guarantee privilege separation in SSH

strace ssh  2>&1 | grep -e open -e access | cut -f 2 -d '"' >>lista_lib.txt
strace /usr/sbin/sshd  2>&1 | grep -e open -e access | cut -f 2 -d '"' >>lista_lib.txt
strace whoami 2>&1 | grep -e open -e access | cut -f 2 -d '"' >>lista_lib.txt
strace passwd 2>&1 | grep -e open -e access | cut -f 2 -d '"' >>lista_lib.txt

cat lista_lib.txt | xargs -I{} cp --parent {} /usr/local/$CARPETA/

#exit

lista_lib=lista_lib.txt
declare -a myArray2
myArray2=(`cat "$lista_lib"`)
lineas2=(`wc -l "$lista_lib"`)
lineas2_comp=0
echo $lineas2



while [ $lineas2 -ne $lineas2_comp ]; do

	lineas2=$lineas2_comp
	for (( i = 0 ; i < $lineas2  ; i++))
	do
		echo "Element [$i]: ${myArray2[$i]}"
                #cp --parents ${myArray2[$i]} /usr/local/$CARPETA/
		#script.sh se encarga de crear todas las carpetas, copiar librerias, etc para que el comando deseado funcione
		bash script.sh ${myArray2[$i]} /usr/local/$CARPETA/ "lib" >> log2.txt
	done
	find /usr/local/$CARPETA | grep '\.so\.' | sed -e "s#/usr/local/$CARPETA##g" > lista_lib.txt
	lineas2_comp=(`wc -l "$lista_lib"`)
done

#exit

#Some further folders are needed  /dev/null/
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

#link bin

/usr/bin/ln -s /usr/bin $TARGETDIR/bin

# Copy /etc/hosts
/bin/cp -f /etc/hosts $TARGETDIR/etc/

# Copy /etc/resolv.conf
/bin/cp -f /etc/resolv.conf $TARGETDIR/etc/resolv.conf


exit


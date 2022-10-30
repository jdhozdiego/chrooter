#!/bin/bash 
# Author : Hemanth.HM
# Email : hemanth[dot]hm[at]gmail[dot]com
# License : GNU GPLv3
#

function useage()
{
    cat << EOU
Useage: bash $0 <path to the binary> <path to copy the dependencies> <lib?>
EOU
exit 1
}

#Validate the inputs
[[ $# < 2 ]] && useage

#Check if the paths are vaild
[[ ! -e $1 ]] && echo "Not a vaild input $1" && exit 1 
[[ -d $2 ]] || echo "No such directory $2 creating..."&& mkdir -p "$2"

#Get the library dependencies
echo "Collecting the shared library dependencies for $1..."
deps=$(ldd $1 | awk 'BEGIN{ORS=" "}$1\
~/^\//{print $1}$3~/^\//{print $3}'\
 | sed 's/,$/\n/')
echo "Copying the dependencies to $2"

#Copy the deps
for dep in $deps
do
    VAR="$2$dep"
    echo "Copying $dep to "$(dirname "${VAR}")
    mkdir -p $(dirname "${VAR}")
    cp  "$dep" $(dirname "${VAR}")
done

#$1 ej: /bin/grep
#$2 ej: /usr/local/chroot
#resultado: cp /bin/grep /usr/local/root/bin/grep
if [[ "$3" != "lib" ]]
then
	VAR="$2$1"
	echo "Copying $1 to "$(dirname "${VAR}")
	mkdir -p $(dirname "${VAR}")
	cp $1 $2$1

	echo "Done!"
fi

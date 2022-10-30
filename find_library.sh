#!/bin/bash
#IFS=:


/sbin/ldconfig -v | grep '^/' | grep ':$' | cut -f 1 -d ':' 1>folders.txt 2>/dev/null

#List of commands to process
filename=folders.txt

declare -a myArray
myArray=(`cat "$filename"`)
lineas=(`wc -l "$filename"`)

for (( i = 0 ; i < $lineas  ; i++))
do
    if [ -f "${myArray[$i]}"/$1 ]; then
        echo "${myArray[$i]}"/$1
    fi

done

exit

for p in ; do
echo ${p}
    if [ -e ${p}/$1 ]; then
        
        echo ${p}/$1
    fi
done

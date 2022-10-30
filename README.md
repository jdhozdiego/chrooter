# CHROOTER
This project elaborates a tool to create chroot folders in which we can run the programs included in a text file. The CHROOTER finds all dependences and libraries semi-automatically. The repository contains the following files:
 - [[chroot_preparation.sh](https://github.com/jdhozdiego/chrooter/blob/main/chroot_preparation.sh "chroot_preparation.sh")] This file prepares the selected folder in the variable $TARGETDIR initialized in the file to contain a working CHROOT
 - [comando.txt](https://github.com/jdhozdiego/chrooter/blob/main/comando.txt "comando.txt") This is the list of commands to include in the CHROOT
 - [[find_library.sh](https://github.com/jdhozdiego/chrooter/blob/main/find_library.sh "find_library.sh")] This subscript is launched to track the library dependences
 - [[process_v3.sh](https://github.com/jdhozdiego/chrooter/blob/main/process_v3.sh "process_v3.sh")] This script is launched after chroot_preparation.sh to process all commands, libraries and populate the CHROOT folder
 - [[script.sh](https://github.com/jdhozdiego/chrooter/blob/main/script.sh "script.sh")]This tool is used to compute some dependencies.
## Usage
First, the variable $TARGETDIR should be configured in chroot_preparation.sh and in process_v3.sh Then, chroot_preparation.sh is executed After this, process_v3.sh is executed This should produce a working instance of CHROOT with the commands included in the comando.txt 
list.
The tool currently provides privilege separation inside the chroot. It includes all required libraries for that by default by stracing SSH, SSHD, passwd and whoami during the execution of process_v3.sh

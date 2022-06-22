#!/usr/bin/bash

if [ $# -ne 1 ]; then
	exit 1
fi

if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

${Sudo} mkdir -v -m 777 -p /mnt/nfs

${Sudo} mount -t nfs -o nolock $1:/home/zcq/ARM_nfs /mnt/nfs

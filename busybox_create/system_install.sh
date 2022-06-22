#! /bin/bash

source create_busybox_function.sh

func_apt -d -g

func_apt -i sudo vim kmod net-tools ethtool language-pack-en
func_apt -i rsyslog htop rsyslog htop iputils-ping ifupdown
func_apt -i language-pack-zh-hans bash openssh-server vsftpd
func_apt -i language-pack-zh-hans-base nfs-kernel-server rpcbind
func_apt -i mplayer gcc g++ make xfsprogs ssh mtd-utils
func_apt -i language-pack-en-base
func_apt -i fonts-droid-fallback ttf-wqy-zenhei ttf-wqy-microhei
func_apt -i fonts-arphic-ukai fonts-arphic-uming
func_apt -i language-pack-gnome-zh-hans language-pack-gnome-zh-hans-base

func_apt -d -g -a 

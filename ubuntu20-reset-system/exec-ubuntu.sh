#!/bin/bash

Shell_system_function=ubuntu-reset-system-function.sh

################################################################
if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

if [ -z "${Rootpath}" ]; then
	Rootpath=$1
	if [ ! -d "${Rootpath}" ]; then
		Rootpath=""
	fi
	if [ -z "${Rootpath}" ]; then
		Rootpath=$(pwd)
	fi
fi

################################################################
Shell_system_function=${Rootpath}/${Shell_system_function}
. ${Shell_system_function}

################################################################
function gogogo0() {
	gogogo1
	gogogo2
	gogogo3
	gogogo4
	gogogo5
	gogogo6
	gogogo7
	gogogo8
}
function gogogo1() {
	#关闭 sudo 密码
	func_system_sudo_close
	#系统自动挂载NTFS硬盘
	func_disk_auto
	#统一Win10和Ubuntu双系统的时间
	func_system_time_set
}
function gogogo2() {
	#安装 设置 clash
	func_clash
	func_clash_input
}
function gogogo3() {
	#修改软件下载源
	func_sources_list
}
function gogogo4() {
	#安装 deb
	func_deb_install
}
function gogogo5() {
	#安装 deepin-wine
	func_deepin_wine
	#安装 dep2020
	func_dep2020
}
function gogogo6() {
	#gnome 进行美化
	func_gnome
}
function gogogo7() {
	#换 terminator
	func_terminator
	#打造命令行工具oh-my-zsh
	func_ohmyzsh
}
function gogogo8() {
	func_shell_copy
	func_shell_change

	echo -n "######## 重启 ？y or n [ n ]: "
	local choice
	read choice
	if [ $choice = "y" ]; then
		func_execute_sudo reboot
	fi
}

function main() {
	func_clash_input
	local choice
	while [[ : ]]; do
		echo "
choice 0 ---------------------------------
	all
choice 1 ---------------------------------
	#关闭 sudo 密码
	#系统自动挂载NTFS硬盘
	#统一Win10和Ubuntu双系统的时间
choice 2 ---------------------------------
	#安装 设置 clash
choice 3 ---------------------------------
	#修改软件下载源
choice 4 ---------------------------------
	#安装 deb
choice 5 ---------------------------------
	#安装 deepin-wine
	#安装 dep2020
choice 6 ---------------------------------
	#gnome 进行美化
choice 7 ---------------------------------
	#换 terminator
	#打造命令行工具oh-my-zsh
choice 8 ---------------------------------
	func_shell_copy
	func_shell_change
	reboot
other ---------------------------------
	example: 2 [回车] 4 [回车] 0 [回车]
	exit   : - / q [回车] "

		echo -n " select you choice : "
		read choice

		case ${choice} in
			0)
				gogogo0
				;;
			1)
				gogogo1
				;;
			2)
				gogogo2
				;;
			3)
				gogogo3
				;;
			4)
				gogogo4
				;;
			5)
				gogogo5
				;;
			6)
				gogogo6
				;;
			7)
				gogogo7
				;;
			8)
				gogogo8
				;;
			q)
				break
				;;
			-)
				break
				;;
			*)
				echo "###########################	get error ! "
				;;
		esac
	done
}

main

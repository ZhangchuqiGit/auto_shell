#! /bin/bash

. create_busybox_function.sh

################################################################

# Busybox 的编译配置 和 Linux 内核编译配置 使用的命令是一样的。
# busybox 提供了几种配置： defconfig (缺省配置， 也是默认配置)、
# allyesconfig（ 最大配置） 、allnoconfig（最小配置） ， 一般选择缺省配置即可。

# busybox简介
# 	busybox是一个集成了一百多个最常用linux命令和工具的软件,
# 他甚至还集成了一个http服务器和一个telnet服务器,
# 而所有这一切功能却只有区区1M左右的大小.
# 我们平时用的那些linux命令就好比是分立式的电子元件,而busybox就好比是一个集成电路,
# 把常用的工具和命令集成压缩在一个可执行文件里,功能基本不变,而大小却小很多倍,
# 在嵌入式linux应用中,busybox有非常广的应用,
# 另外,大多数linux发行版的安装程序中都有busybox的身影,
# 安装linux的时候案ctrl+alt+F2就能得到一个控制台,
# 而这个控制台中的所有命令都是指向busybox的链接.Busybox的小身材大作用的特性,
# 给制作一张软盘的linux带来了及大方便

# 目录				说明
# applets			主要是实现applets框架的文件
# applets_sh		一些有用的脚本，例如：dos2unix、unix2dos等
# archival			与压缩有关的命令源文件，例如：bzip2、gzip等
# configs			自带的一些默认配置文件
# console-tools		与控制台相关的一些命令，例如：setconsole
# coreutils			常用的核心命令，例如：cat、rm等
# editors			常用的编辑命令，例如：vi、diff等
# findutils			用于查找的命令，例如：find、grep等
# init				init进程的实现源文件
# networking		与网络相关的命令，例如：telnetl、arp等
# shell				与shell相关的实现，例如：ash、msh等
# util-linux		Linux下常用的命令，主要是与文件系统相关的，例如：mkfs_ext2等

################################################################

# 根文件系统 BusyBox
DIR_busybox=busybox-1.34.1
DIR_busybox=${RootPath}/${DIR_busybox}
func_path_isexit "根文件系统" ${DIR_busybox}
func_chmod ${DIR_busybox}

# 工具链
ToolchainPath=/home/zcq/Arm_tool_x86_64_linux/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf
func_path_isexit "工具链路径" ${ToolchainPath}
func_chmod ${ToolchainPath}

export PATH=$PATH:${ToolchainPath}/bin
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-

ToolchainPathArm=${ToolchainPath}/arm-none-linux-gnueabihf
func_path_isexit "linux拷贝路径" ${ToolchainPathArm}

# 自定义编译结果 输出路径
DIR_busybox_Install=rootfs_busybox_${Time_launch} # 输出路径
DIR_busybox_Install=${RootPath}/${DIR_busybox_Install}
func_echo "自定义编译结果 输出路径 ${DIR_busybox_Install}"
if [ -d "${DIR_busybox_Install}" ]; then
	func_execute_sudo rm -rf ${DIR_busybox_Install}
fi
func_execute_sudo mkdir -m 777 -p -v ${DIR_busybox_Install} # 创建文件夹

################################################################

# 拷贝文件夹
Create_busybox=create_busybox
Create_busybox=${RootPath}/${Create_busybox}
func_path_isexit "拷贝文件夹" ${Create_busybox}
func_chmod ${Create_busybox}

################################################################

func_echo "busybox 中文字符支持"
Copy_chinese=${Create_busybox}/$(basename ${DIR_busybox})
Copy_tmp=${Copy_chinese}_libbb.printable_string.c
func_cpf ${Copy_tmp} ${DIR_busybox}/libbb/printable_string.c
Copy_tmp=${Copy_chinese}_libbb.unicode.c
func_cpf ${Copy_tmp} ${DIR_busybox}/libbb/unicode.c
unset Copy_chinese

# 配置文件
BusyboxConfig=busybox_1.34.1_defconfig
Copy_tmp=${Create_busybox}/${BusyboxConfig}
BusyboxConfig=${DIR_busybox}/configs/${BusyboxConfig}
func_cp ${Copy_tmp} ${BusyboxConfig}
if [ -f "${BusyboxConfig}" ]; then
	func_echo "配置文件 ${BusyboxConfig}"
fi

unset Copy_tmp
################################################################

func_echo_loop "\n 编译和安装 根文件系统 BusyBox "

func_cd ${DIR_busybox}
func_chmod ${DIR_busybox}

KernelVersion=$(make -s kernelversion -C ./)
func_echo "获取内核版本 ${KernelVersion}"

# CpuCoreNum=$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}') # 获取内核数目
# CpuCoreNum=$(cat /proc/cpuinfo | grep "processor" | wc -l) # 获取内核数目
CpuCoreNum=$(cat /proc/cpuinfo | grep -c "processor") # 获取内核数目
func_echo "获取内核数目 ${CpuCoreNum}"

func_execute make clean
func_execute make distclean # 会清除 .config

# 配置 make xxx_defconfig，生成 .config
if [ ! -f .config ]; then
	if [ -f "${BusyboxConfig}" ]; then
		func_execute make $(basename ${BusyboxConfig}) # 配置文件
	else
		# 图形化配置命令 配置 make menuconfig，生成 .config
		func_execute make menuconfig
	fi
fi

# ARCH := arm
# CROSS_COMPILE := /.../bin/arm-none-linux-gnueabihf-
# Use 'make V=1' to see the full commands
func_execute make V=0 -j${CpuCoreNum}

# 整理最小文件系统
func_execute make CONFIG_PREFIX=${DIR_busybox_Install} install -j${CpuCoreNum}

################################################################

func_echo_loop "\n 完善最小 Linux 系统的文件
制作文件系统还需要 \“dev,etc,lib,mnt,proc,sys,tmp,var\” 文件夹 \n"

func_cd ${DIR_busybox_Install}

# 创建文件夹
func_execute_sudo mkdir -m 775 -p -v etc lib proc root sys var
func_execute_sudo mkdir -m 777 -p -v dev home mnt opt sbin tmp
func_execute_sudo mkdir -m 777 -p -v etc/init.d etc/rc.d/init.d etc/hotplug/usb etc/hotplug/sd
func_execute_sudo mkdir -m 777 -p -v home/code home/zcq home/nobody
func_execute_sudo mkdir -m 777 -p -v lib/modules
func_execute_sudo mkdir -m 777 -p -v mnt/disk mnt/nfs
func_execute_sudo mkdir -m 777 -p -v usr/bin usr/lib usr/local/bin usr/local/lib usr/sbin usr/share
func_execute_sudo mkdir -m 777 -p -v var/lib var/lock var/log var/run var/tmp var/ftp

func_execute_sudo mkdir -m 777 -p -v var/empty var/log var/log/boa var/lock var/run var/tmp

################################################################
# 拷贝文件夹
# Create_busybox=file_etc_busybox
# Create_busybox=${RootPath}/${Create_busybox}

Cpy_eth_setting=${Create_busybox}/eth0-setting
Cpy_passwd=${Create_busybox}/passwd
Cpy_profile=${Create_busybox}/profile
Cpy_ifconfig_eth=${Create_busybox}/ifconfig-eth0
Cpy_rcS=${Create_busybox}/rcS
Cpy_netd=${Create_busybox}/netd
Cpy_resolv=${Create_busybox}/resolv.conf
Cpy_mtab=${Create_busybox}/mtab

func_cpf ${Cpy_eth_setting} etc/
func_cpf ${Cpy_passwd} etc/
func_cpf ${Cpy_profile} etc/profile
func_cpf ${Cpy_ifconfig_eth} etc/init.d/
func_cpf ${Cpy_rcS} etc/init.d/
func_cpf ${Cpy_netd} etc/rc.d/init.d/
func_cpf ${Cpy_resolv} etc/
func_cpf ${Cpy_mtab} etc/

unset Cpy_eth_setting Cpy_passwd Cpy_profile Cpy_ifconfig_eth Cpy_rcS Cpy_netd Cpy_resolv Cpy_mtab

# 修改文件系统
Cpy_mdev=${Create_busybox}/mdev.conf
func_cpf ${Cpy_mdev} etc/

# 添加对热插拔事件响应， 实现 U 盘自动挂载与卸载
# Cpy_mdev=${Create_busybox}/udisk_insert
# func_cpf ${Cpy_mdev} etc/hotplug/usb/
# Cpy_mdev=${Create_busybox}/udisk_remove
# func_cpf ${Cpy_mdev} etc/hotplug/usb/

# 实现 SD/TF 卡的自动挂载
# Cpy_mdev=${Create_busybox}/sd_insert
# func_cpf ${Cpy_mdev} etc/hotplug/sd/
# Cpy_mdev=${Create_busybox}/sd_remove
# func_cpf ${Cpy_mdev} etc/hotplug/sd/

unset Cpy_mdev

# modbus 是一个 通用的纯数据协议
# Cpy_libmodbus=${Create_busybox}/arm_libmodbus/lib/libmodbus.*
# func_cpf ${Cpy_libmodbus} lib/
# unset Cpy_libmodbus

# 自动挂载的分区
Cpy_disk=${Create_busybox}/fstab
func_cpf ${Cpy_disk} etc/
Cpy_disk=${Create_busybox}/inittab
func_cpf ${Cpy_disk} etc/
unset Cpy_disk

################################################################
# 拷贝 工具链 lib

func_cpl "${ToolchainPathArm}/libc/etc" ./
func_cpl "${ToolchainPathArm}/libc/lib" ./
func_cpl "${ToolchainPathArm}/libc/sbin" ./
func_cpl "${ToolchainPathArm}/libc/usr" ./
func_cpl "${ToolchainPathArm}/libc/var" ./

#func_cpl "${ToolchainPathArm}/libc/lib/*.so*" lib/
#func_cpl "${ToolchainPathArm}/libc/lib/*.a" lib/
# func_execute_sudo rm -f lib/ld-linux-armhf.so.3
func_cpf ${ToolchainPathArm}/libc/lib/ld-linux-armhf.so.3 lib/
# ld-linuxarmhf.so.3 不能作为符号链接，否则的话在根文件系统中执行程序无法执行！

func_cpl "${ToolchainPathArm}/lib" ./
# func_cpl "${ToolchainPathArm}/lib/*.so*" lib/
# func_cpl "${ToolchainPathArm}/lib/*.a" lib/

func_cp "${ToolchainPathArm}/bin" ./

################################################################

# 安装打包工具 make_ext4fs
# sudo apt install -fy android-tools-adb android-tools-fastboot android-tools-mkbootimg
# sudo apt install -fy android-sdk-libsparse-utils android-sdk-ext4-utils android-sdk-platform-tools

#${RootPath}/build_system.img.sh
# 314572800 = 300 *1024 *1024
# make_ext4fs -s -l 314572800 -a root -L linux system.img ${DIR_busybox_Install}
# sudo chmod -R 777 system.img
# make_ext4fs -s -l 314572800 -a root -L linux $(basename ${DIR_busybox_Install}).img ${DIR_busybox_Install}
# sudo chmod -R 777 $(basename ${DIR_busybox_Install}).img

#tar -cjf $(basename ${DIR_busybox_Install}).tar.bz2 ${DIR_busybox_Install} # 适用 迅为 IMX6ULL 最小 linux 系统镜像
#sudo chmod -R 777 $(basename ${DIR_busybox_Install}).tar.bz2

# 这个命令里面的 996147200 就是指定了 linux 存储空间的大小了， 即：
# 996x1024x1024=996MB
# 在前面的分区里我们分配的是 1G 的空间， 这里我们需要预留几兆的空间，所以设置为 996MB
# make_ext4fs -s -l 996147200 -a root -L linux ${filename} ${directory}
# make_ext4fs -s -l 996M -a root -L linux ${filename} ${directory}

# 通过上面的讲解我们已经清楚了怎么扩展存储空间，
# 例如把存贮空间改成 2G， 那我们只需要修改下两个地方。
# 1）fdisk -c 0 2048 300 300
# 2) make_ext4fs -s -l 2092957696 -a root -L linux system.img root
# 其中的 2092957696 = 1996 x 1024 x 1024 = 1996MB。

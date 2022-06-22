#! /bin/bash

source ARM_function.sh

# SD卡 启动系统 烧写脚本
# sudo fdisk -l
# sudo ./imx6-sd-boot.sh /dev/sdb

################################################################################

# 指定 Linux 内核镜像文件，如 boot/zImage
Kernel=boot/zImage

# 指定 u-boot，如 boot/u-boot.imx
Uboot=boot/u-boot.imx

# 指定 设备树，如 boot/imx6ull-alientek-emmc.dtb
Devicetree=boot/imx6ull-alientek-emmc.dtb

# 指定 根文件系统 压缩包，如 filesystem/rootfs.tar.bz2
# filesystem=filesystem/

Modules=""

################################################################################

# 打印用法
f_usage() {
	# sudo ./$(basename $1) /dev/sdb
	func_echo -e "用法示例: $0 /dev/sdb "
	exit 1
}

if [ -z ${device} ]; then
	if [ $# -eq 1 ]; then
		device=$1
	else
		f_usage
	fi
fi

# 这里防止选错设备，否则会影响 Ubuntu 系统的启动
if [ $device == "/dev/sda" ]; then
	func_echo -e "请不要选择 sda 设备，/dev/sda 通常是您的 Ubuntu 硬盘！
继续操作你的系统将会受到影响！"
	f_usage
fi

# 判断选择的块设备 是否存在 及 是否是一个块设备
if_device() {
	if [ ! -e $device ]; then
		declare -i timecnt
		local timecnt=0
		func_echo "选择的 块设备 $device 不存在"
		echo -e "wait for $device appear: sleep 0s\c"
		while [ ! -e $device ]; do
			sleep 1
			let "timecnt++"
			if [ ${timecnt} -le 10 ]; then
				echo -e "\033[2D${timecnt}s\c"
			else
				echo -e "\033[3D${timecnt}s\c"
			fi
			if [ ${timecnt} -ge 15 ]; then
				echo
				f_usage
			fi
		done
		echo
	fi
	if [ ! -b $device ]; then
		func_echo -e "$device 不是一个块设备文件"
		f_usage
	fi
	func_chmod 777 ${device}
}
if_device

f_appoint_echo() {
	#echo $0
	#echo $(dirname $0)
	func_echo -p "指定 Linux 内核镜像文件: \n\t${Kernel}"
	func_echo -p "指定 u-boot: \n\t${Uboot}"
	func_echo -p "指定 设备树: \n\t${Devicetree}"
	func_echo -p "指定 根文件系统 压缩包: \n\t${filesystem}"
}

f_device_file() {
	if [ ! -f ${Kernel} ]; then
		func_echo -e "找不到 Linux 内核镜像文件 ${Kernel}"
		exit 1
	fi
	if [ ! -f ${Uboot} ]; then
		func_echo -e "找不到 u-boot ${Uboot}"
		exit 1
	fi
	if [ ! -f ${Devicetree} ]; then
		func_echo -e "找不到 设备树 ${Devicetree}"
		exit 1
	fi
	if [ -n ${filesystem} ] && [ ! -f ${filesystem} ]; then
		func_echo -e "找不到 根文件系统 压缩包 ${filesystem}"
		exit 1
	fi
}
f_device_file

_read_enter() {
	local _enter
	echo "即将进行制作 eMMC 系统启动卡，大约花费几分钟时间,请耐心等待!"
	echo "************************************************************
	注意：这将会清除 $device 所有的数据
	请按 <任意键> 确认继续
************************************************************"
	read _enter
	#	unset _enter
}
_read_enter

################################################################################

# 格式化前要卸载
uninstall_before_formatting() {
	local uninstall="$(ls -1 ${device}? 2>/dev/null)"
	if [ -n "${uninstall}" ]; then
		for i in ${uninstall}; do
			echo -e "卸载 device '$i'"
			${Sudo} umount $i 2>/dev/null
		done
	fi
}
uninstall_before_formatting # 格式化前要卸载

# Linux dd 命令用于读取、转换并输出数据。
# dd 可从标准输入或文件中读取数据，根据指定的格式来转换数据，再输出到文件、设备或标准输出。
# if=文件名：输入文件名，默认为标准输入。即指定源文件。
# of=文件名：输出文件名，默认为标准输出。即指定目的文件。
# ibs=bytes：一次读入bytes个字节，即指定一个块大小为bytes个字节。
# obs=bytes：一次输出bytes个字节，即指定一个块大小为bytes个字节。
# bs=bytes：同时设置读入/输出的块大小为bytes个字节。
# cbs=bytes：一次转换bytes个字节，即指定转换缓冲区大小。
# skip=blocks：从输入文件开头跳过blocks个块后再开始复制。
# seek=blocks：从输出文件开头跳过blocks个块后再开始复制。
# count=blocks：仅拷贝blocks个块，块大小等于ibs指定的字节数。
# conv=<关键字>，关键字可以有以下 11 种：
#    conversion：	用指定的参数转换文件。
#    ascii：		转换ebcdic为ascii
#    ebcdic：		转换ascii为ebcdic
#    ibm：			转换ascii为alternate ebcdic
#    block：		把每一行转换为长度为cbs，不足部分用空格填充
#    unblock：		使每一行的长度都为cbs，不足部分用空格填充
#    lcase：		把大写字符转换为小写字符
#    ucase：		把小写字符转换为大写字符
#    swap：			交换输入的每对字节
#    noerror：		出错时不停止
#    notrunc：		不截短输出文件
#    sync：			将每个输入块填充到 ibs 个字节，不足部分用空（NUL）字符补齐。

# SD 卡 默认 512字节/扇区，1024 字节(SD保留区)+ 500 KB(boot)

func_echo "执行 $device 格式化"
func_execute_sudo dd if=/dev/zero of=$device bs=1024 count=$((2 * 1024))

func_echo "
 Linux fdisk 是一个创建和维护分区表的程序
 第一个分区 为 64M 用来存放 设备树 与 内核镜像文件，因为设备树与内核都比较小，不需要太大的空间
 第二个分区 为 SD卡 的总大小 -64M，用来存放 根文件系统 "

# Here Documents，其中 END 可以换成其他字符，在两个 END 之间的内容，
# 会被当成 cat 的标准输入传递给 cat，所以上面的代码实际就是打印

# 在嵌入式开发中经常会对mmc卡，或u盘，固态硬盘等重新分区。
# 手动调用 fdisk 能完成这些重复劳动，但总是不方便。为了提高效率，写如下脚本用于方便开发。
# 注意：其中的空行必不可少，每一个空行意味着一个回车。
# 用 Shell 脚本进行 fdisk 分区
# 输入 sudo fdisk /dev/sdb 命令之后，会提示你进行什么操作，如果不清楚的话，可以输入 m 查看操作说明。
# 欢迎使用 fdisk (util-linux 2.34)。
# 更改将停留在内存中，直到您决定将更改写入磁盘。
# 使用写入命令前请三思。
#  DOS (MBR)
#   a   开关 可启动 标志
#   b   编辑嵌套的 BSD 磁盘标签
#   c   开关 dos 兼容性标志
#  常规
#   d   删除分区
#   F   列出未分区的空闲区
#   l   列出已知分区类型
#   n   添加新分区
#   p   打印分区表
#   t   更改分区类型
#   v   检查分区表
#   i[0-4]   打印某个分区的相关信息
#  杂项
#   m   打印此菜单
#   u   更改 显示/记录 单位
#   x   更多功能(仅限专业人员)
#  脚本
#   I   从 sfdisk 脚本文件加载磁盘布局
#   O   将磁盘布局转储为 sfdisk 脚本文件
#  保存并退出
#   w   将分区表写入磁盘并退出
#   q   退出而不保存更改
#  新建空磁盘标签
#   g   新建一份 GPT 分区表
#   G   新建一份空 GPT (IRIX) 分区表
#   o   新建一份的空 DOS 分区表
#   s   新建一份空 Sun 分区表

# SD 卡 默认 512字节/扇区，1024 字节(SD保留区)+ 500 KB(boot)
cat <<END | ${Sudo} fdisk -H 255 -S 63 $device
n
p
1

+64M
n
p
2


t
1
c
a
1
w
END
sleep 1s # 等待 fdisk 完成

# 上面分区后系统会自动挂载，所以这里再一次卸载
uninstall_before_formatting # 格式化前要卸载

# mkfs [选项] [-t <类型>] [文件系统选项] <设备> [<大小>]
# 创建一个 Linux 文件系统。

# 第01个分区创建为 Fat32 格式
if [ -b ${device}1 ]; then
	func_echo "格式化 ${device}p1: 第一个分区创建为 Fat32 格式: eMMC boot 分区"
	func_execute_sudo mkfs.vfat -F 32 -n "boot" ${device}1
else
	func_echo -e "找不到 ${device}1: SD卡 boot 分区"
	exit 11
fi

# 第02个分区创建为 ext4 格式
if [ -b ${device}2 ]; then
	func_echo "格式化 ${device}p2: 第二个分区创建为 ext4 格式: eMMC rootfs 分区"
	func_execute_sudo mkfs.ext4 -F -L "rootfs" ${device}2
else
	func_echo -e "找不到 ${device}2: SD卡 rootfs 分区"
	exit 12
fi

if_device

################################################################################

func_echo "烧写 ${Uboot} 到 ${device} "

func_execute_sudo dd bs=1024 seek=1 conv=fsync if=${Uboot} of=${device}

if_device

################################################################################
Dir_sdk=/tmp/sdk/${Time_launch}

f_sdk() {
	if [ -d "${Dir_sdk}" ]; then
		func_execute_sudo rm -rf ${Dir_sdk}
	fi
}
f_sdk

func_mkdir 777 ${Dir_sdk}

################################################################################

sdk_path=${Dir_sdk}/boot
func_mkdir 777 ${sdk_path}

func_echo "复制 设备树 与 Linux 内核镜像文件 到 ${device}1 : boot 区"

echo "挂载 ${device}1 ---- ${sdk_path}"
func_execute_sudo mount ${device}1 ${sdk_path}

func_cpf ${Devicetree} ${sdk_path}/
func_cpf ${Kernel} ${sdk_path}/

func_execute_sudo sync
echo "卸载 ${device}1"
func_execute_sudo umount ${sdk_path}

################################################################################

sdk_path=${Dir_sdk}/rootfs
func_mkdir 777 ${sdk_path}

func_echo "解压 根文件系统 压缩包 到 ${device}2 : rootfs 区"

echo "挂载 ${device}2 ---- ${sdk_path}"
func_execute_sudo mount ${device}2 ${sdk_path}/

f_tool() {
	func_mkdir 777 ${sdk_path}/uboot_SD_eMMC
	func_mkdir 777 ${sdk_path}/uboot_SD_eMMC/boot
	func_mkdir 777 ${sdk_path}/uboot_SD_eMMC/filesystem
	func_cpf ./\*.sh ${sdk_path}/uboot_SD_eMMC/
	func_cpf ${Kernel} ${sdk_path}/uboot_SD_eMMC/boot/
	func_cpf ${Uboot} ${sdk_path}/uboot_SD_eMMC/boot/
	func_cpf ${Devicetree} ${sdk_path}/uboot_SD_eMMC/boot/
	func_execute_sudo sync
	# func_echo "拷贝 根文件系统 压缩包： y/n [n]"
	# read Copt_system
	# if [[ "${Copt_system}" == "y" ]]; then
	# 	func_cpf ${filesystem} ${sdk_path}/uboot_SD_eMMC/filesystem/
	# 	sync
	# fi
	# unset Copt_system
	# func_execute_sudo tar -xjf ${filesystem} -C ${sdk_path}/
	# func_execute_sudo sync
}
f_tool

f_modules() {
	if [ -n "${Modules}" ]; then
		func_mkdir 777 ${sdk_path}/uboot_SD_eMMC/modules
		func_cpf ${Modules} ${sdk_path}/uboot_SD_eMMC/modules/

		#判断是否存在这个目录，如果不存在就为文件系统创建一个modules目录
		if [ ! -d "${sdk_path}/lib/modules" ]; then
			func_mkdir 777 ${sdk_path}/lib/modules
		fi
		func_execute_sudo tar -xjf $Modules -C ${sdk_path}/lib/modules/
		func_execute_sudo sync
	fi
}
# f_modules

func_execute_sudo sync
echo "卸载${device}2"
func_execute_sudo umount ${sdk_path}

################################################################################

f_sdk

func_chmod 777 /media/zcq/

echo "SD卡启动系统烧写完成！"

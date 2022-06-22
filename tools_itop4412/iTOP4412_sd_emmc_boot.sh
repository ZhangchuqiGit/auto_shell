#! /bin/bash

# SD卡 启动系统 烧写脚本

# Android 方式
# 分区表1 剩余空间
# 分区表2 system
# 分区表3 data use
# 分区表4 cache

# sudo fdisk -l

# sudo ./iTOP4412_sd_emmc_boot.sh /dev/sdb
# TF 卡分区
# fdisk -c 1 4000 2000 2000  # ubuntu 方式
#         分区0: bootloader
#         分区1: fatformat  mmc 1:1
# 2700 MB 分区2: ext3format mmc 1:2
#   50 MB 分区3: ext3format mmc 1:3
#   50 MB 分区4: ext3format mmc 1:4

# 在 TF 卡 分区1 fatformat 的目录中 新建文件夹“sdupdate”，存放
# 	u-boot-iTOP-4412.bin	bootloader
# 	zImage					kernel
# 	zImage_sd				kernel
# 	ubuntu.tar.gz			rootfs

# 将 Ubuntu 文件系统 ubuntu.tar.gz 解压到 TF 卡 分区2 2.7G 的目录中
# 使用解压命令 tar -xvf ubuntu.tar.gz
# 使用解压命令 tar -xvf ubuntu.tar.gz -C /sd 分区2 2.7G 挂载目录

#### 将开发板的拨码开关置于 TF 卡启动模式

# 启动开发板，进入 uboot 模式，给 eMMC 分区和烧写镜像

# eMMC 分区、烧写镜像
# fdisk -c 0 2700 300 300  # ubuntu 方式
#         分区1: fatformat  mmc 0:1
# 2700 MB 分区2: ext3format mmc 0:2
#  300 MB 分区3: ext3format mmc 0:3
#  300 MB 分区4: ext3format mmc 0:4

# 烧写命令
#	sdfuse flash bootloader u-boot-iTOP-4412.bin 
#	sdfuse flash bootloader 2010-u-boot-iTOP-4412.bin 
#	sdfuse flash kernel zImage_sd  		#### 注意 是 zImage_sd

# 等待烧写完成，重启开发板： reset

#### 重启开发板后，开发板会运行 sd 卡 Ubuntu 系统

# 使用命令 df -l 查找盘符

# 将 Ubuntu 文件系统 ubuntu.tar.gz 解压到 eMMC 分区2 2.7G 的目录中
# 使用解压命令 tar -xvf ubuntu.tar.gz -C /eMMC 分区2 2.7G 挂载目录

# 解压缩完成后，重启开发板，进入 uboot 模式，将内核镜像“zImage”烧写到 eMMC 中
# sdfuse flash kernel zImage 			#### 注意 是 zImage

#### 将开发板的拨码开关置于 eMMC 启动模式

# 重启开发板

################################################################################

# 目录 sdupdate
Uboot=u-boot-iTOP-4412.bin # 指定 bootloader
# Kernel=uImage              # 指定 eMMC Linux 内核镜像文件
# Kernel=zImage              # 指定 eMMC Linux 内核镜像文件
# Kernel_sd=zImage_sd        # 指定 sd卡 Linux 内核镜像文件
# filesystem=rootfs-ubuntu-16.04.7-ok.tar.bz2 # 指定 根文件系统 压缩包

################################################################################

function __debug_echo() {
	local slt=$1
	case $slt in
	-v) # -variable 变量
		shift
		echo -e "\033[37;44m $* \e[0m"
		;;
	-p) # path or file
		shift
		echo -e "\033[36;40m $* \e[0m"
		;;
	-e) # error 错误
		shift
		echo -e "\033[30;41m 错误！$* \e[0m"
		;;
	-c) # shell 命令
		shift
		echo -e "\033[32m $* \e[0m"
		;;
	*) # 描述信息
		echo -e "\033[33m $* \e[0m"
		;;
	esac
	unset slt
}

rootpath=$(pwd)                             # 当前工作目录
Uboot=${rootpath}/sdupdate/${Uboot}         # 指定 bootloader
Kernel=${rootpath}/sdupdate/${Kernel}       # 指定 eMMC Linux 内核镜像文件
Kernel_sd=${rootpath}/sdupdate/${Kernel_sd} # 指定 sd卡 Linux 内核镜像文件
if [ -n "${filesystem}" ]; then
	filesystem=${rootpath}/sdupdate/${filesystem} # 指定 根文件系统 压缩包
fi

appoint_echo() {
	#	echo $0
	#	echo $(dirname $0)
	__debug_echo -v "指定 bootloader:\n\t${Uboot}"
	__debug_echo -v "指定 eMMC Linux 内核镜像文件:\n\t${Kernel}"
	__debug_echo -v "指定 sd卡 Linux 内核镜像文件:\n\t${Kernel_sd}"
	__debug_echo -v "指定 根文件系统 压缩包:\n\t${filesystem}"
}

# 打印用法
usage() {
	#	  sudo ./$(basename $1) /dev/sdb
	echo "
用法示例：
  sudo $0 /dev/sdb
可选选项:
  -h,--help   打印帮助信息  "
	appoint_echo
	exit 0
}

# execute 执行语句 成功与否打印
execute() {
	__debug_echo -c "\$ $*"
	$@
	if [ $? -ne 0 ]; then
		__debug_echo -e "执行 $*"
		exit $?
	fi
}
# execute pwd ; ifconfig
# execute mkdir -m 777 -p -v file # 创建文件夹

if [ $# -gt 0 ]; then
	# 命令行处理，根据选项获得参数
	while [ $# -gt 0 ]; do
		case $1 in
		--help | -h)
			usage
			shift
			;;
		*)
			device=$1
			shift
			;;
		esac
	done
else
	__debug_echo -e "参数"
	usage
	exit 1
fi

appoint_echo

if [ ! -f "${Uboot}" ]; then
	__debug_echo -e "找不到 ${Uboot}"
	exit 1
fi

# if [ ! -f "${Kernel}" ]; then
# 	__debug_echo -e "找不到 ${Kernel}"
# 	exit 1
# fi

# # shellcheck disable=SC2086
# if [ ! -f "${Kernel_sd}" ]; then
# 	__debug_echo -e "找不到 ${Kernel_sd}"
# 	exit 1
# fi

# shellcheck disable=SC2086
if [ -n "${filesystem}" ]; then
	if [ ! -e ${filesystem} ]; then
		__debug_echo -e "找不到 ${filesystem}"
		exit 1
	fi
fi

# 这里防止选错设备，否则会影响 Ubuntu 系统的启动
# shellcheck disable=SC2086
if [ $device = '/dev/sda' ]; then
	__debug_echo -e "
	请不要选择 sda 设备，/dev/sda 通常是您的 Ubuntu 硬盘！
	继续操作你的系统将会受到影响！脚本已自动退出"
	exit 1
fi

# 判断选择的块设备 是否存在 及 是否是一个块设备
if_device() {
	if [ ! -e "$device" ]; then
		declare -i timecnt
		local timecnt=0
		__debug_echo "选择的 块设备 $device 不存在"
		echo -e "wait for $device appear: sleep 0s\c"
		while [ ! -e "$device" ]; do
			sleep 1
			let "timecnt++"
			if [ "${timecnt}" -le 10 ]; then
				echo -e "\033[2D${timecnt}s\c"
			else
				echo -e "\033[3D${timecnt}s\c"
			fi
			if [ ${timecnt} -ge 15 ]; then
				echo
				exit
			fi
		done
		echo
	fi
	if [ ! -b $device ]; then
		__debug_echo -e "$device 不是一个块设备文件"
		exit 1
	fi
}
if_device

echo "即将进行制作 SD 系统启动卡，大约花费几分钟时间,请耐心等待!"
echo "************************************************************
	注意：这将会清除 $device 所有的数据
	在脚本执行时请不要将 $device 拔出
	请按 <任意键> 确认继续
************************************************************"
read enter
unset enter

# 格式化前要卸载
uninstall_before_formatting() {
	local uninstall=""
	uninstall=$(ls -1 ${device}? 2>/dev/null)
	if [[ -n ${uninstall} ]]; then
		for i in ${uninstall}; do
			echo "卸载 device '$i'"
			umount $i 2>/dev/null
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

# 	memset(mbr, 0x00, 512);
__debug_echo "执行 $device 格式化；4 MB = 512 每块字节 * 2 * 1024 * 4 "
execute dd if=/dev/zero of=$device bs=512 count=$((2 * 1024 * 4))  conv=fsync
sync

__debug_echo "烧写 ${Uboot} 到 ${device} "
execute dd if=$Uboot of=${device} bs=512 seek=1 conv=fsync
sync

#    将该硬盘进行分区；
#    对分区进行格式化；
#    将分区mount到系统某个目录，便可以访问。

__debug_echo "
# TF 卡分区
# fdisk -c 1 2700 300 300  # ubuntu 方式
#         分区1: fatformat  mmc 1:1
# 2700 MB 分区2: ext3format mmc 1:2
#  300 MB 分区3: ext3format mmc 1:3
#  300 MB 分区4: ext3format mmc 1:4 "

# Here Documents，其中 END 可以换成其他字符，在两个 END 之间的内容，
# 会被当成 cat 的标准输入传递给 cat，所以上面的代码实际就是打印

# 在嵌入式开发中经常会对mmc卡，或u盘，固态硬盘等重新分区。
# 手动调用 fdisk 能完成这些重复劳动，但总是不方便。为了提高效率，写如下脚本用于方便开发。
# 注意：其中的空行必不可少，每一个空行意味着一个回车。
# fdisk用法：
# fdisk [选项] <磁盘>    更改分区表
# fdisk [选项] -l <磁盘> 列出分区表
# fdisk -s <分区>        给出分区大小(块数)
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
#   n   添加/创建分区
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
#   n   添加/创建分区
#	p   添加主分区，默认主分区，主分区最多只能创建4个
#	e 	添加扩展分区
#  保存并退出
#   w   将分区表写入磁盘并退出
#   q   退出而不保存更改
#  新建空磁盘标签
#   g   新建一份 GPT 分区表
#   G   新建一份空 GPT (IRIX) 分区表
#   o   新建一份的空 DOS 分区表
#   s   新建一份空 Sun 分区表

# fdisk 脚本自动执行
cat <<EOF | fdisk -H 255 -S 63 $device &>/dev/null
d
1
d
2
d
3
d
4
p
w
EOF
# fdisk 脚本自动执行
sleep 1s # 等待 fdisk 完成
# 起点扇区
if false; then
# 2048 		= 1M / 512 (字节/扇区) = 1*1024*1024 / 512
# (32768 - 2048) * 512 /1024 /1024 = 15M
# 32768 	= 16M / 512 (字节/扇区) = 16*1024*1024 / 512
# 5562368 	= 32768 + 2700M / 512 (字节/扇区)
# 6176768	= 5562368 + 300M / 512 (字节/扇区)
# 6791168 	= 6176768 + 300M / 512 (字节/扇区)
# Android 方式
# 分区表1 剩余空间		# 分区表2 system		# 分区表3 data use		# 分区表4 cache
fdisk -H 255 -S 63 -L $device <<EOF
n
p
2
32768
+2700M
n
p
3
5562368
+300M
n
p
4
6176768
+300M
n
p
6791168

c
t
1
c
t
2
83
t
3
83
t
4
83
p
w
EOF
else 
# 2048 		= 1M / 512 (字节/扇区) = 1*1024*1024 / 512
# (32768 - 2048) * 512 /1024 /1024 = 15M
# 32768 	= 16M / 512 (字节/扇区) = 16*1024*1024 / 512
# 12615680 	= 32768    + 6144M / 512 (字节/扇区)
# 23101440	= 12615680 + 5120M / 512 (字节/扇区)
# 31490048 	= 23101440 + 4096M / 512 (字节/扇区)
# Android 方式
# 分区表1 剩余空间		# 分区表2 system		# 分区表3 data use		# 分区表4 cache
fdisk -H 255 -S 63 -L $device <<EOF
n
p
2
32768
+6144M
n
p
3
12615680
+5120M
n
p
4
23101440
+4096M
n
p
31490048

c
t
1
c
t
2
83
t
3
83
t
4
83
p
w
EOF
fi
sleep 1s # 等待 fdisk 完成

echo -e "\033[35;43m 分区创建完成 \e[0m"

__debug_echo "-----------------------------------------------"
uninstall_before_formatting # 格式化前要卸载

# 第01个分区创建为 Fat32 格式
if [ -b ${device}1 ]; then
	__debug_echo "格式化 ${device}1: 第01个分区创建为 Fat32 格式"
	execute mkfs.vfat -F 32 -n 'Fat32' ${device}1
else
	__debug_echo -e "找不到 ${device}1"
	exit 11
fi
# 第02个分区创建为 ext3 格式
if [ -b ${device}2 ]; then
	__debug_echo "格式化 ${device}2: 第02个分区创建为 ext3 格式"
	execute mkfs.ext3 -F -L 'system' ${device}2
else
	__debug_echo -e "找不到 ${device}2"
	exit 12
fi
# 第03个分区创建为 ext3 格式
if [ -b ${device}3 ]; then
	__debug_echo "格式化 ${device}3: 第03个分区创建为 ext3 格式"
	execute mkfs.ext3 -F -L 'datause' ${device}3
else
	__debug_echo -e "找不到 ${device}3"
	exit 13
fi
# 第04个分区创建为 ext3 格式
if [ -b ${device}4 ]; then
	__debug_echo "格式化 ${device}4: 第04个分区创建为 ext3 格式"
	execute mkfs.ext3 -F -L 'cache' ${device}4
else
	__debug_echo -e "找不到 ${device}4"
	exit 14
fi

uninstall_before_formatting # 卸载

if_device
__debug_echo "-----------------------------------------------"

rm -rf /tmp/sdk &>/dev/null
#rm -f $Uboot

if false; then
	sd_2_path=/tmp/sdk/$$/2
	execute mkdir -m 777 -p ${sd_2_path}

	echo " 挂载 ${device}2 -> ${sd_2_path}"
	execute mount ${device}2 ${sd_2_path}

	# if [ -n "${filesystem}" ]; then
	# __debug_echo "解压 根文件系统 压缩包"
	# execute tar -xjf ${filesystem} -C ${sd_2_path}/ # 解压 根文件系统 压缩包
	# execute sync
	# fi

	sync
	echo "卸载 ${device}2"
	execute umount ${sd_2_path}
fi

sd_1_path=/tmp/sdk/$$/1
execute mkdir -m 777 -p ${sd_1_path}

echo " 挂载 ${device}1 -> ${sd_1_path}"
execute mount ${device}1 ${sd_1_path}

# # 拷贝到 2.7G 文件夹
__debug_echo "拷贝到 2.7G 文件夹 ${sd_1_path}"
execute cp -rf ${rootpath}/sdupdate ${sd_1_path}/
chmod -R 777 ${sd_1_path}
execute sync

sync
echo "卸载 ${device}1"
execute umount ${sd_1_path}

execute rm -rf /tmp/sdk

__debug_echo "-----------------------------------------------"

echo "SD卡启动系统烧写完成！"

exit
__debug_echo "
#### 将开发板的拨码开关置于 TF 卡启动模式
# 启动开发板，进入 uboot 模式，给 eMMC 分区和烧写镜像

# eMMC 分区、烧写镜像
# fdisk -c 0 2700 300 300  # ubuntu 方式
#         分区1: fatformat  mmc 0:1
# 2700 MB 分区2: ext3format mmc 0:2
#  300 MB 分区3: ext3format mmc 0:3
#  300 MB 分区4: ext3format mmc 0:4

# 烧写命令 sdfuse flashall 可以用下面替代的烧写命令：
#	sdfuse flash bootloader u-boot-iTOP-4412.bin
#	sdfuse flash kernel zImage_sd  		#### 注意 是 zImage_sd

# 等待烧写完成，重启开发板： reset
#### 重启开发板后，开发板会运行 sd 卡 Ubuntu 系统

# 使用命令 df -l 查找盘符

# 将 Ubuntu 文件系统 ${filesystem} 解压到 eMMC 分区2 2.7G 的目录中
# 使用解压命令 tar -xjf ${filesystem} -C /eMMC 分区2 2.7G 挂载目录

# 解压缩完成后，重启开发板，进入 uboot 模式，将内核镜像 zImage 烧写到 eMMC 中
# sdfuse flash kernel zImage 			#### 注意 是 zImage

#### 将开发板的拨码开关置于 eMMC 启动模式
# 重启开发板 "

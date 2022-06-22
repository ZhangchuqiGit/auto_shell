#! /bin/bash

# SD卡 启动系统 烧写脚本  ubuntu 方式

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
#	sdfuse flash kernel zImage_sd  		#### 注意 是 zImage_sd

# 等待烧写完成，重启开发板： reset

#### 重启开发板后，开发板会运行 sd 卡 Ubuntu 系统

# 使用命令 df -l 查找盘符

# 将 Ubuntu 文件系统 ubuntu.tar.gz 解压到 eMMC 分区2 2.7G 的目录中
# 使用解压命令 tar -xzf ubuntu.tar.gz -C /eMMC 分区2 2.7G 挂载目录

# 解压缩完成后，重启开发板，进入 uboot 模式，将内核镜像“zImage”烧写到 eMMC 中
# sdfuse flash kernel zImage 			#### 注意 是 zImage

#### 将开发板的拨码开关置于 eMMC 启动模式

# 重启开发板

################################################################################

# 目录 sdupdate
# Uboot=u-boot-iTOP-4412.bin                  # 指定 bootloader
# Kernel=zImage                               # 指定 eMMC Linux 内核镜像文件
# Kernel_sd=zImage_sd                         # 指定 sd卡 Linux 内核镜像文件
# filesystem=ubuntu.tar.gz					  # 指定 根文件系统 压缩包
filesystem=iTOP4412_ubuntu_12.04_for_LCD_20141230.tar.gz	  # 指定 根文件系统 压缩包

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

__debug_echo "
将 Ubuntu 文件系统 ubuntu.tar.gz 解压到 eMMC 分区2 2.7G 的目录中
使用解压命令 tar -xvf ubuntu.tar.gz -C /eMMC 分区2 2.7G 挂载目录"

# 打印用法
usage() {
	#	  sudo ./$(basename $1) /dev/sdb
	echo "
用法示例：
  sudo $0 ubuntu.tar.gz # 指定 根文件系统 压缩包
可选选项:
  -h,--help   打印帮助信息  "
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
				filesystem=$1 # 指定 根文件系统 压缩包
				shift
				;;
		esac
	done
else
	__debug_echo -e "参数"
	usage
	exit 1
fi

rm -rf /tmp/zcq &>/dev/null
sd_path=/tmp/zcq/sd			# /dev/mmcblk1p1
mmc_path=/tmp/zcq/mmc		# /dev/mmcblk0p2

execute mkdir -m 777 -p ${sd_path}
execute mkdir -m 777 -p ${mmc_path}

echo " 挂载 /dev/mmcblk1p1 -> ${sd_path}"
execute mount /dev/mmcblk1p1 ${sd_path}

echo " 挂载 /dev/mmcblk0p2 -> ${mmc_path}"
execute mount /dev/mmcblk0p2 ${mmc_path}

if [ -f ${sd_path}/${filesystem} ]; then
	__debug_echo "解压 根文件系统 压缩包"
	execute tar -xzf ${sd_path}/${filesystem} -C ${mmc_path}/ # 解压 根文件系统 压缩包

elif [ -f ${sd_path}/sdupdate/${filesystem} ]; then
	__debug_echo "解压 根文件系统 压缩包"
	execute tar -xzf ${sd_path}/sdupdate/${filesystem} -C ${mmc_path}/ # 解压 根文件系统 压缩包

else
	__debug_echo -e "找不到 ${sd_path} -> /dev/mmcblk1p1 : ${filesystem}"
	exit 1
fi
execute sync

__debug_echo "解压缩完成"

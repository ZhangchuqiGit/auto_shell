#! /bin/bash

# ./1_prepare.sh ${DIR_base_rootfs}

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

################################################################

# 任意路径下 获取 Zcq_Create_rootfs=/.../zcq_sysroot_Create_ubuntu_base_20.04
if [ -z "${Zcq_Create_rootfs}" ]; then
	#	if false; then
	if true; then
		Zcq_Create_rootfs=$(dirname $0)
	else
		Zcq_Create_rootfs=$0
		# $Zcq_Create_rootfs= ./rootfs.sh or ./file/rootfs.sh
		Zcq_Create_rootfs=${Zcq_Create_rootfs%/*} # . or ./file
	fi
	if [ "$Zcq_Create_rootfs" == "." ]; then
		Zcq_Create_rootfs=$(pwd)
	else
		#		if [ -d "${Zcq_Create_rootfs}" ]; then
		cd ${Zcq_Create_rootfs} || exit 31
		Zcq_Create_rootfs=$(pwd)
		#		fi
	fi
fi

################################################################

ARM_tool_function=""
f_ARM_tool_function() {
	local arm_tool_function=""
	arm_tool_function="${Zcq_Create_rootfs}/file_sh/ARM_tool_function.sh
	/opt/ARM_tool_function.sh"
	for tmp in ${arm_tool_function}; do
		if [ -f ${tmp} ]; then
			source ${tmp}
			ARM_tool_function=${tmp}
			return
		else
			echo -e "No exit : ${tmp}"
		fi
	done
	exit 1
}
f_ARM_tool_function

source ${Zcq_Create_rootfs}/0_val_path_file.sh
f_setval_1

if [ ${DIR_base_rootfs} == "/" ]; then
	DIR_base_rootfs=""
	exit 12
fi

func_cpf ${ARM_tool_function} /opt/
func_cpf ${ARM_tool_function} ${DIR_base_rootfs}/opt/

source ${Zcq_Create_rootfs}/file_sh/ubuntu_desktop_install.sh no_opt
if [ ! -f /opt/main_desktop_flag ]; then
	main_desktop
	func_touch 777 /opt/main_desktop_flag
fi

################################################################

func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs

func_chmod 777 ${Zcq_Create_rootfs}

# bin boot dev etc home lib media mnt opt proc
# root run sbin srv sys tmp usr var
func_chmod 777 dev home media mnt opt tmp root

################################################################

# dns 域名服务器
# Ubuntu 安装软件是通过名 apt / apt-get 从网上下载安装的，
# 第一次构建跟文件系统， etc/systemd/resolved.conf 不存在，因为系统没运行
# etc/resolv.conf  只对第一次构建跟文件系统有作用，
# 复制为 run/systemd/resolve/stub-resolv.conf
# 系统运行后 etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
# etc/resolv.conf 文件修改，很快又会被 etc/systemd/resolved.conf 覆盖
if [ -f ${Resolv_conf} ]; then
	# 直接拷贝本机 dns 配置文件
	func_cpf ${Resolv_conf} etc/resolv.conf
else
	${Sudo} echo "nameserver 8.8.8.8
nameserver 114.114.114.114 " >etc/resolv.conf
fi
func_chmod 777 etc/resolv.conf

# 修改软件源 默认的 apt 用国外源，修改为国内源
func_cpf ${Sources_list} etc/apt/sources.list
func_chmod 777 etc/apt/

exit 0

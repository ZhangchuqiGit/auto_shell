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
# f_setval_1

if [ ${DIR_base_rootfs} == "/" ]; then
	DIR_base_rootfs=""
	exit 12
fi

################################################################

func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs

func_chmod 777 ${Zcq_Create_rootfs}

# bin boot dev etc home lib media mnt opt proc
# root run sbin srv sys tmp usr var
func_chmod 777 dev home media mnt opt tmp root

# 创建文件夹
# func_mkdir 777 proc sys dev/pts

################################################################

f_qemu_install() {
	func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs
	# 安装工具
	# QEMU 是专门模拟不同机器架构的软件，在ubuntu中对其支持良好，
	# 若需要挂载识别 ubuntu armhf 版本的文件，必须安装 qemu-user-static 工具
	if [ ! -e /usr/bin/qemu-arm-static ]; then
		# 拷贝 qemu-arm-static，为主机挂载根文件系统做准备
		func_apt -i qemu-user-static
	fi
	func_cpf /usr/bin/qemu-arm-static usr/bin/
	func_chmod 777 usr/bin/qemu-arm-static
	func_cd -
}
f_qemu_uninstall() {
	func_cd ${DIR_base_rootfs} # 根文件系统 base rootfs
	if [ -e usr/bin/qemu-arm-static ]; then
		func_execute_sudo rm -rf usr/bin/qemu-arm-static
	fi
	func_cd -
}

################################################################

f_mount_sysroot() {
	func_echo "\$SHELL=$SHELL"
	func_echo "在主机 挂载 制作的根文件系统"

	func_execute_sudo mount -t proc /proc ${DIR_base_rootfs}/proc
	func_execute_sudo mount -t sysfs /sys ${DIR_base_rootfs}/sys
	func_execute_sudo mount -o bind /dev ${DIR_base_rootfs}/dev
	func_execute_sudo mount -o bind /dev/pts ${DIR_base_rootfs}/dev/pts

	# func_execute_sudo mount -t tmpfs /run ${DIR_base_rootfs}/run
	# func_execute_sudo mount -t tmpfs /tmp ${DIR_base_rootfs}/tmp

	#/usr/bin/bash -i
	func_execute_sudo chroot ${DIR_base_rootfs} /usr/bin/bash -i
}

f_umount_sysroot() {
	func_echo "\$SHELL=$SHELL"
	func_echo "在主机 卸载 制作的根文件系统"

	func_execute_sudo umount ${DIR_base_rootfs}/proc
	func_execute_sudo umount ${DIR_base_rootfs}/sys
	func_execute_sudo umount ${DIR_base_rootfs}/dev/pts
	func_execute_sudo umount ${DIR_base_rootfs}/dev

	# func_execute_sudo umount ${DIR_base_rootfs}/run
	# func_execute_sudo umount ${DIR_base_rootfs}/tmp
}

f_qemu_install
f_mount_sysroot
f_umount_sysroot
f_qemu_uninstall

exit 0

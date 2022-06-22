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
func_chmod 777 dev home media mnt opt tmp root snap

# 创建文件夹
#func_mkdir 777 proc sys dev/pts

################################################################

#Rootfs=rootfs_ubuntu_20.04_${Time_launch}.tar.bz2
Rootfs=${DIR_base_rootfs##*/}_${Time_launch}.tar.bz2

func_echo "打包系统: ${Rootfs}"

# func_execute_sudo tar -cjf ${Rootfs} --exclude=${Zcq_Create_rootfs##*/} *
func_execute_sudo tar -cjf ${Rootfs} --exclude=$(basename ${Zcq_Create_rootfs}) *

func_chmod 777 ${Rootfs}

################################################################

# 安装打包工具 make_ext4fs
# sudo apt install -fy android-tools-adb android-tools-fastboot android-tools-mkbootimg
# sudo apt install -fy android-sdk-libsparse-utils android-sdk-ext4-utils android-sdk-platform-tools

#${RootPath}/build_system.img.sh
# 314572800 = 300 *1024 *1024
# make_ext4fs -s -l 314572800 -a root -L linux system.img ${InstallPath}
# sudo chmod -R 777 system.img
# make_ext4fs -s -l 314572800 -a root -L linux $(basename ${InstallPath}).img ${InstallPath}
# sudo chmod -R 777 $(basename ${InstallPath}).img

#tar -cjf $(basename ${InstallPath}).tar.bz2 ${InstallPath} # 适用 迅为 IMX6ULL 最小 linux 系统镜像
#sudo chmod -R 777 $(basename ${InstallPath}).tar.bz2

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

exit 0

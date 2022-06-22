#! /bin/bash

# ./0_auto_select.sh ${DIR_base_rootfs}

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

############################ 修改 ###############################

# 根文件系统 base rootfs 绝对路径
# DIR_base_rootfs=/.../sysroot_ubuntu_base

############################ 修改 ###############################

f_set_val() {
	# 工具链路径
	ToolchainPath=/opt/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf

	# linux 拷贝路径
	ToolchainPathArm=${ToolchainPath}/arm-none-linux-gnueabihf
}

f_setval_1() {
	# dns 域名服务器
	Resolv_conf=${Zcq_Create_rootfs}/file_etc/resolv.conf

	# 修改软件源
	Sources_list=${Zcq_Create_rootfs}/file_etc/ubuntu-20.04_ARM_sources.list
}

f_setval_3() {
	# 配置串口终端
	Getty_ttymxc=getty\@ttymxc0.service # 正点原子 i.mx
	Getty_ttySAC=getty\@ttySAC2.service # iTOP4412
	# Getty_tty=getty\@tty.service

	# 开机自动启动脚本设置
	Rc_local=${Zcq_Create_rootfs}/file_etc/rc.local.sh
	Rc_local_service=${Zcq_Create_rootfs}/file_etc/rc-local.service

	# 配置网络接口
	Interfaces=${Zcq_Create_rootfs}/file_etc/interfaces

	# Busybox=${Zcq_Create_rootfs}/file_bin/busybox
	# apt install -fy busybox

	# 字库目录
	Fonts_add=${Zcq_Create_rootfs}/fonts
}

f_setval_4() {
	# 环境变量
	Profile=${Zcq_Create_rootfs}/file_etc/profile_ubuntu.sh

	# 移植 视频播放软件 mplayer
	MPlayer=${Zcq_Create_rootfs}/file_bin/mplayer

	###### copy ######

	Systen_set_store=${Zcq_Create_rootfs}/system_set_store
	Modules_ko=${Zcq_Create_rootfs}/modules
	File_sh=${Zcq_Create_rootfs}/file_sh

	Code_test_c_cpp=${Zcq_Create_rootfs}/code_test_c_cpp
	Code_test_qt=${Zcq_Create_rootfs}/code_test_qt

	###### opt ######

	Opt_images=${Zcq_Create_rootfs}/file_opt/images # 相册图片
	Opt_music=${Zcq_Create_rootfs}/file_opt/music   # 音乐
	Opt_video=${Zcq_Create_rootfs}/file_opt/video   # 视频

	Opt_arm_qt=${Zcq_Create_rootfs}/file_opt/arm_qt       # qt 库
	Opt_arm_tslib=${Zcq_Create_rootfs}/file_opt/arm_tslib # 触摸库

	# 音频以及 ALSA 驱动框架
	# Opt_arm_alsa=${Zcq_Create_rootfs}/file_opt/arm_alsa

	# 视频播放软件 mplayer 用到 库
	# Opt_arm_zlib=${Zcq_Create_rootfs}/file_opt/arm_zlib
	# Opt_arm_libmad=${Zcq_Create_rootfs}/file_opt/arm_libmad

	# 移植 视频播放软件 mplayer
	# Opt_arm_MPlayer=${Zcq_Create_rootfs}/file_opt/arm_MPlayer

	if true; then
		#	if false; then
		# 排除的文件夹
		f_exclude_files ${Zcq_Create_rootfs}
		f_exclude_files ${DIR_base_rootfs}/system_set_store
		f_exclude_files ${DIR_base_rootfs}/code_test_c_cpp
		f_exclude_files ${DIR_base_rootfs}/code_test_qt
		f_exclude_files ${DIR_base_rootfs}/modules
		f_exclude_files ${DIR_base_rootfs}/file_sh

		# 将 根文件系统 sysroot 目录下所有的 符号链接 进行 "绝对->相对" 转换
		Link_abs_rel="${Zcq_Create_rootfs}/file_sh/link_absolute_relative_conversion.sh ${DIR_base_rootfs} ${Val_exclude_files[*]}"
	else
		Link_abs_rel="${Zcq_Create_rootfs}/file_py/link_abs_to_rel.py ${DIR_base_rootfs}"
	fi
}

# 排除的文件夹
declare -a Val_exclude_files
declare -i Val_num_i
Val_num_i=0
f_exclude_files() {
	while [ $# -gt 0 ]; do
		#		case $1 in
		#			--help | -h)
		#				shift
		#				;;
		#			*)
		#				shift
		#				;;
		#		esac
		Val_exclude_files[${Val_num_i}]="$1"
		let '++Val_num_i'
		shift
	done
}
# echo ${#Val_exclude_files[@]} # 数组个数

################################################################

if [ -z "${Zcq_Create_rootfs}" ]; then
	Zcq_Create_rootfs=
	exit 111
fi
func_path_isexit "Zcq_Create_rootfs" ${Zcq_Create_rootfs}

f_DIR_base_rootfs() {
	# bin boot dev etc home lib media mnt opt proc
	# root run sbin srv sys tmp usr var
	local Ubuntu_sys_file="etc usr"

	# 根文件系统 base rootfs 绝对路径
	if [ -z "${DIR_base_rootfs}" ]; then
		DIR_base_rootfs=$(dirname ${Zcq_Create_rootfs})
		if [ ${DIR_base_rootfs} == "/" ]; then
			#			if [ -b /dev/sda ]; then
			#				func_echo -e "ubuntu system rootfs"
			#				exit 81
			#			fi
			for tmp in ${Ubuntu_sys_file}; do
				if [ ! -d /${tmp} ]; then
					func_echo -e "no exit : /${tmp}"
					exit 82
				fi
			done
		else
			for tmp in ${Ubuntu_sys_file}; do
				if [ -d ${DIR_base_rootfs}/${tmp} ]; then
					return
				else
					func_echo -e "no exit : ${DIR_base_rootfs}/${tmp}"
				fi
			done
			DIR_base_rootfs=${DIR_base_rootfs}/sysroot_ubuntu_base
			for tmp in ${Ubuntu_sys_file}; do
				if [ ! -d ${DIR_base_rootfs}/${tmp} ]; then
					func_echo -e "no exit : ${DIR_base_rootfs}/${tmp}"
					exit 83
				fi
			done
		fi
	fi
}

f_DIR_base_rootfs
func_path_isexit "根文件系统 DIR_base_rootfs" ${DIR_base_rootfs}

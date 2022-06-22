#! /bin/bash

# 移植 mplayer 这个强大的视频播放软件
# 视频播放软件 mplayer 用到了 zlib 库, 因此要先移植 zlib 库

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

############################ 修改 ###############################

if true; then
	# if false; then
	# 工具链路径
	TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	# TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	# TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-10.2.1-2021.02-x86_64_arm-linux-gnueabihf
	func_chmod 777 ${TOOLCHAIN}
	export PATH=$PATH:${TOOLCHAIN}/bin
fi

gnueabihf=arm-linux-gnueabihf
# gnueabihf=arm-none-linux-gnueabihf

Opt_arm_zlib=/opt/arm_zlib # 编译输出路径
# Opt_arm_MPlayer=/opt/arm_MPlayer

################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${Opt_arm_zlib}
func_mkdir 777 ${Opt_arm_zlib}

Dir_prefix=${Opt_arm_zlib} # `make install' 编译结果
# Dir_config=${Opt_arm_zlib}/config # 编译出来的配置文件存放位置

func_mkdir 777 ${Dir_prefix}
# func_mkdir 777 ${Dir_config}

################################################################

function Distclean() {
	if [ -f "Makefile" ]; then
		echo -e "\033[1;36m read 1: make distclean \e[0m"
		local _enter=1
		#		read _enter
		if [ "${_enter}" = "1" ]; then
			#	make ARCH=arm CROSS_COMPILE=${gnueabihf}- distclean # 驱动开发，不清理
			make distclean
		fi
	fi
}
Distclean

#export CHOST=/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
export CHOST=${gnueabihf} # 在 configure 中为 编译平台
# export CC=${CHOST}-gcc
# export LD=${CHOST}-ld
# export AD=${CHOST}-as

func_execute ./configure \
	--prefix=${Dir_prefix}

#./configure \
#	CC=arm-linux-gnueabihf-gcc \
#	LD=arm-linux-gnueabihf-ld \
#	AD=arm-linux-gnueabihf-as \
#	--prefix=${Dir_prefix}
# --prefix=编译输出路径

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute make install # 安装 编译结果

################################################################

func_touch 777 ${Dir_prefix}/"安装_编译_结果"

func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_zlib}

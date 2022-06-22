#! /bin/bash

# 移植 mplayer 这个强大的视频播放软件
# 视频播放软件 mplayer 用到了 zlib, alsa-lib, libmad 库, 因此要先移植  库

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

# Opt_arm_MPlayer=/opt/arm_MPlayer
Opt_arm_libmad=/opt/arm_libmad # 编译输出路径

################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${Opt_arm_libmad}
func_mkdir 777 ${Opt_arm_libmad}

Dir_prefix=${Opt_arm_libmad}/prefix # `make install' 编译结果
# Dir_config=${Opt_arm_libmad}/config # 编译出来的配置文件存放位置

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

#CHOST=/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
CHOST=${gnueabihf} # 在 configure 中为 编译平台
CC=${CHOST}-gcc
#AS=arm-linux-gnueabihf-as
#AR=arm-linux-gnueabihf-ar

func_echo "生成 Makefile，以编译源码"

func_execute ./configure \
	--host=${CHOST} \
	--prefix=${Dir_prefix} \
	--disable-debugging \
	--enable-static \
	--enable-shared \
	--enable-speed \
	--enable-fpm=arm

# --prefix=编译输出路径

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

# 可能的报错, 去掉 Makefile 中的 -fforce-mem
# CFLAGS = -Wall -O -fforce-mem -fforce-addr -fthread-jumps -fcse-follow-jumps -fcse-skip-blocks -fexpensive-optimizations -fregmove -fschedule-insns2 -fstrength-reduce -fomit-frame-pointer
${Sudo} sed -i -E -e "s/^CFLAGS = -Wall -O -fforce-mem/CFLAGS = -Wall -O/" Makefile

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute make install # 安装 编译结果

################################################################

func_touch 777 ${Dir_prefix}/"安装_编译_结果"

func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_libmad}

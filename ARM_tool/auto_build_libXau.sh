#! /bin/bash

# Xauth
#  xcb依赖xcb-proto和Xauth，而Xauth则依赖xorgproto，因此编译顺序应为xcb-proto->xorgproto->Xauth->xorgproto。

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

Opt_arm_libXau=/opt/arm_libXau # 编译输出路径

func_execute_sudo rm -rf ${Opt_arm_libXau}
func_mkdir 777 ${Opt_arm_libXau}

Opt_arm_xcb_proto=/opt/arm_xcb-proto
func_path_isexit "Opt_arm_xcb_proto" ${Opt_arm_xcb_proto}

Opt_arm_xorgproto=/opt/arm_xorgproto
func_path_isexit "arm_xorgproto" ${Opt_arm_xorgproto}

func_chmod 777 ${RootPath}

################################################################################

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

func_echo "生成 Makefile，以编译源码"

func_execute ./configure \
	--host=${gnueabihf} \
	--prefix=${Opt_arm_libXau} \
	--enable-option-checking \
	CFLAGS=-I${Opt_arm_xorgproto}/include \
	CPPFLAGS=-I${Opt_arm_xorgproto}/include \
	LDFLAGS=-L${Opt_arm_xcb_proto}/lib

func_chmod 777 ${RootPath}

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute make install # 安装_编译_结果

func_chmod 777 ${RootPath}

func_chmod 777 ${Opt_arm_libXau}

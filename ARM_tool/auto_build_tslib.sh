#! /bin/bash

# qt5 用到了 tslib 库, 因此要先移植 库

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

############################ 修改 ###############################

if true; then
	# if false; then
	# 工具链路径
	TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	func_chmod 777 ${TOOLCHAIN}
	export PATH=$PATH:${TOOLCHAIN}/bin
fi

gnueabihf=arm-linux-gnueabihf
# gnueabihf=arm-none-linux-gnueabihf

# opt_arm_qt=/opt/arm_qt
opt_arm_tslib=/opt/arm_tslib # 编译输出路径

#####################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${opt_arm_tslib}
func_mkdir 777 ${opt_arm_tslib}

Dir_prefix=${opt_arm_tslib} # `make install' 编译结果
# Dir_prefix=${opt_arm_tslib}/prefix # `make install' 编译结果
# Dir_config=${opt_arm_tslib}/config # 编译出来的配置文件存放位置

func_mkdir 777 ${Dir_prefix}
# func_mkdir 777 ${Dir_config}

################################################################

if [ ! -e /usr/bin/autoreconf ]; then
	#生成 Makefile，还需要安装以下软件。
	func_apt -i autoconf automake libtool pkg-config m4 autogen
fi
autoreconf -f -i -I ${RootPath}/m4

################################################################

function Distclean() {
	if [ -f "Makefile" ]; then
		echo -e "\033[1;36m read 1: make distclean \e[0m"
		local _enter=1
		#		read _enter
		if [ "${_enter}" = "1" ]; then
			#	make ARCH=arm CROSS_COMPILE=${gnueabihf}- distclean # 驱动开发，不清理
			func_execute make distclean
			rm -f Makefile &>>/dev/null
		fi
	fi
}
Distclean

#CHOST=/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
CHOST=${gnueabihf} # 在 configure 中为 编译平台
# CC=${CHOST}-gcc
# CXX=${CHOST}-g++

func_echo "生成 Makefile，以编译源码"

./configure \
	--host=${CHOST} \
	ac_cv_func_malloc_0_nonnull=yes \
	--prefix=${opt_arm_tslib} \
	--cache-file=arm-linux.cache

# --prefix=编译输出路径

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat < /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute make install # 安装 编译结果

#####################################################################
# if true; then
if false; then
	echo -e "\033[36;41m -------------------------------------------------------------
 修改如 module_raw input
 注意前面不能有空格
 sudo gedit ${opt_arm_tslib}/etc/ts.conf  \e[0m"
	gedit ${opt_arm_tslib}/etc/ts.conf &>>/dev/null
fi
#####################################################################

func_touch 777 ${Dir_prefix}/"安装_编译_结果"

#func_chmod 777 ${RootPath}
func_chmod 777 ${opt_arm_tslib}

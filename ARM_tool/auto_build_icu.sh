#! /bin/bash

# 音频以及 ALSA 驱动框架

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

############################ 修改 ###############################

if true; then
	# if false; then
	# 工具链路径
	# TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-10.2.1-2021.02-x86_64_arm-linux-gnueabihf
	func_chmod 777 ${TOOLCHAIN}
	export PATH=$PATH:${TOOLCHAIN}/bin
fi

# ubunut_20.04 方式 工具链
if false; then
	func_apt -i *-9-arm-linux-gnueabihf
	func_apt -i *-9-multilib-arm-linux-gnueabihf
	func_apt -i *-9-dev-armhf-cross

	func_apt -i pkg-config-arm-linux-gnueabihf
	func_apt -i binutils-arm-linux-gnueabihf*

	func_chmod 777 /usr/bin/arm-linux-gnueabihf*
	func_chmod 777 /usr/arm-linux-gnueabihf
	func_chmod 777 /usr/lib/arm-linux-gnueabihf

	f_lnsf_9() {
		func_cd /usr/bin/
		# ln -sf file ~/桌面/ # -s 软连接; -r 递归目录 ; -f 强制
		while [ $# -gt 0 ]; do
			func_execute_sudo ln -sf arm-linux-gnueabihf-${1}-9 arm-linux-gnueabihf-${1}
			shift
		done
		func_cd -
	}
	f_lnsf_9 cpp g++ gcc gcc-ar gccgo gcc-nm gcc-ranlib gcov gcov-dump gcov-tool
	f_lnsf_9 gdc gfortran gm2
	f_lnsf_9 gnat gnatbind gnatchop gnatclean gnatfind gnathtml gnatkr
	f_lnsf_9 gnatlink gnatls gnatmake gnatname gnatprep gnatxref
fi

gnueabihf=arm-linux-gnueabihf
# gnueabihf=arm-none-linux-gnueabihf

Opt_arm_icu=/opt/arm_icu # 编译输出路径

################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${Opt_arm_icu}
func_mkdir 777 ${Opt_arm_icu}

################################################################

#CHOST=/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
CHOST=${gnueabihf} # 在 configure 中为 编译平台
export CC=${CHOST}-gcc
export CXX=${CHOST}-g++
export CPP=${CHOST}-cpp
#AS=arm-linux-gnueabihf-as
export AR=${CHOST}-ar
#NM=arm-linux-gnueabihf-nm
#RANLIB=arm-linux-gnueabihf-ranlib

#根目录（便于使用） buildroot_sysroot
export CROSS_ROOT=/media/zcq/system

#pkg路径
export PKG_CONFIG_PATH=${CROSS_ROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${CROSS_ROOT}/usr/share/pkgconfig

################################################################

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

################################################################
func_cd ${RootPath}/source

sed -i -e 's/\r$//' runConfigureICU
sed -i -e 's/\r$//' configure

func_echo "预交叉编译处理"

./runConfigureICU -h Linux/gcc 

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_echo "生成 Makefile，以编译源码"

func_execute ./configure \
	--host=${gnueabihf} \
	CXXFLAGS=-std=c++11 \
	--with-sysroot=${CROSS_ROOT} \
	--with-cross-build=${Dir_Build} \
	--disable-samples \
	--disable-tests \
	--prefix=${Opt_arm_icu}
# --prefix=${CROSS_ROOT}/usr

# --prefix=编译输出路径

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute make install # 安装_编译_结果

################################################################

func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_icu}

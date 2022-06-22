#! /bin/bash

# 音频以及 ALSA 驱动框架

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

Opt_arm_alsa_lib=/opt/arm_alsa # 编译输出路径
# Opt_arm_alsa_utils=/opt/arm_alsa_utils

################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${Opt_arm_alsa_lib}
func_mkdir 777 ${Opt_arm_alsa_lib}

# Installation directories:
# 	--prefix=PREFIX        install architecture-independent files in PREFIX
#                          [$ac_default_prefix]; `make install'
#	--exec-prefix=EPREFIX  install architecture-dependent files in EPREFIX
#                          [PREFIX]
Dir_alsa_prefix=${Opt_arm_alsa_lib} # `make install' 编译结果
# Dir_alsa_prefix=${Opt_arm_alsa_lib}/prefix # `make install' 编译结果
#Dir_alsa_prefix_exec=${Opt_arm_alsa_lib}/prefix_exec

# Optional Packages
# 	--with-configdir=dir path where ALSA config files are stored
# 	--with-plugindir=dir path where ALSA plugin files are stored
# 	--with-pkgconfdir=dir path where pkgconfig files are stored
Dir_alsa_config=${Opt_arm_alsa_lib}/config # 编译出来的配置文件存放位置
#Dir_alsa_config=${Dir_alsa_prefix}/share/alsa-arm # 编译出来的配置文件存放位置
#Dir_alsa_plugin=${Opt_arm_alsa_lib}/plugin
#Dir_alsa_pkgconfig=${Opt_arm_alsa_lib}/pkgconfig

func_mkdir 777 ${Dir_alsa_prefix}
#func_mkdir 777 ${Dir_alsa_prefix_exec}
func_mkdir 777 ${Dir_alsa_config}
#func_mkdir 777 ${Dir_alsa_plugin}
#func_mkdir 777 ${Dir_alsa_pkgconfig}

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

func_echo "生成 Makefile，以编译源码"

func_execute ./configure \
	--host=${gnueabihf} \
	--prefix=${Dir_alsa_prefix} \
	--with-configdir=${Dir_alsa_config}

# --disable-python
# --prefix=编译输出路径

#关于配置参数的2点说明：
#(1)  如果需要自定义 include/config.h 中 ALSA_CONFIG_DIR 的值，
# 可通过参数 --with-configdir 指定，即 alsa.conf 文件安装路径，
# 默认值是 --prefix 下的 /share/alsa
#(2)  如果需要自定义 include/config.h 中 ALSA_PLUGIN_DIR 的值，
# 可通过参数 --with-plugindir 指定，即 smixer 的安装路径，
# 默认值是--prefix 下的 /lib/alsa-lib/
# 建议：
# 配置时最好用 --with-configdir 指定好 alsa.conf 文件安装路径，
# 不要让它在默认的输出路径中。这样方便在编译移植以后不会污染板子上的文件系统

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute make install # 安装_编译_结果

################################################################

func_echo "
# 开发板根文件系统中的 /etc/profile 文件内容
# ALSA_CONFIG_PATH 用于指定 alsa 的配置文件，这个配置文件是 alsa-lib 编译出来的
# export ALSA_CONFIG_PATH=/usr/share/arm-alsa/alsa.conf
export ALSA_CONFIG_PATH=${Dir_alsa_config}/alsa.conf"

echo "
alsa-lib 移植
注意 alsa-lib 编译过程中会生成一些配置文件，而这些配置信息的路径都是绝对路径，
因此为了保证 ubuntu 和开发板根文件系统中的路径一致！
我们需要在 ubuntu 和开发板中各创建一个路径和名字完全一样的目录
由于 alsa-utils 要用到 alsa-lib 库，因此要先编译 alsa-lib 库
alsa-utils 是 ALSA 的一些小工具集合，我们可以通过这些小工具还测试我们的声卡
" >${Opt_arm_alsa_lib}/"alsa-lib说明.txt"

func_touch 777 ${Dir_alsa_prefix}/"安装_编译_结果"
func_touch 777 ${Dir_alsa_config}/"编译_配置文件"

################################################################

func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_alsa_lib}

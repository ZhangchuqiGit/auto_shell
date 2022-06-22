#! /bin/bash

# qt5 移植
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

#只要shell脚本中发生错误，即命令返回值不等于0，则停止执行并退出shell
# set -e
#不存在的变量则报错并停止执行shell
# set -u

func_chmod 777 ${RootPath}
func_echo_loop "嵌入式 Arm 平台交叉编译 Qt5 源代码"

###################### modify ######################
# 安装 依赖项 工具
#if true; then
if false; then
	if [ -f ../install_qt5_lib.sh ]; then
		../install_qt5_lib.sh
	fi
	func_cd ${RootPath}
fi

###################### modify ######################
#opt_arm_tslib=/opt/arm_tslib
#func_path_isexit "opt_arm_tslib" ${opt_arm_tslib}

#Opt_arm_alsa_lib=/opt/arm_alsa
#func_path_isexit "Opt_arm_alsa_lib" ${Opt_arm_alsa_lib}

#Opt_arm_zlib=/opt/arm_zlib
#func_path_isexit "Opt_arm_zlib" ${Opt_arm_zlib}

#Opt_arm_lib=/opt/arm_lib
#func_path_isexit "Opt_arm_lib" ${Opt_arm_lib}

###################### modify ######################
# 配置文件(修改)
source_code_compile=../qtbase

func_path_isexit "source_code_compile" ${source_code_compile}
func_cpf ${source_code_compile} ${RootPath}/

###################### modify ######################

if true; then
	# if false; then
	# 工具链路径
	#	TOOLCHAIN=/opt/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf
	TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	func_chmod 777 ${TOOLCHAIN}
	export PATH=$PATH:${TOOLCHAIN}/bin
fi

#gnueabihf=arm-linux-gnueabihf
#gnueabihf=arm-none-linux-gnueabihf

Dir_sysroot=/home/zcq/arm_rootfs/sysroot_ubuntu_base
Opt_arm_qt=/opt/arm_qt_webengine # 编译输出路径

func_execute_sudo rm -rf "${Dir_sysroot}${Opt_arm_qt}"
# func_mkdir 777 ${Opt_arm_qt}

################################################################
function Distclean() {
	if [ -f Makefile ]; then
		echo -e "\033[1;36m read 1: make distclean \e[0m"
		local _enter=1
		#		read _enter
		if [ "${_enter}" = "1" ]; then
			#	make ARCH=arm CROSS_COMPILE=${CROSS_COMPILE} distclean # 驱动开发，不清理
			func_execute make distclean
			# rm -f Makefile &>>/dev/null
		fi
	fi
}
Distclean

################################################################
Dir_Build=${RootPath}/zcq_build
func_execute_sudo rm -rf ${Dir_Build}
func_mkdir 777 ${Dir_Build}

func_cd ${Dir_Build}

################################################################

Val_configure=""
# Val_num=0
f_add_val() {
	# while [ $# -gt 0 ]; do
	# 	Val_configure="${Val_configure} $1 "
	# 	let 'Val_num++'
	# done
	Val_configure="${Val_configure} $* "
	# Val_num=$((${Val_num} + $#))
	# func_echo "Val_configure=${Val_configure}"
	# func_echo "$#;${Val_num}"
}

# “auto"是"yes"和"no"的简写,代表[yes/no]

# -sysroot 指定 sysroot，需要全路径
# -xplatform 指定交叉编译使用的mkspecs

if true; then
	# if false; then

	# Top-level installation directories:
	f_add_val \
		-prefix ${Opt_arm_qt}
	# Configure meta:
	f_add_val \
		-recheck-all
	# Build options:
	f_add_val \
		-opensource \
		-confirm-license \
		-release \
		-strip \
		-shared \
		-optimized-qmake \
		-pch 
		# -no-sse2
		# --rpath=no

	f_add_val \
		-xplatform linux-arm-gnueabi-g++

	# Build environment:
	f_add_val \
		-sysroot ${Dir_sysroot}

	# Component selection:
	f_add_val \
		-skip qtpurchasing \
		-skip qtandroidextras \
		-make libs \
		-nomake examples \
		-nomake tests \
		-dbus-runtime
		# -nomake tools

	# Core options:
	f_add_val \
		--pcre=system \
		--zlib=system
	#		-I${Opt_arm_zlib}/include \
	#		-L${Opt_arm_zlib}/lib

	# Network options:
	f_add_val \
		-no-openssl

	# Gui, printing, widget options:
	f_add_val \
		-no-cups \
		--freetype=system \
		--harfbuzz=system \
		-opengl es2 \
		-fontconfig
	# -no-opengl
	# -xcb-xlib
	# -qpa xcb

	# Platform backends:
	f_add_val \
		-linuxfb \
		-egl \
		-eglfs
	# --xcb=qt

	f_add_val \
		-L${TOOLCHAIN}/lib \
		-I${TOOLCHAIN}/include

	# Input backends:
	f_add_val \
		-tslib
	#		-I${opt_arm_tslib}/include \
	#		-L${opt_arm_tslib}/lib
	# -xkbcommon

	# Image formats:
	f_add_val \
		-gif \
		-system-libpng \
		-system-libjpeg

	# Database options:
	f_add_val \
		-sql-sqlite \
		--sqlite=qt

	# Multimedia options:
	f_add_val \
		-alsa
	#		-I${Opt_arm_alsa_lib}/include \
	#		-L${Opt_arm_alsa_lib}/lib
	#		-no-pulseaudio

	if true; then
		#	if false; then
		# WebEngine options:
		f_add_val \
			-webengine-embedded-build \
			--webengine-icu=system \
			--webengine-ffmpeg=system \
			--webengine-opus=system \
			--webengine-webp=system \
			-webengine-proprietary-codecs \
			-webengine-pepper-plugins
		# -no-webengine-pulseaudio
	fi

#	f_add_val \
#		-I${Opt_arm_lib}/include \
#		-L${Opt_arm_lib}/lib

fi

func_echo "生成 Makefile，以编译源码"
func_echo "../configure -v ${Val_configure} &>>_zcq_configure_info.txt"

../configure -v ${Val_configure} &>>_zcq_configure_info.txt

################################################################
# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat </proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

################################################################
func_chmod 777 ${RootPath}

func_echo "compile all components"
func_echo "make -j${cpu_cores} &>>_zcq_make_info.txt # 编译"
make -j${cpu_cores} &>>_zcq_make_all_info.txt # 编译

################################################################
if false; then
	# if true; then
	func_echo "
	# if false; then
	# 编译完成以后打开 config.mak 文件，找到 \“INSTALLSTRIP = -s\”这一行，
	# 取消掉后面的\“-s\”，否则 \“make install\” 命令会失败！ "
	${Sudo} sed -i -E -e "s/^INSTALLSTRIP/#INSTALLSTRIP/" config.mak
	#	i 上面插入;		a 下面插入
	${Sudo} sed -i -E -e '/^#INSTALLSTRIP/ a INSTALLSTRIP = ' config.mak
fi

func_echo "make install -j${cpu_cores} &>>_zcq_make_install_info.txt # 安装 编译结果"
make install -j${cpu_cores} &>>_zcq_make_install_info.txt # 安装 编译结果

################################################################

func_chmod 777 ${Opt_arm_qt}

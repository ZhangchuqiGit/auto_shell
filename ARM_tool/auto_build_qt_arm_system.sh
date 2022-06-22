#! /bin/bash

# qt5 移植
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

func_chmod 777 ${RootPath}
func_echo_loop "嵌入式 Arm 平台交叉编译 Qt5 源代码"

#####################################################################

opt_arm_tslib=/opt/arm_tslib
func_path_isexit "opt_arm_tslib" ${opt_arm_tslib}

Opt_arm_alsa_lib=/opt/arm_alsa_lib
func_path_isexit "Opt_arm_alsa_lib" ${Opt_arm_alsa_lib}

Opt_arm_zlib=/opt/arm_zlib
func_path_isexit "Opt_arm_zlib" ${Opt_arm_zlib}

#####################################################################

# 工具链路径
# TOOLCHAIN=/opt/gcc-linaro-10.2.1-2021.02-x86_64_arm-linux-gnueabihf
TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
func_chmod 777 ${TOOLCHAIN}

# export CROSS_COMPILE=${TOOLCHAIN}/bin/arm-linux-gnueabihf-
export CROSS_COMPILE=arm-linux-gnueabihf-

# Build environment:
# -sysroot <dir> ....... Set <dir> as the target sysroot
# -sysroot /.../ubuntu_base_rootfs
Target_sysroot=

Opt_arm_qt=/opt/arm_qt # 编译输出路径

Opt_arm_qt=${Target_sysroot%/}${Opt_arm_qt}
func_execute_sudo rm -rf ${Opt_arm_qt}
func_mkdir 777 ${Opt_arm_qt}

#####################################################################

# 配置文件(修改)
source_code_compile=../auto_build_qt_5.12.9_imx6ull
func_path_isexit "source_code_compile" ${source_code_compile}

func_cpf ${source_code_compile}/\* ${RootPath}/

#####################################################################

if [ ! -z "${Target_sysroot}" ]; then
	unset LD_LIBRARY_PATH
	LD_LIBRARY_PATH=${Target_sysroot}/usr/lib
	LD_LIBRARY_PATH=${Target_sysroot}/usr/libexec:${LD_LIBRARY_PATH}
	LD_LIBRARY_PATH=${Target_sysroot}/usr/lib/arm-linux-gnueabihf:${LD_LIBRARY_PATH}
	export LD_LIBRARY_PATH
fi
func_echo "\$LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"

# PATH 环境变量保存着可执行文件可能存在的目录
# PATH=${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
if [ -z "${Target_sysroot}" ]; then
	PATH=${TOOLCHAIN}/bin:${PATH} # !!!!
	# PATH=${TOOLCHAIN}/arm-linux-gnueabihf/bin:${PATH}
	# PATH${TOOLCHAIN}/arm-linux-gnueabihf/libc/sbin:${PATH}
	# PATH=${TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/bin:${PATH}
	# PATH=${TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/sbin:${PATH}
else
	PATH=${PATH}:${Target_sysroot}/usr/bin/arm-linux-gnueabihf
	PATH=${PATH}:${Target_sysroot}/usr/local/sbin
	PATH=${PATH}:${Target_sysroot}/usr/local/bin
	PATH=${PATH}:${Target_sysroot}/usr/sbin
	PATH=${PATH}:${Target_sysroot}/usr/bin
	PATH=${PATH}:${Target_sysroot}/sbin
	PATH=${PATH}:${Target_sysroot}/bin
	# ${Target_sysroot}/usr/arm-linux-gnueabihf
	# ${Target_sysroot}/usr/lib/arm-linux-gnueabihf
fi
export PATH
func_echo "\$PATH=${PATH}"

if [ -z "${Target_sysroot}" ]; then
	PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig:/usr/share/pkgconfig
else
	PKG_CONFIG_LIBDIR=$Target_sysroot/usr/lib/pkgconfig:$Target_sysroot/usr/share/pkgconfig
fi
export PKG_CONFIG_LIBDIR
func_echo "\$PKG_CONFIG_LIBDIR=${PKG_CONFIG_LIBDIR}"

if [ ! -z "${Target_sysroot}" ]; then
	export PKG_CONFIG_SYSROOT_DIR=$Target_sysroot
fi

################################################################

Dir_Build=${RootPath}/zcq_build
func_execute_sudo rm -rf ${Dir_Build}
func_mkdir 777 ${Dir_Build}
func_cd ${Dir_Build}

################################################################

function Distclean() {
	if [ -f Makefile ]; then
		echo -e "\033[1;36m read 1: make distclean \e[0m"
		local _enter=1
		#		read _enter
		if [ "${_enter}" = "1" ]; then
			#	make ARCH=arm CROSS_COMPILE=${CROSS_COMPILE} distclean # 驱动开发，不清理
			func_execute_sudo make distclean
			# rm -f Makefile &>>/dev/null
		fi
	fi
}
Distclean

Val_configure=""
Val_num=0
f_add_val() {
	# while [ $# -gt 0 ]; do
	# 	Val_configure="${Val_configure} $1 "
	# 	let 'Val_num++'
	# done
	Val_configure="${Val_configure} $@ "
	Val_num=$((${Val_num} + $#))
	# func_echo "Val_configure=${Val_configure}"
	# func_echo "$#;${Val_num}"
}

################################################################
# configure bash for qt5.12.3
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma
# 选定 xcb（X11）支持等，也可以通过 -skip <qtmodule> 来忽略编译某些qt模块，本文默认编译全部

func_echo "生成 Makefile，以编译源码"
func_echo "${RootPath}/configure"

if true; then
	# if false; then

	# Top-level installation directories:
	f_add_val \
		-prefix ${Opt_arm_qt}
	# Build options:
	f_add_val \
		-opensource \
		-confirm-license \
		-release \
		-strip \
		-shared \
		-optimized-qmake \
		-pch

	if [ -z "${Target_sysroot}" ]; then
		f_add_val \
			-xplatform linux-arm-gnueabi-g++
	else
		f_add_val \
			-device linux-imx6-g++ \
			-device-option CROSS_COMPILE=${CROSS_COMPILE}
	fi

	# Build environment:
	# sysroot = arm_system_rootfs
	# f_add_val \
	# 	-pkg-config

	# if [ -z "${Target_sysroot}" ]; then
	# 	f_add_val \
	# 		-I ${TOOLCHAIN}/include \
	# 		-I ${TOOLCHAIN}/arm-linux-gnueabihf/include \
	# 		-I ${TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/include \
	# 		-L ${TOOLCHAIN}/lib \
	# 		-L ${TOOLCHAIN}/arm-linux-gnueabihf/lib \
	# 		-L ${TOOLCHAIN}/arm-linux-gnueabihf/libc/lib \
	# 		-L ${TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/lib \
	# 		else
	# 	f_add_val \
	# 		-sysroot ${Target_sysroot} \
	# 		-I ${Target_sysroot}/usr/include \
	# 		-L ${Target_sysroot}/usr/lib
	# fi

	# Component selection:
	f_add_val \
		-skip qtmacextras \
		-skip qtandroidextras \
		-make libs \
		-make examples \
		-make tools \
		-nomake tests \
		-dbus-runtime
	# Core options:
	f_add_val \
		-icu \
		--pcre=qt \
		--zlib=qt
	# -I${Opt_arm_zlib}/prefix/include \
	# -L${Opt_arm_zlib}/prefix/lib
	# Gui, printing, widget options:
	f_add_val \
		--freetype=qt \
		--harfbuzz=qt \
		-xcb-xlib \
		-no-opengl
	# -opengl es2
	# Platform backends:
	f_add_val \
		-linuxfb \
		--xcb=qt \
		-qpa xcb
	# Input backends:
	f_add_val \
		-tslib \
		-I${opt_arm_tslib}/include \
		-L${opt_arm_tslib}/lib
	# Image formats:
	f_add_val \
		-gif \
		-qt-libpng \
		-qt-libjpeg
	# Database options:
	f_add_val \
		-sql-sqlite \
		--sqlite=qt

	# Qt3D options:
	f_add_val \
		--assimp=qt

	# Multimedia options:
	f_add_val \
		-no-pulseaudio \
		-alsa \
		-I${Opt_arm_alsa_lib}/prefix/include \
		-L${Opt_arm_alsa_lib}/prefix/lib

	# WebEngine options:
	f_add_val \
		-no-webengine-pulseaudio \
		-webengine-embedded-build \
		--webengine-icu=qt \
		--webengine-ffmpeg=qt \
		--webengine-opus=qt \
		--webengine-webp=qt \
		-webengine-proprietary-codecs

	../configure -v ${Val_configure} &>>_zcq_configure_info.txt
fi
################################################################

func_chmod 777 ${RootPath}

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_chmod 777 ${RootPath}

func_echo "compile all components"
func_echo "make -j${cpu_cores} &>>_zcq_make_info.txt # 编译"

make -j${cpu_cores} &>>_zcq_make_all_info.txt # 编译

func_chmod 777 ${RootPath}

if false; then
	# if true; then
	func_echo "
	# if false; then
	# 编译完成以后打开 config.mak 文件，找到 “INSTALLSTRIP = -s”这一行，
	# 取消掉后面的“-s”，否则 “make install” 命令会失败！ "
	${Sudo} sed -i -E -e "s/^INSTALLSTRIP/#INSTALLSTRIP/" config.mak
	#	i 上面插入;		a 下面插入
	${Sudo} sed -i -E -e '/^#INSTALLSTRIP/ a INSTALLSTRIP = ' config.mak
fi

func_echo "make install -j${cpu_cores} &>>_zcq_make_install_info.txt # 安装 编译结果"

make install -j${cpu_cores} &>>_zcq_make_install_info.txt # 安装 编译结果

func_chmod 777 ${RootPath}
func_chmod 777 ${Target_sysroot%/}${Opt_arm_qt}

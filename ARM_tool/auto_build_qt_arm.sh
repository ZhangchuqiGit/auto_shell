#! /bin/bash

# qt5 移植
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

#只要shell脚本中发生错误，即命令返回值不等于0，则停止执行并退出shell
set -e
#不存在的变量则报错并停止执行shell
# set -u

func_chmod 777 ${RootPath}
func_echo_loop "嵌入式 Arm 平台交叉编译 Qt5 源代码"

###################### modify ######################
# 安装 依赖项 工具
# if true; then
if false; then
	func_apt -i qt5-default
	func_apt -i qt3d5-dev-tools
	func_apt -i qml qml-module-qtquick-xmllistmodel
	func_apt -i qml-module-qtquick-virtualkeyboard
	func_apt -i qml-module-qtquick-shapes qml-module-qtquick-privatewidgets
	func_apt -i qml-module-qtquick-dialogs qml-module-qt-labs-calendar
	func_apt -i libqt53dquickscene2d5 libqt53dquickrender5
	func_apt -i libqt53dquickinput5 libqt53dquickextras5
	func_apt -i libqt53dquickanimation5 libqt53dquick5
	func_apt -i qml-module-qtwebengine
	func_apt -i qml-module-qtwebchannel qml-module-qtmultimedia
	func_apt -i qml-module-qtaudioengine qtdeclarative5-dev
fi

###################### modify ######################
opt_arm_tslib=/opt/arm_tslib
func_path_isexit "opt_arm_tslib" ${opt_arm_tslib}

Opt_arm_alsa_lib=/opt/arm_alsa
func_path_isexit "Opt_arm_alsa_lib" ${Opt_arm_alsa_lib}

Opt_arm_zlib=/opt/arm_zlib
func_path_isexit "Opt_arm_zlib" ${Opt_arm_zlib}

#  xcb 依赖 xcb-proto 和 Xauth，而 Xauth 则依赖 xorgproto,
# 因此编译顺序应为 xcb-proto->xorgproto->Xauth->xorgproto

Dir_prefix_X11=/opt/arm_qt_X11
func_path_isexit "Dir_prefix_X11" ${Dir_prefix_X11}

Dir_prefix_XCB=/opt/arm_qt_XCB
func_path_isexit "Dir_prefix_XCB" ${Dir_prefix_XCB}

Dir_prefix_OPENGL=/opt/arm_qt_OPENGL
func_path_isexit "Dir_prefix_OPENGL" ${Dir_prefix_OPENGL}

Dir_prefix_Python=/opt/arm_qt_Python
func_path_isexit "Dir_prefix_Python" ${Dir_prefix_Python}

###################### modify ######################
# 配置文件(修改)
source_code_compile=../auto_build_qt_5.12.9_imx6ull

func_path_isexit "source_code_compile" ${source_code_compile}
func_cpf ${source_code_compile}/\* ${RootPath}/

###################### modify ######################
Opt_arm_qt=/opt/arm_qt # 编译输出路径

func_execute_sudo rm -rf ${Opt_arm_qt}
func_mkdir 777 ${Opt_arm_qt}

# rootfs: ubuntu base
Target_sysroot=/media/zcq/system

# 工具链路径
# TOOLCHAIN=/opt/gcc-linaro-10.2.1-2021.02-x86_64_arm-linux-gnueabihf
TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
func_chmod 777 ${TOOLCHAIN}
# export CROSS_COMPILE=${TOOLCHAIN}/bin/arm-linux-gnueabihf-
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm

#####################################################################
# PATH 环境变量保存着可执行文件可能存在的目录
# PATH=${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

PATH=${TOOLCHAIN}/bin:${PATH} # !!!!
# PATH=${TOOLCHAIN}/arm-linux-gnueabihf/bin:${PATH}
# PATH${TOOLCHAIN}/arm-linux-gnueabihf/libc/sbin:${PATH}
# PATH=${TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/bin:${PATH}
# PATH=${TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/sbin:${PATH}
# PATH=${Target_sysroot}/usr/bin:${PATH} # !!!!
export PATH
func_echo "\$PATH=${PATH}"

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
	Val_configure="${Val_configure} $@ "
	# Val_num=$((${Val_num} + $#))
	# func_echo "Val_configure=${Val_configure}"
	# func_echo "$#;${Val_num}"
}

# “auto"是"yes"和"no"的简写,代表[yes/no]

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
		-pch \
		-no-sse2
	# --rpath=no

	f_add_val \
		-xplatform linux-arm-gnueabi-g++

	# Component selection:
	f_add_val \
		-skip qt3d \
		-skip qtcanvas3d \
		-skip qtpurchasing \
		-skip qtandroidextras \
		-make libs \
		-nomake examples \
		-nomake tools \
		-nomake tests \
		-dbus-runtime
	# Core options:
	f_add_val \
		-icu \
		--pcre=qt \
		--zlib=qt
	# -I${Opt_arm_zlib}/include \
	# -L${Opt_arm_zlib}/lib

	# Network options:
	f_add_val \
		-no-openssl
	# Gui, printing, widget options:
	f_add_val \
		-no-cups \
		--freetype=qt \
		--harfbuzz=qt \
		-no-opengl \
		-xcb-xlib \
		-qpa xcb

	# Platform backends:
	f_add_val \
		-linuxfb \
		--xcb=qt

	f_add_val \
		-L${Dir_prefix_X11}/lib \
		-I${Dir_prefix_X11}/include \
		-L${Dir_prefix_XCB}/lib \
		-I${Dir_prefix_XCB}/include
		-L${Dir_prefix_OPENGL}/lib \
		-I${Dir_prefix_OPENGL}/include
		-L${Dir_prefix_Python}/lib \
		-I${Dir_prefix_Python}/include

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

	# Multimedia options:
	f_add_val \
		-no-pulseaudio \
		-alsa \
		-I${Opt_arm_alsa_lib}/include \
		-L${Opt_arm_alsa_lib}/lib

	# WebEngine options:
	f_add_val \
		-no-webengine-pulseaudio \
		-webengine-embedded-build \
		--webengine-icu=qt \
		--webengine-ffmpeg=qt \
		--webengine-opus=qt \
		--webengine-webp=qt \
		-webengine-proprietary-codecs

	# if [ -n ${Target_sysroot} ]; then
	# f_add_val \
	# -L ${Target_sysroot}/usr/lib/arm-linux-gnueabihf \
	# -I ${Target_sysroot}/usr/include
	# -L ${Target_sysroot}/usr/lib \
	# -I ${Target_sysroot}/usr/arm-linux-gnueabihf/include \
	# -L ${Target_sysroot}/usr/arm-linux-gnueabihf/lib
	# -I ${Target_sysroot}/usr/include/arm-linux-gnueabihf \
	# fi

fi
func_echo "生成 Makefile，以编译源码"
func_echo "../configure -v ${Val_configure} &>>_zcq_configure_info.txt"

../configure -v ${Val_configure} &>>_zcq_configure_info.txt
################################################################
# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"
################################################################
func_chmod 777 ${RootPath}

func_echo "compile all components"
func_echo "make -j${cpu_cores} &>>_zcq_make_info.txt # 编译"
make -j${cpu_cores} &>>_zcq_make_all_info.txt # 编译
################################################################
func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_qt}

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
################################################################

func_chmod 777 ${Opt_arm_qt}

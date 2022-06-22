#! /bin/bash

# qt5 用到了 tslib 库, 因此要先移植 库

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
	export PATH=$PATH:${TOOLCHAIN}/bin/
fi

CROSS_COMPILE=${TOOLCHAIN}/bin/arm-linux-gnueabihf-

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

opt_arm_qt=/opt/arm_qt_5.12.9 # 编译输出路径

opt_arm_tslib=/opt/arm_tslib
func_path_isexit "opt_arm_tslib" ${opt_arm_tslib}

Opt_arm_alsa_lib=/opt/arm_alsa_lib
func_path_isexit "Opt_arm_alsa_lib" ${Opt_arm_alsa_lib}

Opt_arm_zlib=/opt/arm_zlib
func_path_isexit "Opt_arm_zlib" ${Opt_arm_zlib}

#####################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${opt_arm_qt}
func_mkdir 777 ${opt_arm_qt}

################################################################
# if true; then
if false; then
	func_echo "qt5 编译环境涉及到依赖"
	func_apt -i libc6-dev-i386
	func_apt -i libc6-dev-armhf
	func_apt -i gcc-multilib g++-multilib
	func_apt -i python python2 python2-dev python2.7 python2.7-*
	func_apt -i linux-libc-dev:i386
	func_apt -i linux-libc-dev-armhf-cross
	func_apt -i qt5-default

	func_echo "Building QtWebengine"
	func_apt -i bison build-essential gperf flex python2 libasound2-dev libcups2-dev
	func_apt -i libdrm-dev libegl1-mesa-dev libnss3-dev libpci-dev libpulse-dev
	func_apt -i libudev-dev nodejs libxtst-dev gyp ninja-build

	func_echo "Installing additional dependencies on Ubuntu 20.04+"
	func_apt -i libssl-dev libxcursor-dev libxcomposite-dev libxdamage-dev
	func_apt -i libxrandr-dev libfontconfig1-dev libxss-dev libsrtp2-dev libwebp-dev
	func_apt -i libjsoncpp-dev libopus-dev libminizip-dev libavutil-dev
	func_apt -i libavformat-dev libavcodec-dev libevent-dev libvpx-dev libsnappy-dev
	func_apt -i libre2-dev libprotobuf-dev protobuf-compiler

	func_echo "在 Ubuntu 系统中编译安装 QtWebEngine 5.13.0 需要安装的依赖包"
	func_apt -i bison build-essential gperf flex ruby python libasound2-dev
	func_apt -i libbz2-dev libcap-dev libcups2-dev libdrm-dev libegl1-mesa-dev
	func_apt -i libgcrypt11-dev libnss3-dev libpci-dev libpulse-dev lilibudev-dev
	func_apt -i libxtst-dev gyp ninja-build

	func_echo "在 Ubuntu 18.04 系统中编译安装 QtWebEngine 5.13.0需要安装的依赖包"
	func_apt -i xcb* libxcb-* mesa-* dbus* libclang* libx11-* libxext* libxkbcommon*
	func_apt -i libXrender* libgcrypt* pciutils cups* libgudev1* libcap* libXcursor*
	func_apt -i fontconfig* pulseaudio* alsa* python-opengl gambas3-*-opengl
	func_apt -i freeglut* libglew-dev libglew2* at-spi2-* libdbus*
	func_apt -i libqt5multimedia5* libclipper* perl-*
fi

################################################################

if false; then
	func_echo "修改 qmake.conf
...
QT_QPA_DEFAULT_PLATFORM = linuxfb
QMAKE_CFLAGS += -O2 -march=armv7-a -mtune=cortex-a7 -mfpu=neon -mfloat-abi=hard
QMAKE_CXXFLAGS += -O2 -march=armv7-a -mtune=cortex-a7 -mfpu=neon -mfloat-abi=hard

# QMAKE_CFLAGS += -O2 -march=armv8-a -lts
# QMAKE_CXXFLAGS += -O2 -march=armv8-a -lts

# QMAKE_INCDIR += /opt/arm_tslib/include
# QMAKE_LIBDIR += /opt/arm_tslib/lib

include ...

QMAKE_CC = arm-linux-gnueabihf-gcc
QMAKE_CXX = arm-linux-gnueabihf-g++
QMAKE_LINK = arm-linux-gnueabihf-g++
QMAKE_LINK_SHLIB = arm-linux-gnueabihf-g++

QMAKE_AR = arm-linux-gnueabihf-ar cqs
QMAKE_OBJCOPY = arm-linux-gnueabihf-objcopy
QMAKE_NM = arm-linux-gnueabihf-nm -P
QMAKE_STRIP = arm-linux-gnueabihf-strip  "
fi

if [ -d ../auto_build_qt_5.12.9_imx6ull ]; then
	func_cpf ../auto_build_qt_5.12.9_imx6ull/\* ./
else
	func_gedit qtbase/mkspecs/linux-arm-gnueabi-g++/qmake.conf
fi

################################################################

Dir_Build=zcq_build
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
			#	make ARCH=arm CROSS_COMPILE=${gnueabihf}- distclean # 驱动开发，不清理
			func_execute_sudo make distclean
			# rm -f Makefile &>>/dev/null
		fi
	fi
}
Distclean

#CHOST=/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
CHOST=${gnueabihf} # 在 configure 中为 编译平台
CC=${CHOST}-gcc
#AS=${CHOST}-as
#AR=${CHOST}-ar
#NM=${CHOST}-nm
#RANLIB=${CHOST}-ranlib

func_echo "生成 Makefile，以编译源码"
func_echo "${RootPath}/configure"

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
	func_echo "$#;${Val_num}"
}

################################################################

# configure bash for qt5.12.3
# https://www.toradex.com/zh-cn/blog/qian-ru-shi-arm-ping-tai-jiao-cha-bian-yi-qt5-yuan-dai-ma
# 选定 xcb（X11）支持等，也可以通过 -skip <qtmodule> 来忽略编译某些qt模块，本文默认编译全部
if true; then
	# if false; then

	# Top-level installation directories:
	f_add_val \
		-prefix ${opt_arm_qt}

	# Build options:
	f_add_val \
		-opensource \
		-confirm-license \
		-release \
		-optimized-qmake \
		-strip \
		-shared \
		-device linux-imx6-g++ \
		-device-option CROSS_COMPILE=${CROSS_COMPILE} \
		--sse2=no \
		--rpath=no \
		-pch


		-sysroot ${SDKTARGETSYSROOT} \
		-I ${SDKTARGETSYSROOT}/usr/include \
		-L ${SDKTARGETSYSROOT}/usr/lib \
		-pkg-config -release -shared -make libs \
		-linuxfb -gstreamer -no-pulseaudio -no-webengine-pulseaudio \
		-xcb -xcb-xlib -no-eglfs \
		-qpa xcb \
		-nomake examples -nomake tests \
		-opengl es2

	${RootPath}/configure -v ${Val_configure} &>>_zcq_build_info.txt
fi
################################################################

# if true; then
if false; then

	# Top-level installation directories:
	f_add_val \
		-prefix ${opt_arm_qt}
	# Configure meta:
	f_add_val \
		-recheck-all
	# Build options:
	f_add_val \
		-opensource \
		-confirm-license \
		-release \
		-c++std c++11 \
		-xplatform linux-arm-gnueabi-g++ \
		-optimized-qmake \
		-strip \
		-shared \
		--sse2=no \
		--rpath=no \
		-pch
	# Build environment:
	# f_add_val \
	# 	-pkg-config
	# Component selection:
	f_add_val \
		-skip qt3d \
		-skip qtandroidextras \
		-skip qtcanvas3d \
		-skip qtdatavis3d \
		-skip qtpurchasing \
		-skip qtgamepad \
		-skip qtsensors \
		-skip qtwayland \
		-skip qtx11extras
	f_add_val \
		-make libs \
		-nomake examples \
		-nomake tools \
		-nomake tests \
		-gui \
		-widgets \
		-dbus \
		-dbus-runtime \
		-accessibility
	# Core options:
	f_add_val \
		-no-glib \
		--iconv=no \
		--pcre=qt \
		--zlib=system \
		-I${Opt_arm_zlib}/prefix/include \
		-L${Opt_arm_zlib}/prefix/lib
	# Network options:
	f_add_val \
		-no-openssl
	# Gui, printing, widget options:
	f_add_val \
		--freetype=qt \
		--harfbuzz=qt \
		-no-opengl
	# Platform backends:
	f_add_val \
		-linuxfb \
		--xcb=no
	# Input backends:
	f_add_val \
		-tslib \
		-I${opt_arm_tslib}/include \
		-L${opt_arm_tslib}/lib
	# Image formats:
	f_add_val \
		-gif \
		-ico \
		-qt-libpng \
		-qt-libjpeg
	# Database options:
	f_add_val \
		--sqlite=qt \
		-plugin-sql-sqlite

	f_add_val \
		-I${Opt_arm_alsa_lib}/prefix/include \
		-L${Opt_arm_alsa_lib}/prefix/lib \
		-L/media/zcq/system/usr/lib/arm-linux-gnueabihf
	-L/media/zcq/system/usr/lib
	# -I/usr/include/xcb \
	# -I/usr/include/cups

	# WebEngine options:
	f_add_val \
		--webengine-webp=qt \
		-webengine-embedded-build \
		--webengine-icu=qt \
		--webengine-ffmpeg=qt \
		--webengine-opus=qt \
		--webengine-webp=qt \
		-webengine-pepper-plugins \
		-webengine-proprietary-codecs \
		-webengine-webrtc

	${RootPath}/configure -v ${Val_configure} &>>_zcq_build_info.txt
fi
################################################################

# if true; then
if false; then
	./configure \
		-prefix ${opt_arm_qt} \
		-opensource \
		-confirm-license \
		-release \
		-strip \
		-shared \
		-xplatform linux-arm-gnueabi-g++ \
		-optimized-qmake \
		-c++std c++11 \
		--rpath=no \
		-pch \
		-skip qt3d \
		-skip qtactiveqt \
		-skip qtandroidextras \
		-skip qtcanvas3d \
		-skip qtconnectivity \
		-skip qtdatavis3d \
		-skip qtdoc \
		-skip qtgamepad \
		-skip qtlocation \
		-skip qtmacextras \
		-skip qtnetworkauth \
		-skip qtpurchasing \
		-skip qtremoteobjects \
		-skip qtscript \
		-skip qtscxml \
		-skip qtsensors \
		-skip qtspeech \
		-skip qtsvg \
		-skip qttools \
		-skip qttranslations \
		-skip qtwayland \
		-skip qtwebengine \
		-skip qtwebview \
		-skip qtwinextras \
		-skip qtx11extras \
		-skip qtxmlpatterns \
		-make libs \
		-make examples \
		-nomake tools -nomake tests \
		-gui \
		-widgets \
		-dbus-runtime \
		--glib=no \
		--iconv=no \
		--pcre=qt \
		--zlib=qt \
		-no-openssl \
		--freetype=qt \
		--harfbuzz=qt \
		-no-opengl \
		-linuxfb \
		--xcb=no \
		-tslib \
		--libpng=qt \
		--libjpeg=qt \
		--sqlite=qt \
		-plugin-sql-sqlite \
		-I${opt_arm_tslib}/include \
		-L${opt_arm_tslib}/lib \
		-recheck-all
fi
################################################################

# --prefix=编译输出路径
# -I tslib 头文件路径
# -L tslib 库文件路径

func_chmod 777 ${RootPath}

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_echo "make -j${cpu_cores} &>>_zcq_make_info.txt # 编译"
make -j${cpu_cores} &>>_zcq_make_info.txt # 编译

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

#####################################################################

func_chmod 777 ${RootPath}
func_chmod 777 ${opt_arm_qt}

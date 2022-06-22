#! /bin/bash

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

#只要shell脚本中发生错误，即命令返回值不等于0，则停止执行并退出shell
# set -e
#不存在的变量则报错并停止执行shell
# set -u

# 交叉编译 libxcb 与 X11
# https://blog.csdn.net/weixin_42892101/article/details/107852277

################################################################################
# 编译前提
# 前往官网 https://www.x.org/releases/individual/lib/ 找源码地址

###################### modify ######################
# 工具安装
if false; then
	# if true; then
	func_apt -i xsltproc pkg-config perl xmlto fop libxrandr-dev
	func_apt -i ninja-build meson gperf util-linux python3.8
fi
###################### modify ######################

# 建立下载地址列表
Val_list_web_dependencies="
https://download.savannah.gnu.org/releases/freetype/freetype-2.10.2.tar.gz
https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.gz
https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2
https://www.x.org/releases/individual/util/util-macros-1.19.3.tar.bz2
https://www.x.org/releases/individual/lib/libXdmcp-1.1.3.tar.gz
https://www.x.org/releases/individual/lib/pixman-0.40.0.tar.gz
https://www.x.org/releases/individual/proto/xorgproto-2020.1.tar.gz
https://www.x.org/releases/individual/xcb/xcb-util-image-0.3.9.tar.gz
https://www.x.org/releases/individual/xcb/xcb-util-keysyms-0.3.9.tar.gz
https://www.x.org/releases/individual/xcb/xcb-util-wm-0.3.9.tar.gz
https://www.x.org/releases/individual/xcb/xcb-util-renderutil-0.3.9.tar.gz
https://www.x.org/releases/individual/xcb/libxcb-1.13.tar.gz
https://www.x.org/releases/individual/xcb/xcb-proto-1.13.tar.gz
https://www.x.org/releases/individual/lib/libXau-1.0.9.tar.gz
https://www.x.org/releases/individual/xcb/xcb-util-0.3.9.tar.gz
https://www.x.org/releases/individual/data/xkeyboard-config/xkeyboard-config-2.30.tar.gz
https://xkbcommon.org/download/libxkbcommon-1.0.3.tar.xz
https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.gz
https://www.python.org/ftp/python/3.8.6/Python-3.8.6.tar.xz
http://xmlsoft.org/sources/libxml2-2.9.10.tar.gz
"

# Val_list_dependencies="
# freetype-2.11.1.tar.gz
# util-linux-2.38-rc1.tar.gz
# fontconfig-2.13.91.tar.gz "

# https://www.x.org/pub/individual/lib/
Val_list_tar="
xtrans-1.4.0.tar.bz2
libX11-1.6.9.tar.bz2
libXext-1.3.4.tar.bz2
libFS-1.0.8.tar.bz2
libICE-1.0.10.tar.bz2
libSM-1.2.3.tar.bz2
libXScrnSaver-1.2.3.tar.bz2
libXt-1.2.0.tar.bz2
libXmu-1.1.3.tar.bz2
libXpm-3.5.13.tar.bz2
libXaw-1.0.13.tar.bz2
libXfixes-5.0.3.tar.bz2
libXcomposite-0.4.5.tar.bz2
libXrender-0.9.10.tar.bz2
libXcursor-1.2.0.tar.bz2
libXdamage-1.1.5.tar.bz2
libfontenc-1.1.4.tar.bz2
libXfont2-2.0.4.tar.bz2
libXft-2.3.3.tar.bz2
libXi-1.7.10.tar.bz2
libXinerama-1.1.4.tar.bz2
libXrandr-1.5.2.tar.bz2
libXres-1.2.0.tar.bz2
libXtst-1.2.3.tar.bz2
libXv-1.0.11.tar.bz2
libXvMC-1.0.12.tar.bz2
libXxf86dga-1.1.5.tar.bz2
libXxf86vm-1.1.4.tar.bz2
libdmx-1.1.4.tar.bz2
libpciaccess-0.16.tar.bz2
libxkbfile-1.1.0.tar.bz2
libxshmfence-1.3.tar.bz2
"

Val_list_web_dependencies="$(echo "${Val_list_web_dependencies}" | grep -v '^#')"
Val_list_web_dependencies="$(echo "${Val_list_web_dependencies}" | grep -v '^$')"
Val_list_tar="$(echo "${Val_list_tar}" | grep -v '^#')"
Val_list_tar="$(echo "${Val_list_tar}" | grep -v '^$')"

Val_list_dependencies="${Val_list_web_dependencies##*/}"

###################### modify ######################

Val_download_dependencies_path=x11_xcb_lib_depend
Val_download_path=x11_xcb_lib
Val_debug_info_path=zcq_info_x11_xcb

################################################################################

Val_download_dependencies_path=${RootPath}/${Val_download_dependencies_path}
Val_download_path=${RootPath}/${Val_download_path}
Val_debug_info_path=${RootPath}/${Val_debug_info_path}

if [ ! -d "${Val_download_dependencies_path}" ]; then
	func_mkdir 777 ${Val_download_dependencies_path}
	func_cd ${Val_download_dependencies_path}
	echo "${Val_list_web_dependencies}" | wget -i- -c
fi

if [ ! -d "${Val_download_path}" ]; then
	func_mkdir 777 ${Val_download_path}
	func_cd ${Val_download_path}
	echo "${Val_list_tar}" | wget -i- -c -B https://www.x.org/pub/individual/lib/
fi

func_execute_sudo rm -rf ${Val_debug_info_path}
func_mkdir 777 ${Val_debug_info_path}

func_path_isexit "Val_download_dependencies_path=" ${Val_download_dependencies_path}
func_path_isexit "Val_download_path=" ${Val_download_path}
func_path_isexit "Val_debug_info_path=" ${Val_debug_info_path}

func_chmod 777 ${Val_download_dependencies_path}
func_chmod 777 ${Val_download_path}
func_chmod 777 ${Val_debug_info_path}

###################### modify ######################
func_cpf ${RootPath}/backup/\* ${Val_download_dependencies_path}/

f_remove_files() {
	if [ $# -ne 1 ]; then
		func_echo -e "f_remove_files: \$#=$# is != 1"
		exit 71
	fi
	func_cd $1
	remove_files="$(ls -1)"
	for i_file in ${remove_files}; do
		if [ -d ${i_file} ]; then
			func_execute_sudo rm -rf ${i_file}
		fi
	done
	func_cd -
}
f_remove_files ${Val_download_dependencies_path}
f_remove_files ${Val_download_path}

###################### modify ######################

if true; then
	# if false; then
	# 工具链路径
	# TOOLCHAIN=/opt/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf
	TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	func_chmod 777 ${TOOLCHAIN}
	export PATH=${TOOLCHAIN}/bin:$PATH
fi

gnueabihf=arm-linux-gnueabihf
# gnueabihf=arm-none-linux-gnueabihf

# 设置安装目录
# PREFIX_INSTALL=/opt/arm_qt___ # 编译输出路径
# func_execute_sudo rm -rf ${PREFIX_INSTALL}
# func_mkdir 777 ${PREFIX_INSTALL}

# XORG_PREFIX=${PREFIX_INSTALL}/prefix
# XORG_CONFIG=${PREFIX_INSTALL}/config

export ARCH=arm

# 配置交叉编译
export CC=${gnueabihf}-gcc
export CXX=${gnueabihf}-g++
# export CFLAGS="-I${XORG_PREFIX}/include -I${TOOLCHAIN}/include"
# export CPPFLAGS="${CFLAGS}"
# export LDFLAGS="-L${XORG_PREFIX}/lib -L${TOOLCHAIN}/lib"

################################################################################

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

################################################################################

f_add_val() {
	# Val_num=0
	Val_configure=""
	# while [ $# -gt 0 ]; do
	# 	Val_configure="${Val_configure} $1 "
	# 	let 'Val_num++'
	# done
	Val_configure="${Val_configure} $@ "
	# Val_num=$((${Val_num} + $#))
	# func_echo "Val_configure=${Val_configure}"
	# func_echo "$#;${Val_num}"
}

untar_file() {
	local tar_package="$1"
	local package_name=${tar_package%.tar.*}
	if [ "${package_name}" != "${tar_package}" ]; then
		if [ ! -e ${tar_package} ]; then
			func_echo -e "Error: ${tar_package} is not exits"
			exit 31
		fi
		func_execute_sudo rm -rf ${package_name}
		local pack_cmp=${tar_package#*.tar.}
		if [ "${pack_cmp}" == "bz2" ]; then
			func_execute_err tar -xjf $tar_package
		elif [ "${pack_cmp}" == "gz" ]; then
			func_execute_err tar -xzf $tar_package
		elif [ "${pack_cmp}" == "xz" ]; then
			func_execute_err tar -xJf $tar_package
		else
			func_echo -e "${tar_package}: is bz2 or gz ?"
			exit 13
		fi
	fi
	func_chmod 777 ${package_name}
}

Val_log_num=0

# 配置安装
do_make() {
	local package_name=""
	func_echo "do_make() ---- begin"
	for package in $@; do
		package_name=${package%.tar.*}
		func_echo_loop "${Val_log_num} ${package_name} ------------------------ prefix:${XORG_PREFIX}"
		if [ -d ${package_name} ]; then
			continue
		else
			untar_file ${package}
		fi

		func_cd ${package_name}

		# func_mkdir 777 zcq_build
		# func_cd zcq_build

		local docdir="--docdir=$XORG_PREFIX/share/doc/${package_name}"

		case $package_name in
		freetype-*)
			sed -i -E -e "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
			sed -i -E -e "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
				include/freetype/config/ftoption.h
			f_add_val \
				--enable-freetype-config \
				--disable-static
			;;
		fontconfig-*)
			#Make sure the system regenerates src/fcobjshash.h
			rm -rf src/fcobjshash.h
			f_add_val \
				--sysconfdir=/etc \
				--localstatedir=/var \
				--enable-libxml2 \
				--disable-docs
			;;
		util-linux-*)
			f_add_val \
				--enable-option-checking \
				--without-python \
				--without-tinfo \
				--without-ncursesw \
				--without-ncurses
			;;
			#--------------------------------
		libICE-[0-9]*)
			f_add_val \
				ICE_LIBS=-lpthread
			;;
		libXfont*)
			f_add_val \
				--disable-devel-docs
			;;
		libXt-[0-9]*)
			f_add_val \
				--with-appdefaultdir=/etc/X11/app-defaults \
				--enable-malloc0returnsnull
			;;
		libSM-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
			#--------------------------------
		xcb-proto-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		xtrans-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		xorgproto-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--enable-legacy
			;;
		libXau-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		libxcb-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		libX11-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--enable-unix-transport \
				--enable-tcp-transport \
				--enable-ipv6 \
				--enable-local-transport \
				--enable-malloc0returnsnull
			;;
			#--------------------------------
		util-macros-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		libXrender-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--enable-malloc0returnsnull
			;;
		libXext-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--enable-malloc0returnsnull
			;;
		libXrandr-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--enable-malloc0returnsnull
			;;
		xcb-util-renderutil-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		xcb-util-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		libXi-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--enable-malloc0returnsnull
			;;
		libXfixes-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		libXdmcp-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		pixman-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		libpciaccess-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		xcb-util-image-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		xcb-util-keysyms-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		xcb-util-wm-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
			#--------------------------------
		xkeyboard-config-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
			#--------------------------------
		libuuid-[0-9]*)
			f_add_val \
				--enable-option-checking
			;;
		expat-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--without-docbook
			;;
		libxml2-[0-9]*)
			f_add_val \
				--enable-option-checking \
				--with-history \
				--with-python=${Dir_prefix_Python}
			;;
		*)
			f_add_val \
				--enable-malloc0returnsnull
			;;
		esac

		local tmp_log_info=${Val_debug_info_path}/${Val_log_num}_${package_name}.log

		func_echo "./configure: ${package_name}"
		./configure \
			$docdir \
			--host=${gnueabihf} \
			--prefix=${XORG_PREFIX} \
			${Val_configure} &>>${tmp_log_info}
		# CFLAGS="${CFLAGS}" \
		# CPPFLAGS="${CFLAGS}" \
		# LDFLAGS="${LDFLAGS}" &>>${tmp_log_info}

		func_chmod 777 .

		# 编译
		echo -e "\n\n--------------------------------" &>>${tmp_log_info}
		if [ "${Sudo_flag_make}" == "true" ]; then
			func_echo -c "${Sudo} make -j${cpu_cores}"
			echo -e "----- ${Sudo} make -j${cpu_cores} ------\n" &>>${tmp_log_info}
			${Sudo} make -j${cpu_cores} &>>${tmp_log_info}
		else
			func_echo -c "make -j${cpu_cores}"
			echo -e "----- make -j${cpu_cores} ------\n" &>>${tmp_log_info}
			make -j${cpu_cores} &>>${tmp_log_info}
		fi

		func_chmod 777 .
		func_chmod 777 ${XORG_PREFIX}

		# 安装_编译_结果
		echo -e "\n\n--------------------------------" &>>${tmp_log_info}
		if [ "${Sudo_flag_make_install}" == "true" ]; then
			func_echo -c "${Sudo} make install"
			echo -e "----- ${Sudo} make install ------\n" &>>${tmp_log_info}
			${Sudo} make install &>>${tmp_log_info}
		else
			func_echo -c "make install"
			echo -e "----- make install ------\n" &>>${tmp_log_info}
			make install &>>${tmp_log_info}
		fi

		func_chmod 777 ${XORG_PREFIX}
		func_chmod 777 ${Val_debug_info_path}

		# /sbin/ldconfig 命令用于在默认搜寻目录 /lib 和 /usr/lib
		# 以及 动态库配置文件 /etc/ld.so.conf 内所列的目录下，
		# 搜索出可共享的动态链接库（格式如 lib*.so*），
		# 进而创建出动态链接器（ld.so 或 ld-linux.so）所需的缓存文件。
		# 缓存文件默认为 /etc/ld.so.cache,此文件保存已排好序的动态链接库名字列表。
		# 为了让动态链接库为系统所共享，需运行动态链接库的管理命令 ldconfig 更新动态链接库的缓存文件。
		# 通常在系统启动时运行，当用户安装了一个新的动态链接库时，需要手动运行这个命令。
		func_execute_sudo /sbin/ldconfig

		let 'Val_log_num++'
		func_cd -
	done
	Sudo_flag_make=false
	Sudo_flag_make_install=false
	func_echo "do_make() ---- end"
}

if false; then
	# 编译依赖项
	func_cd ${Val_download_dependencies_path}
	do_make ${Val_list_dependencies}

	# 编译主体
	func_cd ${Val_download_path}
	do_make ${Val_list_tar}
fi

###################### modify ######################
# 编译输出路径
Dir_prefix_X11=/opt/arm_qt_X11
Dir_prefix_XCB=/opt/arm_qt_XCB
Dir_prefix_OPENGL=/opt/arm_qt_OPENGL
Dir_prefix_Python=/opt/arm_qt_Python

func_execute_sudo rm -rf ${Dir_prefix_X11}
func_execute_sudo rm -rf ${Dir_prefix_XCB}
func_execute_sudo rm -rf ${Dir_prefix_OPENGL}
func_execute_sudo rm -rf ${Dir_prefix_Python}
func_mkdir 777 ${Dir_prefix_X11}
func_mkdir 777 ${Dir_prefix_X11}/include
func_mkdir 777 ${Dir_prefix_X11}/lib
func_mkdir 777 ${Dir_prefix_XCB}
func_mkdir 777 ${Dir_prefix_XCB}/include
func_mkdir 777 ${Dir_prefix_XCB}/lib
func_mkdir 777 ${Dir_prefix_OPENGL}
func_mkdir 777 ${Dir_prefix_OPENGL}/include
func_mkdir 777 ${Dir_prefix_OPENGL}/lib
func_mkdir 777 ${Dir_prefix_Python}
func_mkdir 777 ${Dir_prefix_Python}/include
func_mkdir 777 ${Dir_prefix_Python}/lib

# 配置交叉编译
export CFLAGS="-I${Dir_prefix_X11}/include -I${Dir_prefix_XCB}/include -I${Dir_prefix_OPENGL}/include -I${Dir_prefix_Python}/include -I${TOOLCHAIN}/include"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="-L${Dir_prefix_X11}/lib -L${Dir_prefix_XCB}/lib -L${Dir_prefix_OPENGL}/lib -L${Dir_prefix_Python}/lib -L${TOOLCHAIN}/lib"

###################### modify ######################

# func_echo "编译 X11"
# 出现问题：X11/Xtrans/Xtrans.h: No such file or directory
# 说明 X11 依赖 Xtrans
# 出现问题：X11/X.h: No such file or directory
# 说明 X11 依赖 xorgproto
# 出现问题：xcb/xcb.h: No such file or directory
# 说明 X11 依赖 xcb

#--------------------------------
XORG_PREFIX=${Dir_prefix_XCB} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}
do_make xcb-proto-1.13.tar.gz

# 添加环境
# sudo gedit ~/.bashrc
# 文件尾部加入
export PKG_CONFIG_PATH=${Dir_prefix_XCB}/lib/pkgconfig:${PKG_CONFIG_PATH}
# 保存退出
# source ~/.bashrc

#--------------------------------
XORG_PREFIX=${Dir_prefix_X11} # 编译输出路径 !!!

func_cd ${Val_download_path}
do_make xtrans-1.4.0.tar.bz2

func_cd ${Val_download_dependencies_path}
# Sudo_flag_make=true
Sudo_flag_make_install=true
do_make xorgproto-2020.1.tar.gz
do_make libXau-1.0.9.tar.gz
do_make libxcb-1.13.tar.gz

func_cd ${Val_download_path}
do_make libX11-1.6.9.tar.bz2

# xcb 依赖 xcb-proto 和 libXau, 而 libXau 则依赖 xorgproto,
# 因此编译顺序应为 xcb-proto->xorgproto->Xauth

#--------------------------------
XORG_PREFIX=${Dir_prefix_XCB} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}
do_make util-macros-1.19.3.tar.bz2

#--------------------------------
XORG_PREFIX=${Dir_prefix_X11} # 编译输出路径 !!!

func_cd ${Val_download_path}
do_make libXrender-0.9.10.tar.bz2
do_make libXext-1.3.4.tar.bz2
do_make libXrandr-1.5.2.tar.bz2

#--------------------------------
XORG_PREFIX=${Dir_prefix_XCB} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}
do_make xcb-util-renderutil-0.3.9.tar.gz
do_make xcb-util-0.3.9.tar.gz

#--------------------------------
XORG_PREFIX=${Dir_prefix_X11} # 编译输出路径 !!!

func_cd ${Val_download_path}
do_make libXfixes-5.0.3.tar.bz2
do_make libXi-1.7.10.tar.bz2

func_cd ${Val_download_dependencies_path}
do_make libXdmcp-1.1.3.tar.gz
do_make pixman-0.40.0.tar.gz

func_cd ${Val_download_path}
do_make libpciaccess-0.16.tar.bz2

func_cd ${Val_download_dependencies_path}
do_make xcb-util-image-0.3.9.tar.gz

#--------------------------------
XORG_PREFIX=${Dir_prefix_XCB} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}
do_make xcb-util-keysyms-0.3.9.tar.gz
do_make xcb-util-wm-0.3.9.tar.gz

#--------------------------------
XORG_PREFIX=${Dir_prefix_X11} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}
do_make xkeyboard-config-2.30.tar.gz

#--------------------------------
func_cd ${Val_download_dependencies_path}

func_echo "编译 xkbcommon"
untar_file libxkbcommon-1.0.3.tar.xz
func_cd libxkbcommon-1.0.3

echo "
[binaries]
c = '${TOOLCHAIN}/bin/${gnueabihf}-gcc'
cpp = '${TOOLCHAIN}/bin/${gnueabihf}-g++'
ar = '${TOOLCHAIN}/bin/${gnueabihf}-ar'
strip = '${TOOLCHAIN}/bin/${gnueabihf}-strip'
ld = '${TOOLCHAIN}/bin/${gnueabihf}-ld'
# pkgconfig = '${TOOLCHAIN}/bin/${gnueabihf}-pkg-config'

[host_machine]
system = 'linux'
cpu_family = 'arm'
cpu = 'ARM'
endian = 'little'

[build_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'amd64'
endian = 'little'
" >cross.txt
func_chmod 777 cross.txt

echo "#! /bin/bash
# 配置
meson setup zcq_build \\
	--prefix ${Dir_prefix_X11} \\
	--buildtype release \\
	--cross-file cross.txt \\
	-Denable-x11=false \\
	-Denable-wayland=false \\
	-Denable-docs=false \\
	--libdir ${Dir_prefix_X11}/lib
# 编译安装
ninja -C zcq_build install
" >cross.sh
func_chmod 777 cross.sh

./cross.sh &>>${Val_debug_info_path}/libxkbcommon-1.0.3.log
# QT源码端配置
# 配置项加上 -xkbcommon
# 配置项加上链接项 -L/opt/xkbcommon_INSTALL/lib
# 配置项加上包含项 -I/opt/xkbcommon_INSTALL/include

#--------------------------------
func_echo "QT 开启 opengl 支持"

#--------------------------------
XORG_PREFIX=${Dir_prefix_OPENGL} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}

# https://sourceforge.net/projects/libuuid/files/latest/download
do_make libuuid-1.0.3.tar.gz
do_make expat-2.2.9.tar.gz

#--------------------------------
func_echo "编译 Python"

func_cd ${Val_download_dependencies_path}
untar_file Python-3.8.6.tar.xz
func_cd Python-3.8.6

# 配置交叉编译
# export CFLAGS="-I${Dir_prefix_OPENGL}/include -I${TOOLCHAIN}/include"
# export CPPFLAGS="${CFLAGS}"
# export LDFLAGS="-L${Dir_prefix_OPENGL}/lib -L${TOOLCHAIN}/lib"

# func_mkdir 777 zcq_build.pc
# func_cd zcq_build.pc
# ../configure --enable-optimizations
# func_chmod 777 .
# make -j${cpu_cores}
# ${Sudo} make install
# func_cd ..

func_mkdir 777 zcq_build.arm
func_cd zcq_build.arm
../configure \
	--host=${gnueabihf} \
	--prefix=${Dir_prefix_Python} \
	--build=arm \
	--enable-option-checking \
	--with-system-expat \
	--with-system-ffi \
	--with-ensurepip=yes \
	--enable-shared \
	--enable-ipv6 \
	ac_cv_file__dev_ptmx=no \
	ac_cv_file__dev_ptc=no \
	--with-system-expat \
	-with-ensurepip=yes \
	--enable-optimizations &>>${Val_debug_info_path}/Python-3.8.6.log
func_chmod 777 .
make -j${cpu_cores} &>>${Val_debug_info_path}/Python-3.8.6.log
${Sudo} mv -f /usr/bin/lsb_release /usr/lsb_release
${Sudo} make install &>>${Val_debug_info_path}/Python-3.8.6.log
${Sudo} mv -f /usr/lsb_release /usr/bin/lsb_release
func_cd ..
func_chmod 777 ${Dir_prefix_Python}

#--------------------------------
XORG_PREFIX=${Dir_prefix_OPENGL} # 编译输出路径 !!!

func_cd ${Val_download_dependencies_path}
do_make libxml2-2.9.10.tar.gz

#--------------------------------
XORG_PREFIX=${Dir_prefix_OPENGL} # 编译输出路径 !!!

func_echo "安装 Xorg Libraries"

# 配置交叉编译
# export CFLAGS="-I${Dir_prefix_OPENGL}/include -I${TOOLCHAIN}/include"
# export CPPFLAGS="${CFLAGS}"
# export LDFLAGS="-L${Dir_prefix_OPENGL}/lib -L${TOOLCHAIN}/lib"

func_cd ${Val_download_dependencies_path}

Sudo_flag_make_install=true
do_make freetype-2.10.2.tar.gz

Sudo_flag_make_install=true
do_make util-linux-2.36.tar.gz

Sudo_flag_make_install=true
do_make fontconfig-2.13.1.tar.bz2

func_cd ${Val_download_path}
do_make ${Val_list_tar}

#--------------------------------
func_echo "编译 glfw"

func_cd ${Val_download_dependencies_path}
untar_file glfw-3.3.6.tar.gz
func_cd glfw-3.3.6

cmake \
	-DCMAKE_INSTALL_PREFIX=${Dir_prefix_OPENGL} \
	-DCMAKE_C_FLAGS="-L${Dir_prefix_X11}lib -L/${Dir_prefix_XCB}/lib -L${Dir_prefix_OPENGL}/lib -I${Dir_prefix_X11}include -I${Dir_prefix_XCB}/include -I${Dir_prefix_OPENGL}/include -lxcb -lXau -lm" .

################################################################################

func_chmod ${Dir_prefix_X11}
func_chmod ${Dir_prefix_XCB}
func_chmod ${Dir_prefix_OPENGL}
func_chmod ${Dir_prefix_Python}

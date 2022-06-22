#! /bin/bash

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh # !!!!!

# 交叉编译 libxcb 与 X11
# https://blog.csdn.net/weixin_42892101/article/details/107852277

################################################################################

func_echo "建立下载地址列表"

# md5sum tar
# Val_download_list="ce2fb8100c6647ee81451ebe388b17ad xtrans-1.4.0.tar.bz2"

Val_list_tar="
xtrans-1.4.0.tar.bz2
libX11-1.7.2.tar.bz2
libXext-1.3.4.tar.bz2
libFS-1.0.8.tar.bz2
libICE-1.0.10.tar.bz2
libSM-1.2.3.tar.bz2
libXScrnSaver-1.2.3.tar.bz2
libXt-1.2.1.tar.bz2
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
libXft-2.3.4.tar.bz2
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

Val_download_path=x11_xcb_lib

################################################################################

Val_download_path=${RootPath}/${Val_download_path}
func_execute_sudo rm -rf ${Val_download_path}
func_mkdir 777 ${Val_download_path}

func_cd ${Val_download_path}

# md5sum tar
# Val_list_tar="$(echo "${Val_download_list}" | grep -v '^#' | awk '{print $2}')"

Val_list_tar="$(echo "${Val_list_tar}" | grep -v '^$' )"

echo "${Val_list_tar}" | wget -i- -c -B https://www.x.org/pub/individual/lib/

# echo "${Val_download_list}" | md5sum -c

func_chmod 777 ${Val_download_path}

################################################################################

# 设置安装目录
PREFIX_INSTALL=/opt/arm_OPENGL_X11 # 编译输出路径

XORG_PREFIX=${PREFIX_INSTALL}
# XORG_PREFIX=${PREFIX_INSTALL}/prefix
# XORG_CONFIG=${PREFIX_INSTALL}/config

func_execute_sudo rm -rf ${PREFIX_INSTALL}
func_mkdir 777 ${PREFIX_INSTALL}

if true; then
	# if false; then
	# 工具链路径
	TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	# TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
	# TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-10.2.1-2021.02-x86_64_arm-linux-gnueabihf
	func_chmod 777 ${TOOLCHAIN}
	export PATH=${TOOLCHAIN}/bin:$PATH
fi

gnueabihf=arm-linux-gnueabihf
# gnueabihf=arm-none-linux-gnueabihf

# 配置交叉编译
export CC=${gnueabihf}-gcc
export CXX=${gnueabihf}-g++
export CFLAGS="-I${XORG_PREFIX}/include -I/opt/X11_INSTALL/include -I/opt/XCB_INSTALL/include -I${TOOLCHAIN}/include"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="-L${XORG_PREFIX}/lib -L/opt/X11_INSTALL/lib -L/opt/XCB_INSTALL/lib -L${TOOLCHAIN}/lib"

################################################################################

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

################################################################################

#解压并配置安装, 编译主体
do_make() {
	for package in ${Val_list_tar}; do
		local package_name=${package%.tar.bz2}
		func_execute_sudo rm -rf ${package_name}
		func_execute tar -xf $package
		# func_execute tar -xf $package -C ${package_name}

		func_cd ${package_name}
		func_chmod 777 .

		local docdir="--docdir=$XORG_PREFIX/share/doc/${package_name}"
		case $package_name in
		libICE*)
			./configure \
				$docdir \
				ICE_LIBS=-lpthread \
				--host=${gnueabihf} \
				--prefix=${XORG_PREFIX}
			# --config=${XORG_CONFIG}
			;;
		libXfont*)
			./configure \
				$docdir \
				--disable-devel-docs \
				--host=${gnueabihf} \
				--prefix=${XORG_PREFIX}
			# --config=${XORG_CONFIG}
			;;
		libXt-[0-9]*)
			./configure \
				$docdir \
				--with-appdefaultdir=/etc/X11/app-defaults \
				--enable-malloc0returnsnull \
				--host=${gnueabihf} \
				--prefix=${XORG_PREFIX}
			# --config=${XORG_CONFIG}
			;;
		libSM-[0-9]*)
			./configure \
				--enable-option-checking \
				--host=${gnueabihf} \
				--prefix=${XORG_PREFIX}
			# --config=${XORG_CONFIG}
			;;
		*)
			./configure \
				$docdir \
				--enable-malloc0returnsnull \
				--host=${gnueabihf} \
				--prefix=${XORG_PREFIX}
			# --config=${XORG_CONFIG}
			;;
		esac

		func_execute_err make -j${cpu_cores} # 编译

		func_chmod 777 .
		func_chmod 777 ${PREFIX_INSTALL}
		func_execute make install # 安装_编译_结果

		cd -

		# /sbin/ldconfig 命令用于在默认搜寻目录 /lib 和 /usr/lib
		# 以及 动态库配置文件 /etc/ld.so.conf 内所列的目录下，
		# 搜索出可共享的动态链接库（格式如 lib*.so*），
		# 进而创建出动态链接器（ld.so 或 ld-linux.so）所需的缓存文件。
		# 缓存文件默认为 /etc/ld.so.cache,此文件保存已排好序的动态链接库名字列表。
		# 为了让动态链接库为系统所共享，需运行动态链接库的管理命令 ldconfig 更新动态链接库的缓存文件。
		# 通常在系统启动时运行，当用户安装了一个新的动态链接库时，需要手动运行这个命令。
		func_execute_sudo /sbin/ldconfig
	done
}

#编译依赖项
do_make_dependencies() {
	cd $ROOT_PATH
	#下载源码
	mkdir depend_lib

	cd depend_lib

	wget -c https://download.savannah.gnu.org/releases/freetype/freetype-2.10.2.tar.gz

	wget -c https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2

	wget -c https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.gz

	tar -xf util-linux-2.36.tar.gz
	tar -xf fontconfig-2.13.1.tar.bz2
	tar -xf freetype-2.10.2.tar.gz

	cd freetype-2.10.2
	sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
		sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
			-i include/freetype/config/ftoption.h &&
		./configure --prefix=$PREFIX_INSTALL --host=arm-linux --enable-freetype-config --disable-static &&
		make
	as_root make install &&
		cd ..
	cd util-linux-2.36 &&
		./configure --prefix=$PREFIX_INSTALL --host=arm-linux \
			--enable-option-checking \
			--without-python \
			--without-tinfo \
			--without-ncursesw \ 
	--without-ncurses
	make -j4
	as_root make install

	cd ..
	cd fontconfig-2.13.1 &&
		#Make sure the system regenerates src/fcobjshash.h
		rm -f src/fcobjshash.h
	./configure --prefix=$PREFIX_INSTALL \
		--host=aarch64-linux-gnu \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-libxml2 \
		--disable-docs &&
		make
	as_root make install
	cd $ROOT_PATH
}

func_cd ${Val_download_path}

#编译依赖项
do_make_dependencies

#解压并配置安装, 编译主体
do_make

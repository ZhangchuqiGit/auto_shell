#! /bin/bash

# 移植 mplayer 这个强大的视频播放软件
# 视频播放软件 mplayer 用到了 zlib, alsa-lib, libmad 库, 因此要先移植  库

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

Opt_arm_MPlayer=/opt/arm_MPlayer # 编译输出路径

Opt_arm_libmad=/opt/arm_libmad
func_path_isexit "Opt_arm_libmad" ${Opt_arm_libmad}

Opt_arm_zlib=/opt/arm_zlib
Opt_arm_alsa_lib=/opt/arm_alsa_lib
func_path_isexit "Opt_arm_zlib" ${Opt_arm_zlib}
func_path_isexit "Opt_arm_alsa_lib" ${Opt_arm_alsa_lib}

################################################################

func_chmod 777 ${RootPath}

func_execute_sudo rm -rf ${Opt_arm_MPlayer}
func_mkdir 777 ${Opt_arm_MPlayer}

Dir_prefix=${Opt_arm_MPlayer}/prefix # `make install' 编译结果
# Dir_config=${Opt_arm_MPlayer}/config # 编译出来的配置文件存放位置

func_mkdir 777 ${Dir_prefix}
# func_mkdir 777 ${Dir_config}

################################################################

func_apt -i yasm

# Extra_cflags="-I${Opt_arm_alsa_lib}/prefix/include"
# Extra_ldflags="-L${Opt_arm_alsa_lib}/prefix/lib -lasound"
Extra_cflags="-I${Opt_arm_libmad}/include -I${Opt_arm_zlib}/include -I${Opt_arm_alsa_lib}/include"
Extra_ldflags="-L${Opt_arm_libmad}/lib -L${Opt_arm_zlib}/lib -L${Opt_arm_alsa_lib}/lib -lasound"

# --extra-cflags="${Extra_cflags}"
# --extra-ldflags="${Extra_ldflags}"
# –extra-cflags 指定 zlib 和 alsa-lib 的 头文件路径
# –extra-ldflags 指定 zlib 和 alsa-lib 的 库文件路径
# 参数有空格，加双引号

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

#CHOST=/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
CHOST=${gnueabihf} # 在 configure 中为 编译平台
CC=${CHOST}-gcc
#AS=arm-linux-gnueabihf-as
#AR=arm-linux-gnueabihf-ar
#NM=arm-linux-gnueabihf-nm
#RANLIB=arm-linux-gnueabihf-ranlib

func_echo "生成 Makefile，以编译源码"

./configure \
	--host-cc=gcc \
	--target=${CHOST} \
	--cc=${CC} \
	--prefix=${Dir_prefix} \
	--extra-ldflags="${Extra_ldflags}" \
	--extra-cflags="${Extra_cflags}" \
	--enable-alsa \
	--enable-mad \
	--enable-fbdev \
	--enable-cross-compile \
	--disable-ossaudio \
	--disable-mencoder \
	--disable-armv5te --disable-armv6

# --prefix=编译输出路径

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

# 编译完成以后打开 config.mak 文件，找到 “INSTALLSTRIP = -s”这一行，
# 取消掉后面的“-s”，否则 “make install” 命令会失败！
${Sudo} sed -i -E -e "s/^INSTALLSTRIP/#INSTALLSTRIP/" config.mak
#	i 上面插入;		a 下面插入
${Sudo} sed -i -E -e '/^#INSTALLSTRIP/ a INSTALLSTRIP = ' config.mak

func_execute make install # 安装 编译结果

################################################################

func_touch 777 ${Dir_prefix}/"安装_编译_结果"

func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_MPlayer}

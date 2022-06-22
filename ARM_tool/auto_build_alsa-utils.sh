#! /bin/bash

# 音频以及 ALSA 驱动框架
# alsa-utils 是 ALSA 的一些小工具集合，我们可以通过这些小工具还测试我们的声卡

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

Opt_arm_alsa_utils=/opt/arm_alsa # 编译输出路径

# Opt_arm_alsa_lib=/opt/arm_alsa_lib
# func_path_isexit "Opt_arm_alsa_lib" ${Opt_arm_alsa_lib}

# Dir_alsa_library=${Opt_arm_alsa_lib}/lib
# Dir_alsa_include=${Opt_arm_alsa_lib}/include

################################################################

func_chmod 777 ${RootPath}

func_chmod 777 ${Opt_arm_alsa_utils}

# func_execute_sudo rm -rf ${Opt_arm_alsa_utils}
# func_mkdir 777 ${Opt_arm_alsa_utils}

Dir_alsa_prefix=${Opt_arm_alsa_utils} # `make install' 编译结果

func_mkdir 777 ${Dir_alsa_prefix}

################################################################################

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
	--with-alsa-prefix=-L${Opt_arm_alsa_utils}/lib \
	--with-alsa-inc-prefix=-I${Opt_arm_alsa_utils}/include \
	--disable-alsamixer \
	--disable-xmlto \
	CFLAGS=-I${Opt_arm_alsa_utils}/include \
	CPPFLAGS=-I${Opt_arm_alsa_utils}/include \
	LDFLAGS=-L${Opt_arm_alsa_utils}/lib

# CFLAGS=-I${Dir_alsa_include} \
# CPPFLAGS=-I${Dir_alsa_include} \
# LDFLAGS=-L${Dir_alsa_library} \
# LDFLAGS="-L${Dir_alsa_library} -lasound" \

# “--disable-alsamixer”来禁止编译 alsamixer 这个工具，但是这个工具确非常重要，
# 它是一个图形化的声卡控制工具，需要 ncurses 库的支持。
# ncurses 库笔者已经交叉编译成功了(参考 63.5 小节)，但是尝试了很多次设置，
# 就是无法编译 alsa-utils 中的 alsamixer 工具。
# 网上也没有找到有效的解决方法，大家都是禁止编译 alsamixer 的。
# 所以这里就没法使用 alsamixer 这个工具了，
# 但是可以使用 alsa-utils 提供的另外一个工具: amixer，
# alsamixer 其实就是 amixer 的图形化版本。

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute_sudo make install # 安装_编译_结果

################################################################

func_touch 777 ${Dir_alsa_prefix}/"安装_编译_结果"

func_chmod 777 ${RootPath}
func_chmod 777 ${Opt_arm_alsa_utils}

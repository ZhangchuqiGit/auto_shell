#! /bin/bash

# modbus 是一个 通用的纯数据协议

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source ../ARM_tool_function.sh # !!!!!

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

############################ 修改 ###############################

# 工具链路径
TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
# TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf
export PATH=$PATH:${TOOLCHAIN}/bin

gnueabihf=arm-linux-gnueabihf
# gnueabihf=arm-none-linux-gnueabihf

opt_arm_libmodbus=/opt/arm_libmodbus # 编译输出路径

################################################################

func_chmod 777 ${RootPath}
func_chmod 777 ${TOOLCHAIN}

func_execute_sudo rm -rf ${opt_arm_libmodbus}
func_mkdir 777 ${opt_arm_libmodbus}

#####################################################################

#生成 Makefile，还需要安装以下软件。
# func_apt -d
# func_apt -i autoconf automake libtool

func_execute_sudo /usr/bin/autoreconf -f -i -I ${RootPath}/m4

#####################################################################

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

host=${gnueabihf}
# host=arm-none-linux-gnueabi
# host=arm-linux-gnueabihf
# host=/home/zcq/ARM_Linux_QT/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf
CC=${host}-gcc
# CXX=${host}-g++

func_echo "生成 Makefile，以编译源码"

# ./configure CC=${CC} CXX=${CXX}
# --host=${host} --prefix=${opt_arm_libmodbus}
# ac_cv_func_malloc_0_nonnull=yes
func_execute ./configure \
	--host=${host} \
	ac_cv_func_malloc_0_nonnull=yes \
	--enable-static \
	--prefix=${opt_arm_libmodbus}
# --prefix=编译输出路径

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${RootPath}

func_execute_sudo make install # 安装_编译_结果

#####################################################################

func_echo "
# 输入命令 vim random-test-server.c 打开测试程序， 
# 里面 23 行 ctx =modbus_new_tcp(\"127.0.0.1\", 1502);
# 改成 ctx = modbus_new_tcp(NULL, 1502); 
# 即 server 监控所有的 ip 地址， 端口是 1502。

# 然后执行命令交叉编译命令, 生成可执行文件 random-test-server
${CC} -o tests/random-test-server tests/random-test-server.c \\
-L${opt_arm_libmodbus}/lib -lmodbus \\
-I${opt_arm_libmodbus}/include/modbus  "

func_chmod 777 ${opt_arm_libmodbus}

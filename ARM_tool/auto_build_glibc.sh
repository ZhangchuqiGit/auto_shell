#! /bin/bash

source ARM_tool_function.sh # !!!!!

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

################################################################

func_echo "
Linux 中提示: 
/lib/libc.so.6: version \`GLIBC_2.17\` not found (required by xxx)
/lib/arm-linux-gnueabihf/libc.so.6: version \`GLIBC_2.33\` not found (required by aplay)
解决办法:
01 查看系统中可使用的 glibc 版本
	$ strings /lib/arm-linux-gnueabihf/libc.so.6 | grep GLIBC_
02 下载高版本的 glibc 库  https://ftp.gnu.org/gnu/glibc/
	$ wget https://ftp.gnu.org/gnu/glibc/glibc-2.33.tar.gz
03 下载之后 解压缩
	$ tar -xvf glibc-2.33.tar.gz
04 编译安装
05 查看共享库
	$ ls -l /lib/libc.so.6
	$ ls -l /lib/arm-linux-gnueabihf/libc.so.6
	# 可以看到已经建立了软链接
	lrwxrwxrwx 1 root root 12 Jan 13 01:49 /lib/libc.so.6 -> libc-2.33.so
06 再次 查看系统中可使用的 glibc 版本 "

############################ 修改 ###############################

Dir_glibc_num=glibc-2.33
Dir_glibc_num=${RootPath}/${Dir_glibc_num}
func_chmod 777 ${Dir_glibc_num}

Dir_build=build
Dir_build=${RootPath}/${Dir_build}
func_mkdir 777 ${Dir_build}

Dir_prefix=/usr # `make install' 编译结果

################################################################
func_cd ${Dir_build}

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

func_echo "编译安装"

func_execute ${Dir_glibc_num}/configure \
	--prefix=${Dir_prefix} \
	--with-headers=/usr/include \
	--with-binutils=/usr/bin \
	--disable-profile \
	--enable-add-ons

# --prefix=编译输出路径

func_chmod 777 ${Dir_build}

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

func_execute_err make -j${cpu_cores} # 编译

func_chmod 777 ${Dir_glibc_num}

func_execute_sudo make install # 安装 编译结果

################################################################

#! /bin/bash

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
ToolchainPath=/home/zcq/Arm_tool_x86_64_linux/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf

# linux 拷贝路径
ToolchainPathArm=${ToolchainPath}/arm-none-linux-gnueabihf

# dns 域名服务器
Resolv_conf=${Zcq_Create_rootfs}/file_etc/resolv.conf

# 修改软件源
Sources_list=${Zcq_Create_rootfs}/file_etc/ubuntu-20.04_ARM_sources.list

################################################################
################################################################

################################################################################
Sudo=sudo
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

_num_x=30
_num_y=47
_debug_echo() {
	if [ $_num_x -gt 37 ]; then
		_num_x=30
	fi
	if [ $_num_y -lt 40 ]; then
		_num_y=47
	fi
	echo -e "\033[${_num_x};${_num_y}m $* \e[0m"
	_num_x=$(($_num_x + 1))
	_num_y=$(($_num_y - 1))
}

function __debug_echo() {
	local slt=$1
	case $slt in
		-v) # -variable 变量
			shift
			echo -e " \033[3;7;37;44mVariable\e[0m (\033[37;44m $* \e[0m)"
			#			_debug_echo "Variable ( $* )"
			;;
		-p) # path or file
			shift
			echo -e " \033[3;7;36;40mPath\e[0m [\033[36;40m $* \e[0m]"
			;;
		-e) # error 错误
			shift
			echo -e " \033[1;5;7;30;41m !!! 错误 \e[0m\033[30;41m $* \e[0m"
			;;
		-c) # shell 命令
			shift
			echo -e " \033[1;3;5;32m\$ \e[0m\033[1;32;40m $* \e[0m"
			;;
		*) # 描述信息
			echo -e " \033[1;7;38m $* \e[0m"
			#			 _debug_echo "$*"
			;;
	esac
	#	unset slt
}

# execute 执行语句 成功与否打印
execute() {
	__debug_echo -c "$*"
	$@
}
execute_sudo() {
	execute "${Sudo} $*"
}
execute_err() {
	execute "$@"
	local ret=$?
	if [ $ret -ne 0 ]; then
		__debug_echo -e "ret=$ret 执行 $*"
		exit $ret
	fi
}
execute_err_sudo() {
	execute_err "${Sudo} $*"
}
# execute pwd ; ifconfig
# execute mkdir -m 777 -p -v file # 创建文件夹

function sys_install() {
	#	declare -i mode
	local mode='-i'
	while [ $# -gt 0 ]; do
		case "$1" in
			-d)
				# echo -e "\n\033[32m apt update -y \e[0m"
				execute ${Sudo} apt update -y
				execute ${Sudo} apt update -y --fix-missing
				mode="-d"
				;;
			-g)
				# echo -e "\n\033[33m apt upgrade -y \e[0m"
				execute ${Sudo} apt upgrade -y
				mode="-g"
				;;
			-i)
				mode="-i"
				;;
			*)
				if [ "${mode}" = "-i" ]; then
					# echo -e "\n\033[33;44m apt install -y $1 -f\e[0m"
					execute_sudo apt install -y $1 -f
				fi
				;;
		esac
		shift
	done
	#	unset mode
}

cd_path() {
	__debug_echo -c "cd $1 || exit"
	cd $1 || exit
}
################################################################################

sys_install -d -g
sys_install cmake cmake-qt-gui cmake-curses-gui

#cpu_cores=$(cat /proc/cpuinfo | grep "processor" | wc -l) # 获取内核数目
cpu_cores=$(cat /proc/cpuinfo | grep -c "processor") # 获取内核数目
_debug_echo "获取内核数目: ${cpu_cores}"

Rootpath="$(pwd)"
execute_err_sudo chmod -R 777 ${Rootpath}

Install_out="out_install"
Install_out="${Rootpath}/${Install_out}"
# Include_out="out_include"
# Include_out="${Rootpath}/${Include_out}"
Build_out="out_build"
Build_out="${Rootpath}/${Build_out}"

execute_sudo rm -rf ${Install_out} ${Build_out} ${Include_out}
execute_sudo mkdir -m 777 -p -v ${Install_out} ${Build_out} ${Include_out} # 创建文件夹

_debug_echo "Install 路径 ${Install_out} "
# _debug_echo "Include 路径 ${Include_out} "
_debug_echo "Build 路径 ${Build_out} "

cd_path ${Build_out}

if true; then
# if false; then
	__debug_echo "
交叉编译器的路径 
/usr/local/arm/gcc-linaro-11.0.1-2021.03-x86_64_arm-linux-gnueabihf/bin
/usr/local/arm/gcc-linaro-11.0.1-2021.03-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc
/usr/local/arm/gcc-linaro-11.0.1-2021.03-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++
/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin
/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc
/usr/local/arm/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++ "
	execute_err cmake-gui # 图形化工具 文档:【正点原子】I.MX6U 移植OpenCV V1.2.pdf
else 
	_debug_echo "配置编译"
	execute_err cmake .. --build=${Build_out} --install=${Install_out} --include=${Include_out}
fi
execute_err_sudo chmod -R 777 ${Rootpath}

Modify_file="${Rootpath}/3rdparty/protobuf/src/google/protobuf/stubs/common.cc"
if [ ! -f "${Modify_file}" ]; then
	exit 1
fi
#	i 上面插入;		a 下面插入
_debug_echo "${Modify_file}
添加 #define HAVE_PTHREAD 宏定义才可以编译的过
原因是 HAVE_PTHREAD 宏定义了 pthread 库"
${Sudo} sed -i -E -e '/^#define HAVE_PTHREAD/d' ${Modify_file}
${Sudo} sed -i -E -e '1,1 i #define HAVE_PTHREAD' ${Modify_file}

_debug_echo "开始编译"
execute_err make -j${cpu_cores} # 编译
execute_err_sudo chmod -R 777 ${Rootpath}

_debug_echo "安装到系统目录"
execute make install # 安装 编译结果
execute_err_sudo chmod -R 777 ${Rootpath}

cd_path ${Rootpath}

_debug_echo "已经编译完成 OpenCV 了，把 install 文件夹的 lib 下的所有库，
拷贝到文件系统下的 /usr/lib 目录下，写好程序调用即可 "

# _debug_echo "安装完成：
# 可以看到库被安装到:
# /usr/local/lib
# 头文件被安装在:
# /usr/local/include/opencv4  "


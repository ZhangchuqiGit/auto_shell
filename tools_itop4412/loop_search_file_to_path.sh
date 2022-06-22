#!/usr/bin/bash

rootpath=$(pwd)

function __debug_echo() {
	local slt=$1
	case $slt in
		-v) # -variable 变量
			shift
			echo -e "\033[37;44m $* \e[0m"
			;;
		-p) # path or file
			shift
			echo -e "\033[36;40m $* \e[0m"
			;;
		-e) # error 错误
			shift
			echo -e "\033[30;41m 错误！$* \e[0m"
			;;
		-c) # shell 命令
			shift
			echo -e "\033[32m $* \e[0m"
			;;
		*) # 描述信息
			echo -e "\033[33m $* \e[0m"
			;;
	esac
	unset slt
}

# execute 执行语句 成功与否打印
execute() {
	__debug_echo -c "\$ $*"
	$@
	if [ $? -ne 0 ]; then
		__debug_echo -e "执行 $*"
		exit $?
	fi
}
# execute pwd ; ifconfig
# execute mkdir -m 777 -p -v file # 创建文件夹

# 排除的文件夹
declare -a exclude_file
declare -i num_i
num_i=0
exclude_file_func() {
	while [ $# -gt 0 ]; do
		#		case $1 in
		#			--help | -h)
		#				shift
		#				;;
		#			*)
		#				shift
		#				;;
		#		esac
		exclude_file[${num_i}]=$1
		shift
		let 'num_i++'
	done
}
# echo ${#exclude_file[@]} # 数组个数

exclude_file_compare() {
	compare_flag=false
	for ((i = 0; i < ${#exclude_file[@]}; i++)); do
		if [ ${exclude_file[$i]} == $1 ]; then
			compare_flag=true
		fi
	done
}

# search_file() {
# 	local arm_file=$1/
# 	local path_tmp=$(ls -1 $arm_file) # 多个文件夹
# 	for tmp in ${path_tmp}; do
# 		if [ -d $arm_file${tmp} ]; then
# 			exclude_file_compare ${tmp}
# 			if [ ${compare_flag} == false ]; then
# 				echo $arm_file${tmp} >>${zcq_file}
# 				search_file $arm_file${tmp}
# 			fi
# 		fi
# 	done
# }

search_file_code() {
	local arm_file=$1/
	local path_tmp=$(ls -1 $arm_file) # 多个文件夹
	for tmp in ${path_tmp}; do
		if [ -d $arm_file${tmp} ]; then
			exclude_file_compare ${tmp}
			if [ ${compare_flag} == false ]; then
				echo $arm_file${tmp} >>${zcq_file}
#				echo -e "\"$arm_file${tmp}/\"," >>${zcq_file}
				search_file_code $arm_file${tmp}
			fi
		fi
	done
}

################################    修改处    ###################################

zcq_file=${rootpath}/zcq_file.txt
rm -rf ${zcq_file}

# 排除的文件夹
exclude_file_func cmake-build-debug .vscode .idea
# exclude_file_func Documentation amcc
# exclude_file_func api doc env out_u-boot nds32 openrisc sh sparc 8dtech
# exclude_file_func firefly engicam davinci dfi compulab broadcom xtensa
# exclude_file_func x86 powerpc sandbox blackfin m68k microblaze mips
# exclude_file_func arc avr32 AndesTech armltd atmel avionic-design bachmann
# exclude_file_func barco esd gaisler google intel keymile LaCie Marvell
# exclude_file_func micronas nvidia renesas samsung sandisk siemens spear
# exclude_file_func ti technexion Synology toradex xilinx test tools


search_file_code ${rootpath}

echo ${rootpath//\//\\\/}
sed -i -E -e "s/${rootpath//\//\\\/}/./g" ${zcq_file}

# search_file_code $(pwd)/arch/arm
# search_file_code $(pwd)/board/samsung
# search_file_code $(pwd)/cmd
# search_file_code $(pwd)/common
# search_file_code $(pwd)/drivers
# search_file_code $(pwd)/dts
# search_file_code $(pwd)/fs
# search_file_code $(pwd)/include
# search_file_code $(pwd)/lib
# search_file_code $(pwd)/net
# search_file_code $(pwd)/post
# search_file_code $(pwd)/scripts
# search_file_code $(pwd)/test
# search_file_code $(pwd)/tools

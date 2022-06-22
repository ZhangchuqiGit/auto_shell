#!/bin/bash

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
# 			if [ ${compare_flag} == "false" ]; then
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
			if [ ${compare_flag} == "false" ]; then
				echo $arm_file${tmp} >>${zcq_file_Clion}
				echo "\"$arm_file${tmp}/\"," >>${zcq_file_VScode}
				if [ ${tmp} != "include" ]; then
					search_file_code $arm_file${tmp}
				fi
			fi
		fi
	done
}

if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

################################    修改处    ###################################

zcq_file_Clion=${rootpath}/zcq_file_Clion.txt
zcq_file_VScode=${rootpath}/zcq_file_VScode.txt
${Sudo} rm -rf ${zcq_file_Clion} ${zcq_file_VScode}

# 排除的文件夹
exclude_file_func cmake-build-debug .vscode .idea

search_file_code ${rootpath}

# echo ${rootpath//\//\\\/}
sed -i -E -e "s/${rootpath//\//\\\/}/./g" ${zcq_file_Clion}
sed -i -E -e "s/${rootpath//\//\\\/}/\${workspaceFolder}/g" ${zcq_file_VScode}



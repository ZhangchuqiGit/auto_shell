#!/usr/bin/env bash

# 将 根文件系统 sysroot 目录下所有的 符号链接 进行 "绝对->相对" 转换
# ln [args] [path](可以不存在) [link](路径需正确)

########################## modify ##############################

# 使用 01: ./$0 [sysroot_dir] [exclude_file...]

# 使用 02: 修改 Dir_sysroot
Dir_sysroot=sysroot_ubuntu_base

################################################################

if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

################################################################

f_cd() {
	cd "$1" || exit 50
}

declare -i Val_min
f_min() {
	#	echo "f_min \$#=$#; \$*=$*"
	if [ $# -lt 2 ]; then
		exit 21
	fi
	Val_min=$1
	#	echo "f_min=$1"
	shift
	while [ $# -gt 0 ]; do
		if [ "${Val_min}" -gt "$1" ]; then
			Val_min=$1
		fi
		#		echo "f_min=$1"
		shift
	done
	#	echo "Val_min=${Val_min}"
}
# f_min 9 4 5 18 2

declare -a Val_array
f_path_array() {
	if [ $# -ne 1 ]; then
		exit 31
	fi
	Val_array=()
	local i=0
	# 变量全替换   ${value//pattern/string}
	# 变量一次替换  ${value/pattern/string}
	for tmp in ${1//\//\ }; do
		Val_array[$i]=${tmp}
		let '++i'
	done
	#	echo -e "Val_array[*]=${Val_array[*]}"
	#	echo "\${#Val_array[@]}=${#Val_array[@]}"
}
# f_path_array /01/02/03/04
# Val_array =  01 02 03 04

f_is_sys() {
	# bin boot dev etc home lib media mnt opt proc
	# root run sbin srv sys tmp usr var
	local Ubuntu_sys_file="etc usr"
	for tmp in ${Ubuntu_sys_file}; do
		if [ ! -d "${Dir_sysroot}/${tmp}" ]; then
			echo "no exit : ${Dir_sysroot}/${tmp}"
			exit 82
		fi
	done
}

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
		exclude_file[${num_i}]="$1"
		shift
		let '++num_i'
	done
}
# echo ${#exclude_file[@]} # 数组个数

exclude_file_compare() {
	compare_flag=""
	for ((i = 0; i < ${#exclude_file[@]}; i++)); do
		if [ "${exclude_file[$i]}" == "$1" ]; then
			echo -e "\033[32m 排除: $1\e[0m"
			compare_flag=true
		fi
	done
}

search_file_code() {
	local dir_root="$1"
	local path_tmp
	if [ -r "${dir_root}" ]; then
		path_tmp="$(ls -1 "${dir_root}")" # 多个 文件/目录
	else
		path_tmp="$(${Sudo} ls -1 "${dir_root}")" # 多个 文件/目录
	fi
	#	echo "${path_tmp}"
	local tmp_path
	for tmp in ${path_tmp}; do
		tmp_path=${dir_root}/${tmp}
		#		echo "${tmp_path}"
		if [ -L "${tmp_path}" ]; then
			link_abs_to_rel "${tmp_path}"
		else
			if [ -d "${tmp_path}" ]; then
				exclude_file_compare "${tmp_path}"
				if [ -z "${compare_flag}" ]; then
					# echo "${tmp_path}"
					search_file_code "${tmp_path}"
				fi
			fi
		fi
	done
}
#search_file_code /01/02

link_abs_to_rel() {
	local file_link=$1
	#	if [ ! -L ${file_link} ]; then
	#		return 1
	#	fi
	local file_readlink
	file_readlink="$(${Sudo} readlink "${file_link}")"
	# file_readlink=/01/02/03

	# [[ 正则表达式 ]]
	if [[ ${file_readlink} != /* ]]; then
		return 17
	fi

	if [[ ${file_readlink} == /dev/* ]]; then
		return 18
	fi

	local file_readlink_add=
	file_readlink_add="${file_readlink}"
	if [[ ${file_readlink} == /bin/* ]] || [[ ${file_readlink} == /lib/* ]] || [[ ${file_readlink} == /sbin/* ]]; then
		file_readlink_add=/usr${file_readlink}
	fi

	# ln [args] [path](可以不存在) [link](路径需正确)
	# /01 --
	#   |  02 --
	#   |   |  03 --
	#   |   |   |  04
	#   |  05 --
	#   |   |  06
	#	|	|  07
	# ln -srf /01/05/06 /01/02/03/04
	# ll 04 -> /01/05/06
	# ll 04 -> ../../05/06			2个 ../ = 不同级(02/03)
	# ln -srf /01/02/03/04 /01/05/06
	# ll 06 -> /01/02/03/04
	# ll 06 -> ../02/03/04			1个 ../ = 不同级(05)
	# ln -srf /01/05/06 /01/05/07
	# ll 07 -> /01/05/06
	# ll 07 -> 06					0个 ../ = 不同级()

	local val_readlink
	f_path_array "${file_readlink_add}"
	val_readlink=(${Val_array[*]})

	local val_link
	val_link=${file_link#${Val_sysroot}}
	#	echo "val_link=${val_link}"
	f_path_array "${val_link}"
	val_link=(${Val_array[*]})
	#	echo "val_link=${val_link[*]}"
	# file_link = /.../01/02/03
	# val_link  =     /01/02/03
	# val_link  =      01 02 03

	f_min ${#val_readlink[@]} ${#val_link[@]}
	local num_min=${Val_min}

	# 同级数
	local num_glass=0
	for ((i = 0; i < ${num_min} - 1; ++i)); do
		if [ "${val_readlink[${i}]}" == "${val_link[${i}]}" ]; then
			let '++num_glass'
		else
			break
		fi
	done

	# 相对路径
	local file_path=""

	# 添加 ../ 个数
	local num_mutlipoint=$((${#val_link[@]} - 1 - ${num_glass}))
	for ((i = 0; i < ${num_mutlipoint}; ++i)); do
		file_path="${file_path}../"
	done

	for ((i = ${num_glass}; i < ${#val_readlink[@]}; ++i)); do
		file_path="${file_path}${val_readlink[${i}]}/"
	done
	file_path=${file_path%/}

	echo "${file_link} -> ${file_readlink} : ${file_path}"

	# ${Sudo} rm -rf ${file_link}
	${Sudo} ln -sf ${file_path} ${file_link}
}

f_files_for() {
	while [ $# -gt 0 ]; do
		if [ -d "$1" ]; then
			echo " +++++++++++ 目录: $1"
			search_file_code "$1"
			echo " ----------- 目录: $1"
		fi
		shift
	done
}
#f_files_for /01/02 /03/04

f_finalwork() {
	${Sudo} ln -sf arm-linux-gnueabihf/ld-linux.so.3 ${Dir_sysroot}/usr/lib/ld-linux.so.3
}

f_main() {
	f_is_sys

	# 排除的文件夹
	exclude_file_func ${Dir_sysroot}/bin ${Dir_sysroot}/boot ${Dir_sysroot}/dev
	exclude_file_func ${Dir_sysroot}/home ${Dir_sysroot}/lib ${Dir_sysroot}/media
	exclude_file_func ${Dir_sysroot}/mnt ${Dir_sysroot}/opt ${Dir_sysroot}/proc
	exclude_file_func ${Dir_sysroot}/sbin ${Dir_sysroot}/tmp ${Dir_sysroot}/var

	f_files_for ${Dir_sysroot}
}

################################################################

if [ -n "$1" ]; then
	Dir_sysroot=$1
	shift
fi
while [ $# -gt 0 ]; do
	# 排除的文件夹
	exclude_file_func "$1"
	echo -e "\033[31m 排除的文件夹: $1\e[0m"
	shift
done
if [ ! -d "${Dir_sysroot}" ]; then
	echo "no exit : ${Dir_sysroot}"
	exit 2
fi
Dir_sysroot=$(
	f_cd "${Dir_sysroot}"
	pwd
)
echo "根文件系统 sysroot 绝对路径 Dir_sysroot=${Dir_sysroot}"

Val_sysroot="${Dir_sysroot//\//\\\/}"
# echo "val_sysroot=${Val_sysroot}"
# Val_sysroot = "\/01\/02\/03"

f_cd "${Dir_sysroot}"

################################################################

f_main

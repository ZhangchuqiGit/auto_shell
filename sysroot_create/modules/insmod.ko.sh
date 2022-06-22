#! /bin/bash

WorkPath=/modules

function insmod_exec() {
    for file in ${val_ko}; do
        # for file in $(ls ${WorkPath}/*.ko); do
        echo -e "\033[35m insmod ${file} #加载驱动模块\e[0m"
        insmod ${file}
    done
}

function insmod_add() {
    while [ $# -gt 0 ]; do
        echo -e "\033[33m insmod $1 #加载驱动模块\e[0m"
        insmod $1
        shift
    done
}
function insmod_init() {
    # local WorkPath=$(pwd)
    declare -a file_array
    file_array=$(ls ${WorkPath}/*.ko)
    # echo -e "${file_array}"

    insmod_add ${file_array}
}

val_ko="$(ls ${WorkPath}/*.ko)"
if [ -z "${val_ko}" ]; then
    echo -e "\033[5;31;42m *.ko is not found ! \e[0m"
    exit 1
fi

if true; then
    insmod_exec
else
    insmod_init
fi

exit 0

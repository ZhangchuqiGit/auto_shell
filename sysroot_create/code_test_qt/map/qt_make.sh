#! /bin/bash

source /opt/ARM_tool_function.sh

#_debug_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#_debug_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

################################################################

# if true; then
    if false; then
    # 工具链路径
    TOOLCHAIN=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
    # TOOLCHAIN=/home/zcq/Arm_tool_x86_64_linux/gcc-linaro-10.2.1-2021.02-x86_64_arm-linux-gnueabihf
    func_chmod 777 ${TOOLCHAIN}
    export PATH=$PATH:${TOOLCHAIN}/bin
fi

func_chmod 777 ${RootPath}

if [ -f Makefile ]; then
    func_execute make distclean
fi

# if false; then
    if true; then
    func_execute qmake
else
    func_execute /opt/arm_qt_webengine/bin/qmake  MyMap.pro
    # -o Makefile t1.pro
fi

func_chmod 777 ${RootPath}

# cpu_cores="$(grep processor /proc/cpuinfo  | awk '{num=$NF+1};END{print num}')" # 获取内核数目
# cpu_cores="$(cat /proc/cpuinfo | grep "processor" | wc -l)" # 获取内核数目
cpu_cores="$(cat /proc/cpuinfo | grep -c "processor")" # 获取内核数目
func_echo "获取内核数目: $cpu_cores"

make -j$cpu_cores

func_chmod 777 ${RootPath}

func_echo "用命令
t1 -platform linuxfb 运行，
但是运行时会发现报错： Could not find the Qt platform plugin "linuxfb"
在t1.pro工程文件里添加一行： QTPLUGIN += qlinuxfb "

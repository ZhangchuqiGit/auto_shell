#! /bin/bash

################################################################################################

filename=system.img
raw_image_file=raw_${filename}

ARM_sys=/home/zcq/ARM_sys

echo -e "\033[36m----------------------------------------
simg2img  用来将system.img还原来ext4镜像（通过make_ext4fs制作的ext4镜像包含了spare数据，无法以 loop 方式 mount)
simg2img ${filename} ${raw_image_file} \e[0m"
simg2img ${filename} ${raw_image_file}
# s.img: Linux rev 1.0 ext4 filesystem data, UUID=20fc1eee-2485-a159-a346-5deada1421b2,
# volume name "linux" (extents) (large files)
file ${raw_image_file}
sudo chmod -R 777 ${raw_image_file}

if [ -e ${raw_image_file} ]; then
    sudo mkdir -m 777 -p ${ARM_sys}
    umount ${ARM_sys}

    echo "采用挂载分区的方式来打开 system.img 文件"
    # sudo mount -o loop ${raw_image_file} ${ARM_sys}
    sudo mount -t ext4 -o loop ${raw_image_file} ${ARM_sys}
fi

################################################################################################

# 步骤
# 1. make_ext4fs 得到 system.img
# 2. $ simg2img system.img system_raw.img
# 3. $ mkdir system_dir
# 4. mount -t ext4 -o loop system_raw.img system_dir
# 5. .... "随意"修改 system_dir 目录下的文件
# 6. $ ./make_ext4fs -s -l 512M -a root -L linux system_new.img system
# 7. 新生成的 system_new.img 就可以用来烧写了。

################################################################################################

# 314572800 = 300 *1024 *1024

# make_ext4fs -l 512M -s -a system system.ext4img system
# -l 镜像大小 512M
# -s  ext4的S模式
# -a system 制作安卓系统镜像，挂载点为/system
# system.ext4img 目标文件
# system 源文件目录

# make_ext4fs -s -l 314572800 -a root -L linux  ./rootfs_qt.img  ./root
# -a root  用于Linux 根文件系统，挂载点为 /
# -L linux 标签为 linux

# make_ext4fs用于Android平台上制作ext4文件系统的镜像

# 用法：
# make_ext4fs [ -l <len> ] [ -j <journal size> ] [ -b <block_size> ]
#     [ -g <blocks per group> ] [ -i <inodes> ] [ -I <inode size> ]
#     [ -L <label> ] [ -f ] [ -a <android mountpoint> ]
#     [ -S file_contexts ]
#     [ -z | -s ] [ -t ] [ -w ] [ -c ] [ -J ]
#     <filename> [<directory>]

# 主要参数：
# -s   就是生成ext4的S模式制作；
# -l   分区大小；
# -a root  是指这个img用于Linux根文件系统 挂载点为 /。
# -a system  即表示为android系统，挂载点即是/system。使用这个参数，
# make_ext4fs会根据private/android_filesystem_config.h里定义好的权限来给文件夹里的所有文件重新设置权限，
# 如果你刷机以后发现有文件权限不对，可以手工修改android_filesystem_config.h来添加权限，重新编译make_ext4fs，
# 也可以不使用 “-a system”参数，这样就会使用文件的默认权限。
# -L  设置标签
# -T  时间戳

################################################################################################

# simg2img  用来将system.img还原来ext4镜像（通过make_ext4fs制作的ext4镜像包含了spare数据，无法以loop方式mount)

# Usage: simg2img <sparse_image_files> <raw_image_file>

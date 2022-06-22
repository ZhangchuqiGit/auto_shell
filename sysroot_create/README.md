# sysroot_create
构建 ARM-ubuntu20 根文件系统

---------------------------

将该 文件夹 放到 根文件系统 Rootfs 目录下  

方式 01 
文件夹 目录下 依次执行： 

./1_prepare.sh  
./2_mount_umount.sh 
./3_chroot.sh 
./4_final_work.sh 
./5_tar_sysroot.sh  

方式 02 
根文件系统 目录下 依次执行： 

./sysroot_create/1_prepare.sh 
./sysroot_create/2_mount_umount.sh  
./sysroot_create/3_chroot.sh  
./sysroot_create/4_final_work.sh  
./sysroot_create/5_tar_sysroot.sh 

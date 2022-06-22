正点原子系统制作工具包使用说明

建议替换前请请备份好原来的文件
1.如果需要替换boot目录下的文件，替换的文件必须与boot目录下的文件同名
2.如果需要替换filesystem下的文件，替换的文件必须与filesystem目录下的文件同名
3.如果需要替换modules下的文件，替换的文件必须与modules目录下的文件同名
4.脚本烧写方式，可以拷贝files文件夹执行脚本直接烧写
5.mfgtool（OTG方式）烧写，直接选择mfgtool目录下的*vbs进行烧写系统

files目录结构如下：
files/
│  imx6mkemmcboot.sh
│  imx6mknandboot.sh
│  imx6mksdboot.sh
│  README.txt
│
├─boot
│      imx6ull-14x14-emmc-10.1-1280x800-c.dtb
│      imx6ull-14x14-emmc-4.3-480x272-c.dtb
│      imx6ull-14x14-emmc-4.3-800x480-c.dtb
│      imx6ull-14x14-emmc-7-1024x600-c.dtb
│      imx6ull-14x14-emmc-7-800x480-c.dtb
│      imx6ull-14x14-emmc-hdmi.dtb
│      imx6ull-14x14-emmc-vga.dtb
│      u-boot-imx6ull-14x14-ddr256-emmc.imx
│      u-boot-imx6ull-14x14-ddr256-nand-sd.imx
│      u-boot-imx6ull-14x14-ddr256-nand.imx
│      u-boot-imx6ull-14x14-ddr512-emmc.imx
│      u-boot-imx6ull-14x14-ddr512-nand-sd.imx
│      u-boot-imx6ull-14x14-ddr512-nand.imx
│      zImage
│
├─filesystem
│      rootfs.tar.bz2
│
└─modules
        modules.tar.bz2

目录详细说明：
1.boot目录下存放设备树、内核与U-boot。
2.filesystem目录下存放文件系统压缩包
3.modules目录下存放的是内核模块压缩包

制卡脚本说明:(详细参阅正点原子快速体验文档)
1.使用imx6mksdboot.sh制作的是从SD卡启动系统，复制整个files制卡工具包到Ubuntu，
用读卡器插入SD卡，连接到Ubuntu上，执行该脚本进行烧写，执行脚本需要选择参数。
2.使用imx6mkemmcboot.sh制作的是从eMMC启动系统，请使用含eMMC版本的板卡，
从SD卡启动系统后，复制整个files制卡工具包到文件系统目录下，执行该脚本进行烧写，
执行脚本需要选择参数。
3.使用imx6mknandboot.sh制作的是从NAND FLASH启动系统，请使用含NAND FLASH版本
的板卡，从SD卡启动系统后，复制整个files制卡工具包到文件系统目录下，
执行该脚本进行烧写，执行脚本需要选择参数。


Linux内核zImage\Image\uImage之区别及uImage的制作

内核编译（make）之后会生成两个文件，一个是Image，一个是zImage，
其中Image为内核映像文件，而zImage为内核的一种映像压缩文件，Image大约为4M，而zImage不到2M。
uImage是uboot专用的映像文件，它是在zImage之前加上一个长度为64字节的“头”，说明这个内核的版本、加载位置、生成时间、大小等信息；其0x40之后与zImage没什么区别。
uImage的64字节的头结构如下：
typedef struct image_header{
     uint32_tih_magic;
     uint32_tih_hcrc;
     uint32_tih_time;
     uint32_tih_size;
     uint32_tih_load;
     uint32_tih_ep;
     uint32_tih_dcrc;
     uint32_tih_os;
     uint32_tih_arch;
     uint32_tih_type;
     uint32_tih_comp;
     uint32_tih_name[IH_NMLEN];
}image_header_t;
       所以uImage和zImage都是压缩后的内核映像，而uImage是uboot专用的映像文件，是用mkimage工具根据zImage制作而来的。






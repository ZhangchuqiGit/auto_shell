#! /bin/bash

source /opt/ARM_tool_function.sh # !!!!!

# ubunut_20.04 方式 工具链
if false; then
# if true; then

    func_apt -i gcc-9 g++-9
    func_apt -i gcc-9-base gcc-9-cross-*
    func_apt -i gcc-9-multilib gcc-9-plugin-dev gcc-9-source gcc-9-test-results
    func_apt -i g++-9-multilib
    func_apt -i gcc gcc-multilib gcc-opt gcc-avr
    func_apt -i g++ g++-multilib

    func_apt -i \*-9-arm-linux-gnueabihf
    func_apt -i \*-9-multilib-arm-linux-gnueabihf
    func_apt -i \*-9-dev-armhf-cross

    func_apt -i \
        cpp-9-arm-linux-gnueabihf \
        cpp-arm-linux-gnueabihf \
        gfortran-9-arm-linux-gnueabihf \
        gfortran-9-multilib-arm-linux-gnueabihf \
        gfortran-arm-linux-gnueabihf \
        gfortran-multilib-arm-linux-gnueabihf \
        g++-9-arm-linux-gnueabihf \
        g++-9-multilib-arm-linux-gnueabihf \
        gm2-9-arm-linux-gnueabihf \
        g++-arm-linux-gnueabihf \
        gm2-arm-linux-gnueabihf \
        g++-multilib-arm-linux-gnueabihf \
        gnat-9-arm-linux-gnueabihf \
        gcc-9-arm-linux-gnueabihf \
        gcc-9-multilib-arm-linux-gnueabihf \
        gcc-9-plugin-dev-arm-linux-gnueabihf \
        gcc-arm-linux-gnueabihf \
        gccgo-9-arm-linux-gnueabihf \
        gobjc++-9-arm-linux-gnueabihf \
        gcc-multilib-arm-linux-gnueabihf \
        gobjc-9-arm-linux-gnueabihf \
        gobjc++-9-multilib-arm-linux-gnueabihf \
        gobjc-9-multilib-arm-linux-gnueabihf \
        gobjc++-arm-linux-gnueabihf \
        gobjc-arm-linux-gnueabihf \
        gdc-9-arm-linux-gnueabihf \
        gobjc++-multilib-arm-linux-gnueabihf \
        gdc-9-multilib-arm-linux-gnueabihf \
        gobjc-multilib-arm-linux-gnueabihf \
        gdc-arm-linux-gnueabihf \
        pkg-config-arm-linux-gnueabihf \
        gdc-multilib-arm-linux-gnueabihf

    func_apt -i pkg-config-arm-linux-gnueabihf pkg-config
    func_apt -i binutils-arm-linux-gnueabihf*

    func_chmod 777 /usr/bin/arm-linux-gnueabihf*
    func_chmod 777 /usr/arm-linux-gnueabihf
    func_chmod 777 /usr/lib/arm-linux-gnueabihf

fi

func_cd /usr/bin/

func_execute_sudo rm -rf arm-linux-gnueabihf-*-10

func_execute_sudo ll arm-linux-gnueabihf*

func_cd -

# if false; then
if true; then
    f_lnsf_9() {
        func_cd /usr/bin/
        # # ln -sf file ~/桌面/ # -s 软连接; -r 递归目录 ; -f 强制
        while [ $# -gt 0 ]; do
            # func_execute_sudo ln -sf arm-linux-gnueabihf-${1}-9 arm-linux-gnueabihf-${1}
            if [ -f arm-linux-gnueabihf-${1}-9 ]; then
                func_execute_sudo rm -rf arm-linux-gnueabihf-${1}
            fi
            func_execute_sudo mv -f arm-linux-gnueabihf-${1}-9 arm-linux-gnueabihf-${1}
            # func_cpf arm-linux-gnueabihf-${1}-9 arm-linux-gnueabihf-${1}
            shift
        done
        func_cd -
    }

    f_lnsf_9 gcc g++ gccgo gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-dump gcov-tool
    f_lnsf_9 gdc gfortran gm2
    f_lnsf_9 gnat gnatbind gnatchop gnatclean gnatfind gnathtml gnatkr
    f_lnsf_9 gnatlink gnatls gnatmake gnatname gnatprep gnatxref
fi

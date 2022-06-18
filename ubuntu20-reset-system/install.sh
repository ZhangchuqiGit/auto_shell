#! /bin/bash 

#####################################################
declare -a array_file_bash 
function array_bash_test ()
{
	i=0
	declare -a arraytmp 
	for array_file_bash in $(ls *.sh)
	do
		if [ "${array_file_bash[0]:0:4}" == "bash" ] ; then 
			arraytmp[$i]=${array_file_bash}
			let "i++" 
			echo "NO $i : ${array_file_bash}"
		fi 
	done
	
	for (( i=0 ; i < ${#arraytmp[@]} ; i++ ))
	do
		for (( j=0 ; j < ${#arraytmp[@]} ; j++ ))
		do 
			if [ "${arraytmp[$j]:0:5}" == "bash$i" ] ; then 
				array_file_bash[$i]=${arraytmp[$j]}
				break 
			fi 
		done 
	done
	unset arraytmp j i 
}
array_bash_test


#####################################################

 . ${array_file_bash[0]} -y 
# . bash0_echocmd.sh ${valclash} ${valy} ${valauto} 
#echo_cmd -d -g -f -p -i -r -ii

#####################################################

#scp -r -v ./* zcq@192.168.6.119:/media/zcq/fast-office/ubuntu-source/bash-file-reset-system/

echo_cmd -d -g -f 

echo_cmd -i kernel* lksctp-tools lksctp* ls* -f golang-github-ishidawataru-sctp-dev libusrsctp1 kamailio-sctp-modules 

echo_cmd -d -g -f 

echo_cmd -i libusrsctp-dev libsctp1 libusrsctp-examples libsctp-dev lksctp-tools -f libstat-lsmode-perl -lksctpf code-saturne-include libcatalyst-view-component-subinclude-perl librust-pbkdf2+include-simple-dev node-babel-plugin-array-includes ocaml-batteries-included openwince-include povray-includes ruby-asciidoctor-include-ext ruby-jekyll-include-cache scilab-include libcrack2 

echo_cmd -i libcrystalhd-de -f tcpcryptd tcpflow-nox tcpreplay tcptrace tcpxtract tcpd tcpick tcpslice tcptraceroute tcpdump tcplay tcpspy tcptrack tcpflow tcpreen tcpstat tcputils libosmonetif6 syslog* system-config* syslinux-common libsctp-dev lksctp-tools liblscp* libleveldb1.2-cil liblockfile-bin liblvm2-dev libleveldb1d liblockfile-dev liblv-perl libleveldb-api-java liblockfile-simple-perl liblwip0 libleveldb-cil-dev liblo-dev liblwip-dev libleveldb-dev liblog4ada5 liblwip-doc libleveldb-java liblog4ada6-dev liblwipv6-2 liblexical-accessor-perl liblog4ada-doc liblwipv6-dev 

echo_cmd -d -g -f 

echo_cmd -i lib32atomic1 liblog-fast-perl liblzo2-dev lib32atomic1-amd64-cross lib32atomic1-mips64-cross lib32atomic1-mips64el-cross lib32atomic1-mips64r6-cross lib32atomic1-mips64r6el-cross lib32atomic1-ppc64-cross lib32atomic1-s390x-cross lib32atomic1-sparc64-cross lib32atomic1-x32-cross lib32cilkrts5 lib32gcc-10-dev lib32gcc-10-dev-amd64-cross lib32gcc-10-dev-mips64-cross lib32gcc-10-dev-mips64el-cross lib32gcc-10-dev-mips64r6-cross lib32gcc-10-dev-mips64r6el-cross lib32gcc-10-dev-ppc64-cross lib32gcc-10-dev-s390x-cross lib32gcc-10-dev-sparc64-cross lib32gcc-10-dev-x32-cross lib32gcc-s1 lib32gcc-s1-amd64-cross lib32gcc-s1-mips64-cross lib32gcc-s1-mips64el-cross lib32gcc-s1-mips64r6-cross lib32gcc-s1-mips64r6el-cross lib32gcc-s1-ppc64-cross lib32gcc-s1-s390x-cross lib32gcc-s1-sparc64-cross lib32gcc-s1-x32-cross lib32gfortran-10-dev lib32gfortran-10-dev-amd64-cross lib32gfortran-10-dev-mips64-cross lib32gfortran-10-dev-mips64el-cross lib32gfortran-10-dev-mips64r6-cross lib32gfortran-10-dev-mips64r6el-cross lib32gfortran-10-dev-ppc64-cross lib32gfortran-10-dev-s390x-cross lib32gfortran-10-dev-sparc64-cross lib32gfortran-10-dev-x32-cross lib32go-10-dev lib32go-10-dev-amd64-cross lib32go-10-dev-mips64-cross lib32go-10-dev-mips64el-cross lib32go-10-dev-mips64r6-cross lib32go-10-dev-mips64r6el-cross lib32go-10-dev-ppc64-cross lib32go-10-dev-s390x-cross lib32go-10-dev-sparc64-cross lib32go-10-dev-x32-cross lib32go16 lib32go16-amd64-cross lib32go16-mips64-cross lib32go16-mips64el-cross lib32go16-mips64r6-cross lib32go16-mips64r6el-cross lib32go16-ppc64-cross lib32go16-s390x-cross lib32go16-sparc64-cross lib32go16-x32-cross lib32gomp1 lib32gomp1-amd64-cross lib32gomp1-mips64-cross lib32gomp1-mips64el-cross lib32gomp1-mips64r6-cross lib32gomp1-mips64r6el-cross lib32gomp1-ppc64-cross lib32gomp1-s390x-cross lib32gomp1-sparc64-cross lib32gomp1-x32-cross 

echo_cmd -d -g -f 

 echo_cmd -i lib32gphobos-10-dev lib32gphobos-10-dev-amd64-cross lib32gphobos-10-dev-mips64-cross lib32gphobos-10-dev-mips64el-cross lib32gphobos-10-dev-mips64r6-cross lib32gphobos-10-dev-mips64r6el-cross lib32gphobos-10-dev-ppc64-cross lib32gphobos-10-dev-s390x-cross lib32gphobos-10-dev-x32-cross lib32gphobos76 lib32gphobos76-amd64-cross lib32gphobos76-mips64-cross lib32gphobos76-mips64el-cross lib32gphobos76-mips64r6-cross lib32gphobos76-mips64r6el-cross lib32gphobos76-s390x-cross lib32gphobos76-x32-cross lib32itm1 lib32itm1-amd64-cross lib32itm1-ppc64-cross lib32itm1-s390x-cross lib32itm1-sparc64-cross lib32itm1-x32-cross lib32objc-10-dev lib32objc-10-dev-amd64-cross lib32objc-10-dev-mips64-cross lib32objc-10-dev-mips64el-cross lib32objc-10-dev-mips64r6-cross lib32objc-10-dev-mips64r6el-cross lib32objc-10-dev-ppc64-cross lib32objc-10-dev-s390x-cross lib32objc-10-dev-sparc64-cross lib32objc-10-dev-x32-cross lib32readline8 lib32readline-dev lib32stdc++-10-dev lib32stdc++-10-dev-amd64-cross lib32stdc++-10-dev-mips64-cross lib32stdc++-10-dev-mips64el-cross lib32stdc++-10-dev-mips64r6-cross lib32stdc++-10-dev-mips64r6el-cross lib32stdc++-10-dev-ppc64-cross lib32stdc++-10-dev-s390x-cross lib32stdc++-10-dev-sparc64-cross lib32stdc++-10-dev-x32-cross lib32ubsan1 lib32ubsan1-amd64-cross lib32ubsan1-ppc64-cross lib32ubsan1-s390x-cross lib32ubsan1-sparc64-cross lib32ubsan1-x32-cross lib64asan5 lib64asan5-i386-cross lib64asan5-powerpc-cross lib64asan5-x32-cross lib64asan6 lib64asan6-i386-cross lib64asan6-powerpc-cross lib64asan6-x32-cross lib64atomic1 lib64atomic1-i386-cross lib64atomic1-mips-cross lib64atomic1-mipsel-cross lib64atomic1-mipsr6-cross lib64atomic1-mipsr6el-cross lib64atomic1-powerpc-cross lib64atomic1-x32-cross lib64gcc-10-dev lib64gcc-10-dev-i386-cross lib64gcc-10-dev-mips-cross lib64gcc-10-dev-mipsel-cross lib64gcc-10-dev-mipsr6-cross lib64gcc-10-dev-mipsr6el-cross lib64gcc-10-dev-powerpc-cross lib64gcc-10-dev-x32-cross lib64gcc-s1 lib64gcc-s1-i386-cross lib64gcc-s1-mips-cross lib64gcc-s1-mipsel-cross lib64gcc-s1-mipsr6-cross lib64gcc-s1-mipsr6el-cross lib64gcc-s1-powerpc-cross lib64gcc-s1-x32-cross lib64gfortran-10-dev lib64gfortran-10-dev-i386-cross lib64gfortran-10-dev-mips-cross lib64gfortran-10-dev-mipsel-cross lib64gfortran-10-dev-mipsr6-cross lib64gfortran-10-dev-mipsr6el-cross lib64gfortran-10-dev-powerpc-cross lib64gfortran-10-dev-x32-cross lib64go-10-dev lib64go-10-dev-i386-cross 
 
 echo_cmd -d -g -f 

 echo_cmd -i lib64go-10-dev-mips-cross lib64go-10-dev-mipsel-cross lib64go-10-dev-mipsr6-cross lib64go-10-dev-mipsr6el-cross lib64go-10-dev-powerpc-cross lib64go-10-dev-x32-cross lib64go16 lib64go16-i386-cross lib64go16-mips-cross lib64go16-mipsel-cross lib64go16-mipsr6-cross lib64go16-mipsr6el-cross lib64go16-powerpc-cross lib64go16-x32-cross lib64gomp1 lib64gomp1-i386-cross lib64gomp1-mips-cross lib64gomp1-mipsel-cross lib64gomp1-mipsr6-cross lib64gomp1-mipsr6el-cross lib64gomp1-powerpc-cross lib64gomp1-x32-cross lib64gphobos-10-dev lib64gphobos-10-dev-i386-cross lib64gphobos-10-dev-mips-cross lib64gphobos-10-dev-mipsel-cross lib64gphobos-10-dev-mipsr6-cross lib64gphobos-10-dev-mipsr6el-cross lib64gphobos-10-dev-powerpc-cross lib64gphobos-10-dev-x32-cross lib64objc-10-dev lib64objc-10-dev-i386-cross lib64objc-10-dev-mips-cross lib64objc-10-dev-mipsel-cross lib64objc-10-dev-mipsr6-cross lib64objc-10-dev-mipsr6el-cross lib64objc-10-dev-powerpc-cross lib64objc-10-dev-x32-cross lib64quadmath0 lib64quadmath0-i386-cross lib64quadmath0-x32-cross lib64readline8 lib64readline-dev lib64stdc++-10-dev lib64stdc++-10-dev-i386-cross lib64stdc++-10-dev-mips-cross lib64stdc++-10-dev-mipsel-cross lib64stdc++-10-dev-mipsr6-cross lib64stdc++-10-dev-mipsr6el-cross lib64stdc++-10-dev-powerpc-cross lib64stdc++-10-dev-x32-cross  libaccounts-glib0 libaccounts-glib-dev libaccounts-glib-doc libaccounts-glib-tools libaccounts-qt5-1 libaccounts-qt5-dev libaccounts-qt-doc libaccountsservice0 libaccountsservice-dev libaccountsservice-doc 
 
  #echo_cmd -i libace-6.4.5 libace-dev libace-doc libace-flreactor-6.4.5 libace-flreactor-dev libace-foxreactor-6.4.5 libace-foxreactor-dev libace-htbp-6.4.5 libace-htbp-dev libace-inet-6.4.5 libace-inet-dev libace-inet-ssl-6.4.5 libace-inet-ssl-dev libace-perl libace-rmcast-6.4.5 libace-rmcast-dev libace-ssl-6.4.5 libace-ssl-dev libace-tkreactor-6.4.5 libace-tkreactor-dev libace-tmcast-6.4.5 libace-tmcast-dev libacexml-6.4.5 libacexml-dev libace-xml-utils-6.4.5 libace-xml-utils-dev libace-xtreactor-6.4.5 libace-xtreactor-dev 
 
 #echo_cmd -i libandroid-23-java libandroid-databinding-java libandroid-ddms-java libandroid-json-java libandroid-json-org-java libandroid-json-org-java-doc libandroid-layoutlib-api-java libandroid-tools-analytics-library-java libandroid-tools-annotations-java libandroid-tools-common-java libandroid-tools-dvlib-java libandroid-tools-repository-java libandroid-tools-sdklib-java libandroid-uiautomator-23-java 

echo_cmd -d -g -f 

 echo_cmd -i libanyevent-aggressiveidle-perl libanyevent-cachedns-perl libanyevent-callback-perl libanyevent-connection-perl libanyevent-connector-perl libanyevent-dbd-pg-perl libanyevent-dbi-perl libanyevent-fcgi-perl libanyevent-feed-perl libanyevent-forkobject-perl libanyevent-fork-perl libanyevent-handle-udp-perl libanyevent-httpd-perl libanyevent-http-perl libanyevent-http-scopedclient-perl libanyevent-i3-perl libanyevent-irc-perl libanyevent-memcached-perl libanyevent-perl libanyevent-processor-perl libanyevent-rabbitmq-perl libanyevent-redis-perl libanyevent-serialize-perl libanyevent-termkey-perl libanyevent-tools-perl libanyevent-xmpp-perl libanyevent-yubico-perl libarray-compare-perl libarray-diff-perl libarrayfire-cpu3 libarrayfire-cpu-dev libarrayfire-dev libarrayfire-doc libarrayfire-opencl3 libarrayfire-opencl-dev libarrayfire-unified3 libarrayfire-unified-dev libarray-group-perl libarray-intspan-perl libarray-iterator-perl libarray-printcols-perl libarray-refelem-perl libarray-unique-perl libarray-utils-perl libatombus-perl libatomic1 libatomic1-alpha-cross libatomic1-amd64-cross libatomic1-arm64-cross libatomic1-armel-cross libatomic1-armhf-cross libatomic1-hppa-cross libatomic1-i386-cross libatomic1-m68k-cross libatomic1-mips64-cross libatomic1-mips64el-cross libatomic1-mips64r6-cross libatomic1-mips64r6el-cross libatomic1-mips-cross libatomic1-mipsel-cross libatomic1-mipsr6-cross libatomic1-mipsr6el-cross libatomic1-powerpc-cross libatomic1-ppc64-cross libatomic1-ppc64el-cross libatomic1-riscv64-cross libatomic1-s390x-cross libatomic1-sh4-cross libatomic1-sparc64-cross libatomic1-x32-cross libatomic-ops-dev libatomicparsley0 libatomicparsley-dev libatompub-perl libkubu* libkqueue* libgcc-10-dev libgcc-10-dev-alpha-cross  libgcc-10-dev-amd64-cross libgcc-10-dev-arm64-cross  libgcc-10-dev-armel-cross  libgcc-10-dev-armhf-cross  libgcc-10-dev-hppa-cross  libgcc-10-dev-i386-cross  libgcc-10-dev-m68k-cross  libgcc-10-dev-mips64-cross  libgcc-10-dev-mips64el-cross  libgcc-10-dev-mips64r6-cross  libgcc-10-dev-mips64r6el-cross  libgcc-10-dev-mips-cross  libgcc-10-dev-mipsel-cross  libgcc-10-dev-mipsr6-cross  libgcc-10-dev-mipsr6el-cross libgccjit0 libgcc-10-dev-powerpc-cross libgccjit-10-dev libgcc-10-dev-ppc64-cross libgccjit-10-doc libgcc-10-dev-ppc64el-cross libgccjit-7-dev libgcc-10-dev-riscv64-cross libgccjit-7-doc libgcc-10-dev-s390x-cross libgccjit-8-dev libgcc-10-dev-sh4-cross libgccjit-8-doc libgcc-10-dev-sparc64-cross libgccjit-9-dev libgcc-10-dev-x32-cross libgccjit-9-doc libstdc++-10-pic libstdc++-10-pic-alpha-cross libstdc++-10-pic-amd64-cross libstdc++-10-pic-arm64-cross libstdc++-10-pic-armel-cross 
 
 echo_cmd -d -g -f 

 echo_cmd -i libstdc++-10-pic-armhf-cross libstdc++-10-pic-hppa-cross libstdc++-10-pic-i386-cross libstdc++-10-pic-m68k-cross libstdc++-10-pic-mips64-cross libstdc++-10-pic-mips64el-cross libstdc++-10-pic-mips64r6-cross libstdc++-10-pic-mips64r6el-cross libstdc++-10-pic-mips-cross libstdc++-10-pic-mipsel-cross libstdc++-10-pic-mipsr6-cross libstdc++-10-pic-mipsr6el-cross libstdc++-10-pic-powerpc-cross libstdc++-10-pic-ppc64-cross libstdc++-10-pic-ppc64el-cross libstdc++-10-pic-riscv64-cross libstdc++-10-pic-s390x-cross libstdc++-10-pic-sh4-cross libstdc++-10-pic-sparc64-cross libstdc++-10-pic-x32-cross libstdc++-10-dev libstdc++-10-dev-alpha-cross libstdc++-10-dev-amd64-cross libstdc++-10-dev-arm64-cross libstdc++-10-dev-armel-cross libstdc++-10-dev-armhf-cross libstdc++-10-dev-hppa-cross libstdc++-10-dev-i386-cross libstdc++-10-dev-m68k-cross libstdc++-10-dev-mips64-cross libstdc++-10-dev-mips64el-cross libstdc++-10-dev-mips64r6-cross libstdc++-10-dev-mips64r6el-cross libstdc++-10-dev-mips-cross libstdc++-10-dev-mipsel-cross libstdc++-10-dev-mipsr6-cross libstdc++-10-dev-mipsr6el-cross libstdc++-10-dev-powerpc-cross libstdc++-10-dev-ppc64-cross libstdc++-10-dev-ppc64el-cross libstdc++-10-dev-riscv64-cross libstdc++-10-dev-s390x-cross libstdc++-10-dev-sh4-cross libstdc++-10-dev-sparc64-cross libstdc++-10-dev-x32-cross libstdc++-10-doc gcc-10 gcc-10-aarch64-linux-gnu gcc-10-aarch64-linux-gnu-base gcc-10-alpha-linux-gnu gcc-10-alpha-linux-gnu-base gcc-10-arm-linux-gnueabi gcc-10-arm-linux-gnueabi-base gcc-10-arm-linux-gnueabihf gcc-10-arm-linux-gnueabihf-base gcc-10-base gcc-10-cross-base gcc-10-cross-base-mipsen gcc-10-cross-base-ports gcc-10-doc gcc-10-hppa64-linux-gnu gcc-10-hppa-linux-gnu gcc-10-hppa-linux-gnu-base gcc-10-i686-linux-gnu gcc-10-i686-linux-gnu-base gcc-10-locales gcc-10-m68k-linux-gnu gcc-10-m68k-linux-gnu-base gcc-10-mips64el-linux-gnuabi64 gcc-10-mips64el-linux-gnuabi64-base gcc-10-mips64-linux-gnuabi64 gcc-10-mips64-linux-gnuabi64-base gcc-10-mipsel-linux-gnu gcc-10-mipsel-linux-gnu-base gcc-10-mipsisa32r6el-linux-gnu gcc-10-mipsisa32r6el-linux-gnu-base gcc-10-mipsisa32r6-linux-gnu gcc-10-mipsisa32r6-linux-gnu-base gcc-10-mipsisa64r6el-linux-gnuabi64 gcc-10-mipsisa64r6el-linux-gnuabi64-base gcc-10-mipsisa64r6-linux-gnuabi64 gcc-10-mipsisa64r6-linux-gnuabi64-base gcc-10-mips-linux-gnu gcc-10-mips-linux-gnu-base gcc-10-multilib gcc-10-multilib-arm-linux-gnueabi gcc-10-multilib-arm-linux-gnueabihf gcc-10-multilib-i686-linux-gnu gcc-10-multilib-mips64el-linux-gnuabi64 gcc-10-multilib-mips64-linux-gnuabi64 gcc-10-multilib-mipsel-linux-gnu gcc-10-multilib-mipsisa32r6el-linux-gnu gcc-10-multilib-mipsisa32r6-linux-gnu gcc-10-multilib-mipsisa64r6el-linux-gnuabi64 gcc-10-multilib-mipsisa64r6-linux-gnuabi64 gcc-10-multilib-mips-linux-gnu gcc-10-multilib-powerpc64-linux-gnu gcc-10-multilib-powerpc-linux-gnu gcc-10-multilib-s390x-linux-gnu gcc-10-multilib-sparc64-linux-gnu gcc-10-multilib-x86-64-linux-gnu gcc-10-multilib-x86-64-linux-gnux32 gcc-10-offload-amdgcn gcc-10-offload-nvptx gcc-10-plugin-dev gcc-10-plugin-dev-aarch64-linux-gnu 
 
 echo_cmd -d -g -f 

 echo_cmd -i gcc-10-plugin-dev-alpha-linux-gnu gcc-10-plugin-dev-arm-linux-gnueabi gcc-10-plugin-dev-arm-linux-gnueabihf gcc-10-plugin-dev-hppa-linux-gnu gcc-10-plugin-dev-i686-linux-gnu gcc-10-plugin-dev-m68k-linux-gnu gcc-10-plugin-dev-mips64el-linux-gnuabi64 gcc-10-plugin-dev-mips64-linux-gnuabi64 gcc-10-plugin-dev-mipsel-linux-gnu gcc-10-plugin-dev-mipsisa32r6el-linux-gnu gcc-10-plugin-dev-mipsisa32r6-linux-gnu gcc-10-plugin-dev-mipsisa64r6el-linux-gnuabi64 gcc-10-plugin-dev-mipsisa64r6-linux-gnuabi64 gcc-10-plugin-dev-mips-linux-gnu gcc-10-plugin-dev-powerpc64le-linux-gnu gcc-10-plugin-dev-powerpc64-linux-gnu gcc-10-plugin-dev-powerpc-linux-gnu gcc-10-plugin-dev-riscv64-linux-gnu gcc-10-plugin-dev-s390x-linux-gnu gcc-10-plugin-dev-sh4-linux-gnu gcc-10-plugin-dev-sparc64-linux-gnu gcc-10-plugin-dev-x86-64-linux-gnu gcc-10-plugin-dev-x86-64-linux-gnux32 gcc-10-powerpc64le-linux-gnu gcc-10-powerpc64le-linux-gnu-base gcc-10-powerpc64-linux-gnu gcc-10-powerpc64-linux-gnu-base gcc-10-powerpc-linux-gnu gcc-10-powerpc-linux-gnu-base gcc-10-riscv64-linux-gnu gcc-10-riscv64-linux-gnu-base gcc-10-s390x-linux-gnu gcc-10-s390x-linux-gnu-base gcc-10-sh4-linux-gnu gcc-10-sh4-linux-gnu-base gcc-10-source gcc-10-sparc64-linux-gnu gcc-10-sparc64-linux-gnu-base gcc-10-test-results gcc-10-x86-64-linux-gnu gcc-10-x86-64-linux-gnu-base gcc-10-x86-64-linux-gnux32 gcc-10-x86-64-linux-gnux32-base gcc-9-x86-64-linux-gnux32-base gcc-aarch64-linux-gnu gcc-alpha-linux-gnu gcc-arm-linux-gnueabi gcc-arm-linux-gnueabihf gcc-arm-none-eabi gcc-arm-none-eabi-source gcc-avr gccbrig gccbrig-10 gccbrig-10-i686-linux-gnu gccbrig-10-x86-64-linux-gnu gccbrig-10-x86-64-linux-gnux32 gccbrig-7 gccbrig-8 gccbrig-8-i686-linux-gnu gccbrig-8-x86-64-linux-gnux32 gccbrig-9 gccbrig-9-i686-linux-gnu gccbrig-9-x86-64-linux-gnu gccbrig-9-x86-64-linux-gnux32 gcc-doc gccgo gccgo gccgo-10 gccgo-10-aarch64-linux-gnu gccgo-10-alpha-linux-gnu gccgo-10-arm-linux-gnueabi gccgo-10-arm-linux-gnueabihf gccgo-10-doc

echo_cmd -d -g -f 

 echo_cmd -i gccgo-10-i686-linux-gnu gccgo-10-mips64el-linux-gnuabi64 gccgo-10-mips64-linux-gnuabi64 gccgo-10-mipsel-linux-gnu gccgo-10-mipsisa32r6el-linux-gnu gccgo-10-mipsisa32r6-linux-gnu
 echo_cmd -i gccgo-10-mipsisa64r6el-linux-gnuabi64 gccgo-10-mipsisa64r6-linux-gnuabi64 gccgo-10-mips-linux-gnu gccgo-10-multilib gccgo-10-multilib-i686-linux-gnu gccgo-10-multilib-mips64el-linux-gnuabi64 
 echo_cmd -i gccgo-10-multilib-mips64-linux-gnuabi64 gccgo-10-multilib-mipsel-linux-gnu gccgo-10-multilib-mipsisa32r6el-linux-gnu gccgo-10-multilib-mipsisa32r6-linux-gnu gccgo-10-multilib-mipsisa64r6el-linux-gnuabi64 
 echo_cmd -i gccgo-10-multilib-mipsisa64r6-linux-gnuabi64 gccgo-10-multilib-mips-linux-gnu gccgo-10-multilib-powerpc64-linux-gnu gccgo-10-multilib-powerpc-linux-gnu gccgo-10-multilib-s390x-linux-gnu 
 echo_cmd -i gccgo-10-multilib-sparc64-linux-gnu gccgo-10-multilib-x86-64-linux-gnu gccgo-10-multilib-x86-64-linux-gnux32 gccgo-10-powerpc64le-linux-gnu gccgo-10-powerpc64-linux-gnu gccgo-10-powerpc-linux-gnu 
 echo_cmd -i gccgo-10-riscv64-linux-gnu gccgo-10-s390x-linux-gnu gccgo-10-sh4-linux-gnu gccgo-10-sparc64-linux-gnu gccgo-10-x86-64-linux-gnu gccgo-10-x86-64-linux-gnux32
 
 #echo_cmd -i gccgo-go gccgo-i686-linux-gnu gccgo-mips64el-linux-gnuabi64 gccgo-mips64-linux-gnuabi64 gccgo-mipsel-linux-gnu gccgo-mipsisa32r6el-linux-gnu gccgo-mipsisa32r6-linux-gnu gccgo-mipsisa64r6el-linux-gnuabi64 gccgo-mipsisa64r6-linux-gnuabi64 gccgo-mips-linux-gnu gccgo-multilib gccgo-multilib-i686-linux-gnu gccgo-multilib-mips64el-linux-gnuabi64 gccgo-multilib-mips64-linux-gnuabi64 gccgo-multilib-mipsel-linux-gnu gccgo-multilib-mipsisa32r6el-linux-gnu gccgo-multilib-mipsisa32r6-linux-gnu gccgo-multilib-mipsisa64r6el-linux-gnuabi64 gccgo-multilib-mipsisa64r6-linux-gnuabi64 gccgo-multilib-mips-linux-gnu gccgo-multilib-powerpc64-linux-gnu gccgo-multilib-powerpc-linux-gnu gccgo-multilib-s390x-linux-gnu gccgo-multilib-sparc64-linux-gnu gccgo-multilib-x86-64-linux-gnu gccgo-multilib-x86-64-linux-gnux32 gccgo-powerpc64le-linux-gnu gccgo-powerpc64-linux-gnu gccgo-powerpc-linux-gnu gccgo-riscv64-linux-gnu gccgo-s390x-linux-gnu gccgo-sparc64-linux-gnu gccgo-x86-64-linux-gnu gccgo-x86-64-linux-gnux32 
 
 echo_cmd -d -g -f 

 echo_cmd -i gcc-multilib gcc-multilib-arm-linux-gnueabi gcc-multilib-arm-linux-gnueabihf gcc-multilib-i686-linux-gnu gcc-multilib-mips64el-linux-gnuabi64 gcc-multilib-mips64-linux-gnuabi64 gcc-multilib-mipsel-linux-gnu gcc-multilib-mipsisa32r6el-linux-gnu gcc-multilib-mipsisa32r6-linux-gnu gcc-multilib-mipsisa64r6el-linux-gnuabi64 gcc-multilib-mipsisa64r6-linux-gnuabi64 gcc-multilib-mips-linux-gnu gcc-multilib-powerpc64-linux-gnu gcc-multilib-powerpc-linux-gnu gcc-multilib-s390x-linux-gnu gcc-multilib-sparc64-linux-gnu gcc-multilib-x86-64-linux-gnu gcc-multilib-x86-64-linux-gnux32 
  
  #echo_cmd -i g++++ g++++-10 g++++-10-aarch64-linux-gnu g++++-10-alpha-linux-gnu g++++-10-arm-linux-gnueabi g++++-10-arm-linux-gnueabihf g++++-10-hppa-linux-gnu g++++-10-i686-linux-gnu g++++-10-m68k-linux-gnu g++++-10-mips64el-linux-gnuabi64 g++++-10-mips64-linux-gnuabi64 g++++-10-mipsel-linux-gnu g++++-10-mipsisa32r6el-linux-gnu g++++-10-mipsisa32r6-linux-gnu g++++-10-mipsisa64r6el-linux-gnuabi64 g++++-10-mipsisa64r6-linux-gnuabi64 g++++-10-mips-linux-gnu g++++-10-multilib g++++-10-multilib-arm-linux-gnueabi g++++-10-multilib-arm-linux-gnueabihf g++++-10-multilib-i686-linux-gnu g++++-10-multilib-mips64el-linux-gnuabi64 g++++-10-multilib-mips64-linux-gnuabi64 g++++-10-multilib-mipsel-linux-gnu g++++-10-multilib-mipsisa32r6el-linux-gnu g++++-10-multilib-mipsisa32r6-linux-gnu g++++-10-multilib-mipsisa64r6el-linux-gnuabi64 g++++-10-multilib-mipsisa64r6-linux-gnuabi64 g++++-10-multilib-mips-linux-gnu g++++-10-multilib-powerpc64-linux-gnu g++++-10-multilib-powerpc-linux-gnu g++++-10-multilib-s390x-linux-gnu g++++-10-multilib-sparc64-linux-gnu g++++-10-multilib-x86-64-linux-gnu g++++-10-multilib-x86-64-linux-gnux32 g++++-10-powerpc64le-linux-gnu g++++-10-powerpc64-linux-gnu g++++-10-powerpc-linux-gnu g++++-10-riscv64-linux-gnu g++++-10-s390x-linux-gnu g++++-10-sh4-linux-gnu g++++-10-sparc64-linux-gnu g++++-10-x86-64-linux-gnu g++++-10-x86-64-linux-gnux32 g++++-aarch64-linux-gnu g++++-alpha-linux-gnu g++++-arm-linux-gnueabi g++++-arm-linux-gnueabihf g++++-hppa-linux-gnu g++++-i686-linux-gnu g++++-m68k-linux-gnu g++++-mingw-w64 g++++-mingw-w64-i686 g++++-mingw-w64-x86-64 g++++-mips64el-linux-gnuabi64 g++++-mips64-linux-gnuabi64 g++++-mipsel-linux-gnu g++++-mipsisa32r6el-linux-gnu g++++-mipsisa32r6-linux-gnu g++++-mipsisa64r6el-linux-gnuabi64 g++++-mipsisa64r6-linux-gnuabi64 g++++-mips-linux-gnu g++++-multilib g++++-multilib-arm-linux-gnueabi g++++-multilib-arm-linux-gnueabihf g++++-multilib-i686-linux-gnu g++++-multilib-mips64el-linux-gnuabi64 g++++-multilib-mips64-linux-gnuabi64 g++++-multilib-mipsel-linux-gnu g++++-multilib-mipsisa32r6el-linux-gnu g++++-multilib-mipsisa32r6-linux-gnu g++++-multilib-mipsisa64r6el-linux-gnuabi64 g++++-multilib-mipsisa64r6-linux-gnuabi64 g++++-multilib-mips-linux-gnu g++++-multilib-powerpc64-linux-gnu 
 
 echo_cmd -d -g -f 

#echo_cmd -i g++++-multilib-powerpc-linux-gnu g++++-multilib-s390x-linux-gnu g++++-multilib-sparc64-linux-gnu g++++-multilib-x86-64-linux-gnu g++++-multilib-x86-64-linux-gnux32 g++++-powerpc64le-linux-gnu g++++-powerpc64-linux-gnu g++++-powerpc-linux-gnu g++++-riscv64-linux-gnu g++++-s390x-linux-gnu g++++-sh4-linux-gnu g++++-sparc64-linux-gnu g++++-x86-64-linux-gnux32 

echo_cmd -i libnet1 libnet1-dbg libnet1-dev libnet1-doc libnet-abuse-utils-perl libnet-address-ip-local-perl libnetaddr-ip-perl libnet-akamai-perl libnet-akismet-perl libnet-amazon-ec2-perl libnet-amazon-perl libnet-amazon-s3-perl libnet-amazon-s3-tools-perl libnet-amqp-perl libnet-appliance-session-perl libnetapp-perl libnet-arp-perl libnet-async-fastcgi-perl libnet-async-http-perl libnet-async-irc-perl libnet-async-matrix-perl libnet-async-tangence-perl libnetbeans-cvsclient-java libnet-bluetooth-perl libnet-bonjour-perl libnetcdf15 libnetcdf-c++4 libnetcdf-c++4-1 libnetcdf-c++4-dev libnetcdf-c++4-doc libnetcdf-cxx-legacy-dev libnetcdf-dev libnetcdff7 libnetcdff-dev libnetcdff-doc libnetcdf-mpi-13 libnetcdf-mpi-dev libnetcdf-pnetcdf-13 libnetcdf-pnetcdf-dev libnetcf1 libnetcf1-dbg libnetcf-dev libnet-cidr-lite-perl libnet-cidr-perl libnet-cidr-set-perl libnet-cisco-mse-rest-perl libnet-citadel-perl libnetclasses0 libnetclasses-dev libnet-cli-interact-perl libnet-cpp2 libnet-cpp-dev libnet-cpp-doc libnet-cups-perl libnet-dns-perl libnet-dns-resolver-mock-perl libnet-dns-resolver-programmable-perl libnet-dns-sec-perl libnet-domain-tld-perl libnetdot-client-rest-perl libnet-dpap-client-perl libnet-dropbox-api-perl libnet-duo-perl libnet-easytcp-perl libnet-epp-perl libnet-facebook-oauth2-perl libnet-fastcgi-perl libnetfilter-acct1 libnetfilter-acct-dev libnetfilter-conntrack3 libnetfilter-conntrack-dev libnetfilter-cthelper0 libnetfilter-cthelper0-dbg libnetfilter-cthelper0-dev libnetfilter-cttimeout1 libnetfilter-cttimeout1-dbg libnetfilter-cttimeout-dev libnetfilter-log1 libnetfilter-log1-dbg libnetfilter-log-dev libnetfilter-queue1 libnetfilter-queue1-dbg libnetfilter-queue-dev libnet-finger-perl libnet-frame-device-perl libnet-frame-dump-perl libnet-frame-layer-icmpv6-perl libnet-frame-layer-ipv6-perl libnet-frame-perl libnet-frame-simple-perl libnet-freedb-perl libnet-github-perl libnet-gmail-imap-label-perl libnet-google-authsub-perl libnet-google-safebrowsing2-perl libnet-gpsd3-perl libnet-hotline-perl libnethttpd-ocaml-dev libnet-http-perl libnet-https-any-perl libnet-httpserver-perl libnet-https-nb-perl libnet-opensrs-perl libnet-openssh-compat-perl libnet-openssh-parallel-perl libnet-openssh-perl 

echo_cmd -d -g -f

echo_cmd -i lksctp-tools -f -y golang-github-ishidawataru-sctp-dev libusrsctp1 kamailio-sctp-modules libusrsctp-dev libsctp1 -f -y libusrsctp-examples libsctp-dev lksctp-tools -f -y pm-utils dpkg dpkg* -f -y -i apt apt* aptitude aptitude* gir* libsctp-dev libtcp* udp* tcp* linux-azure linux-azure-cloud-tools-5.4.0-1041 linux-azure-cloud-tools-5.4.0-1043* linux-azure-tools-5.4.0-1041* linux-buildinfo-5.10.0-1019-oem linux-bas* linux-azure-tools-5.4.0-1043* libgcc-10-dev libgcc-10-dev* liblscp* linux-aws-headers-5.4.0-1041* linux-aws-tools-5.4.0-1041 -f -y wget wget* curl curl* git git-all gitsome libsctp1 i fcitx-bin fcitx-table fcitx-config-gtk fcitx-frontend-all qt5-default qtcreator qml-module-qtquick-controls libg15-dev*

echo_cmd -d -g -f

echo_cmd -i binutils-arm-linux-gnueabihf gdc-9-multilib-arm-linux-gnueabihf binutils-arm-linux-gnueabihf-dbg 
echo_cmd -i gdc-arm-linux-gnueabihf cpp-10-arm-linux-gnueabihf gdc-multilib-arm-linux-gnueabihf cpp-8-arm-linux-gnueabihf gfortran-10-arm-linux-gnueabihf 
cpp-9-arm-linux-gnueabihf     gfortran-10-multilib-arm-linux-gnueabihf
echo_cmd -i cpp-arm-linux-gnueabihf       gfortran-8-arm-linux-gnueabihf   g++-10-arm-linux-gnueabihf    gfortran-8-multilib-arm-linux-gnueabihf 
echo_cmd -i g++-10-multilib-arm-linux-gnueabihf       gfortran-9-arm-linux-gnueabihf          g++-8-arm-linux-gnueabihf     gfortran-9-multilib-arm-linux-gnueabihf 
echo_cmd -i g++-8-multilib-arm-linux-gnueabihf        gfortran-arm-linux-gnueabihf            g++-9-arm-linux-gnueabihf     gfortran-multilib-arm-linux-gnueabihf   
echo_cmd -i g++-9-multilib-arm-linux-gnueabihf        gm2-10-arm-linux-gnueabihf  g++-arm-linux-gnueabihf       gm2-9-arm-linux-gnueabihf   
echo_cmd -i gcc-10-arm-linux-gnueabihf    gm2-arm-linux-gnueabihf     gcc-10-arm-linux-gnueabihf-base           g++-multilib-arm-linux-gnueabihf        
echo_cmd -i gcc-10-multilib-arm-linux-gnueabihf       gnat-10-arm-linux-gnueabihf gcc-10-plugin-dev-arm-linux-gnueabihf     gnat-8-arm-linux-gnueabihf  
echo_cmd -i gcc-8-arm-linux-gnueabihf     gnat-8-sjlj-arm-linux-gnueabihf         gcc-8-arm-linux-gnueabihf-base            gnat-9-arm-linux-gnueabihf  
echo_cmd -i gcc-8-multilib-arm-linux-gnueabihf        gobjc++-10-arm-linux-gnueabihf          gcc-8-plugin-dev-arm-linux-gnueabihf      gobjc-10-arm-linux-gnueabihf            
echo_cmd -i gcc-9-arm-linux-gnueabihf     gobjc++-10-multilib-arm-linux-gnueabihf gcc-9-arm-linux-gnueabihf-base            gobjc-10-multilib-arm-linux-gnueabihf   
echo_cmd -i gcc-9-multilib-arm-linux-gnueabihf        gobjc++-8-arm-linux-gnueabihf           gcc-9-plugin-dev-arm-linux-gnueabihf      gobjc-8-arm-linux-gnueabihf 
echo_cmd -i gcc-arm-linux-gnueabihf       gobjc++-8-multilib-arm-linux-gnueabihf  gccgo-10-arm-linux-gnueabihf  gobjc-8-multilib-arm-linux-gnueabihf    
echo_cmd -i gccgo-8-arm-linux-gnueabihf   gobjc++-9-arm-linux-gnueabihf           gccgo-9-arm-linux-gnueabihf   gobjc-9-arm-linux-gnueabihf 
echo_cmd -i gccgo-arm-linux-gnueabihf     gobjc++-9-multilib-arm-linux-gnueabihf  gcc-multilib-arm-linux-gnueabihf      
echo_cmd -i gdc-10-multilib-arm-linux-gnueabihf       gobjc-arm-linux-gnueabihf       gobjc-9-multilib-arm-linux-gnueabihf    gdc-10-arm-linux-gnueabihf    gobjc++-arm-linux-gnueabihf 
echo_cmd -i gdc-8-arm-linux-gnueabihf     gobjc++-multilib-arm-linux-gnueabihf    gdc-8-multilib-arm-linux-gnueabihf       
echo_cmd -i gobjc-multilib-arm-linux-gnueabihf      gdc-9-arm-linux-gnueabihf     pkg-config-arm-linux-gnueabihf   

echo_cmd -d -g -f

echo_cmd -i gcc-10 gcc-10-multilib  gcc-10-multilib-powerpc-linux-gnu
echo_cmd -i gcc-10-aarch64-linux-gnu      gcc-10-multilib-s390x-linux-gnu
echo_cmd -i gcc-10-aarch64-linux-gnu-base     gcc-10-multilib-sparc64-linux-gnu
echo_cmd -i gcc-10-alpha-linux-gnu       gcc-10-multilib-x86-64-linux-gnu
echo_cmd -i gcc-10-alpha-linux-gnu-base      gcc-10-multilib-x86-64-linux-gnux32
echo_cmd -i gcc-10-arm-linux-gnueabi      gcc-10-offload-amdgcn
echo_cmd -i gcc-10-arm-linux-gnueabi-base     gcc-10-offload-nvptx
echo_cmd -i gcc-10-arm-linux-gnueabihf      gcc-10-plugin-dev
echo_cmd -i gcc-10-arm-linux-gnueabihf-base     gcc-10-plugin-dev-aarch64-linux-gnu
echo_cmd -i gcc-10-base          gcc-10-plugin-dev-alpha-linux-gnu
echo_cmd -i gcc-10-cross-base        gcc-10-plugin-dev-arm-linux-gnueabi
echo_cmd -i gcc-10-cross-base-mipsen      gcc-10-plugin-dev-arm-linux-gnueabihf
echo_cmd -i gcc-10-cross-base-ports       gcc-10-plugin-dev-hppa-linux-gnu
echo_cmd -i gcc-10-doc          gcc-10-plugin-dev-i686-linux-gnu
echo_cmd -i gcc-10-hppa64-linux-gnu       gcc-10-plugin-dev-m68k-linux-gnu
echo_cmd -i gcc-10-hppa-linux-gnu       gcc-10-plugin-dev-mips64el-linux-gnuabi64
echo_cmd -i gcc-10-hppa-linux-gnu-base      gcc-10-plugin-dev-mips64-linux-gnuabi64
echo_cmd -i gcc-10-i686-linux-gnu       gcc-10-plugin-dev-mipsel-linux-gnu
echo_cmd -i gcc-10-i686-linux-gnu-base      gcc-10-plugin-dev-mipsisa32r6el-linux-gnu
echo_cmd -i gcc-10-locales         gcc-10-plugin-dev-mipsisa32r6-linux-gnu
echo_cmd -i gcc-10-m68k-linux-gnu       gcc-10-plugin-dev-mipsisa64r6el-linux-gnuabi64
echo_cmd -i gcc-10-m68k-linux-gnu-base      gcc-10-plugin-dev-mipsisa64r6-linux-gnuabi64
echo_cmd -i gcc-10-mips64el-linux-gnuabi64     gcc-10-plugin-dev-mips-linux-gnu
echo_cmd -i gcc-10-mips64el-linux-gnuabi64-base    gcc-10-plugin-dev-powerpc64le-linux-gnu
echo_cmd -i gcc-10-mips64-linux-gnuabi64     gcc-10-plugin-dev-powerpc64-linux-gnu
echo_cmd -i gcc-10-mips64-linux-gnuabi64-base    gcc-10-plugin-dev-powerpc-linux-gnu
echo_cmd -i gcc-10-mipsel-linux-gnu       gcc-10-plugin-dev-riscv64-linux-gnu
echo_cmd -i gcc-10-mipsel-linux-gnu-base     gcc-10-plugin-dev-s390x-linux-gnu
echo_cmd -i gcc-10-mipsisa32r6el-linux-gnu     gcc-10-plugin-dev-sh4-linux-gnu
echo_cmd -i gcc-10-mipsisa32r6el-linux-gnu-base    gcc-10-plugin-dev-sparc64-linux-gnu
echo_cmd -i gcc-10-mipsisa32r6-linux-gnu     gcc-10-plugin-dev-x86-64-linux-gnu
echo_cmd -i gcc-10-mipsisa32r6-linux-gnu-base    gcc-10-plugin-dev-x86-64-linux-gnux32
echo_cmd -i gcc-10-mipsisa64r6el-linux-gnuabi64    gcc-10-powerpc64le-linux-gnu
echo_cmd -i gcc-10-mipsisa64r6el-linux-gnuabi64-base  gcc-10-powerpc64le-linux-gnu-base
echo_cmd -i gcc-10-mipsisa64r6-linux-gnuabi64    gcc-10-powerpc64-linux-gnu
echo_cmd -i gcc-10-mipsisa64r6-linux-gnuabi64-base   gcc-10-powerpc64-linux-gnu-base
echo_cmd -i gcc-10-mips-linux-gnu       gcc-10-powerpc-linux-gnu
echo_cmd -i gcc-10-mips-linux-gnu-base      gcc-10-powerpc-linux-gnu-base
echo_cmd -i gcc-10-multilib         gcc-10-riscv64-linux-gnu
echo_cmd -i gcc-10-multilib-arm-linux-gnueabi    gcc-10-riscv64-linux-gnu-base
echo_cmd -i gcc-10-multilib-arm-linux-gnueabihf    gcc-10-s390x-linux-gnu
echo_cmd -i gcc-10-multilib-i686-linux-gnu     gcc-10-s390x-linux-gnu-base
echo_cmd -i gcc-10-multilib-mips64el-linux-gnuabi64   gcc-10-sh4-linux-gnu
echo_cmd -i gcc-10-multilib-mips64-linux-gnuabi64   gcc-10-sh4-linux-gnu-base
echo_cmd -i gcc-10-multilib-mipsel-linux-gnu    gcc-10-source
echo_cmd -i gcc-10-multilib-mipsisa32r6el-linux-gnu   gcc-10-sparc64-linux-gnu
echo_cmd -i gcc-10-multilib-mipsisa32r6-linux-gnu   gcc-10-sparc64-linux-gnu-base
echo_cmd -i gcc-10-multilib-mipsisa64r6el-linux-gnuabi64 gcc-10-test-results
echo_cmd -i gcc-10-multilib-mipsisa64r6-linux-gnuabi64  gcc-10-x86-64-linux-gnu-base
echo_cmd -i gcc-10-multilib-mips-linux-gnu     gcc-10-x86-64-linux-gnux32
echo_cmd -i gcc-10-multilib-powerpc64-linux-gnu    gcc-10-x86-64-linux-gnux32-base 
echo_cmd -i g++-10 g++-10-multilib g++-10-multilib-mipsel-linux-gnu g++-10-aarch64-linux-gnu     
echo_cmd -i g++-10-multilib-mipsisa32r6el-linux-gnu g++-10-alpha-linux-gnu 
echo_cmd -i g++-10-multilib-mipsisa32r6-linux-gnu g++-10-arm-linux-gnueabi g++-10-multilib-mipsisa64r6el-linux-gnuabi64
echo_cmd -i g++-10-arm-linux-gnueabihf    g++-10-multilib-mipsisa64r6-linux-gnuabi64
echo_cmd -i g++-10-hppa-linux-gnu       g++-10-multilib-mips-linux-gnu g++-10-i686-linux-gnu     
echo_cmd -i g++-10-multilib-powerpc64-linux-gnu g++-10-m68k-linux-gnu       g++-10-multilib-powerpc-linux-gnu 
echo_cmd -i g++-10-mips64el-linux-gnuabi64    g++-10-multilib-s390x-linux-gnu g++-10-mips64-linux-gnuabi64    
echo_cmd -i g++-10-multilib-sparc64-linux-gnu g++-10-mipsel-linux-gnu 
echo_cmd -i g++-10-multilib-x86-64-linux-gnu g++-10-mipsisa32r6el-linux-gnu    g++-10-multilib-x86-64-linux-gnux32 
echo_cmd -i g++-10-mipsisa32r6-linux-gnu     g++-10-powerpc64le-linux-gnu 
echo_cmd -i g++-10-mipsisa64r6el-linux-gnuabi64   g++-10-powerpc64-linux-gnu g++-10-mipsisa64r6-linux-gnuabi64   
echo_cmd -i g++-10-powerpc-linux-gnu g++-10-mips-linux-gnu       g++-10-riscv64-linux-gnu 
echo_cmd -i g++-10-multilib        g++-10-s390x-linux-gnu g++-10-multilib-arm-linux-gnueabi    g++-10-sh4-linux-gnu 
echo_cmd -i g++-10-multilib-arm-linux-gnueabihf g++-10-sparc64-linux-gnu g++-10-multilib-i686-linux-gnu g++-10-x86-64-linux-gnu 
echo_cmd -i g++-10-multilib-mips64el-linux-gnuabi64  g++-10-x86-64-linux-gnux32 	
echo_cmd -i g++ gcc gcc-8 gcc-8-multilib g++-8 g++-8-multilib gcc-9 gcc-9-multilib g++-9 g++-9-multilib 
	
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 80
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100
	
	echo_cmd -p universe 
	echo_cmd -i vim vim-* vpnc vpnc-* axel rsync openssh-server unrar unrar* p7zip-full p7zip-rar rar zip zip*  
	sudo apt-get update --fix-missing
	echo_cmd -i python3 python3.7 python3.8 python3.7* python3.8* kchmviewer tree   python  python2 gedit gedit* 
	sudo apt-get update --fix-missing
	echo_cmd -i net-tools ubuntu-mobile-icons ubuntu-release-upgrader* 
	echo_cmd -i ubuntu-settings ubuntu-wallpape* rpm  http*
	echo_cmd -i libsctp-dev lksctp-tools
	 

#!/bin/bash

Shell_function=function_2021.10.02.10.sh
Ubuntu_install=ubuntu-install.sh
Clashlinuxamd64=clash-linux-amd64*
Sources2020=sources2020.list
Clion_file=clion-2021.2

################################################################
if [ -z "${Sudo}" ]; then
	Sudo="sudo"
fi
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

if [ -z "${Rootpath}" ]; then
	Rootpath=$1
	if [ ! -d "${Rootpath}" ]; then
		Rootpath=""
	fi
	if [ -z "${Rootpath}" ]; then
		Rootpath=$(pwd)
	fi
fi

################################################################
Shell_function=${Rootpath}/${Shell_function}
. ${Shell_function}

Ubuntu_install=${Rootpath}/${Ubuntu_install}

######################### function() ##############################
func_clash() {
	func_cd ../clash/${Clashlinuxamd64}/
	./clash.sh
	func_cd ${Rootpath}
}

######################### function() ##############################
func_sources_list() { #修改软件下载源
	if [ -f "../${Sources2020}" ]; then
		local Time=""
		Time="$(date +%Y.%m.%d_%H.%M.%S)"
		func_cpf /etc/apt/sources.list /etc/apt/sources.list_backup_${Time}
		func_cpf ../${Sources2020} /etc/apt/sources.list
	else
		func_gedit /etc/apt/sources.list
	fi
	func_apt -d -g -f -a
}

######################### function() ##############################
func_deb_install() {
	func_echo "安装 deb "

	func_apt_repository "ppa:djcj/hybrid"
	func_apt -p universe

	func_apt -d -g -f

	func_apt -i bash bash* zsh zsh* autojump
	func_apt -i sudo gedit gedit-* vim vim-* vpnc vpnc-scripts unrar unrar-free
	func_apt -i zip ziptool tree p7zip-full p7zip-rar rar dpkg dpkg*
	func_apt -i net-tools ubuntu-mobile-icons ubuntu-release-upgrader*
	func_apt -i ubuntu-settings ubuntu-wallpape* rpm http* kchmviewer
	func_apt -i libsctp-dev lksctp-tools axel rsync openssh-server
	func_apt -i libusrsctp1 kamailio-sctp-modules libusrsctp-dev
	func_apt -i libusrsctp-examples pm-utils apt apt* aptitude aptitude* udp*
	func_apt -i libtcp* tcpcryptd tcpd tcpdump tcpflow tcpflow-nox tcpick tcplay
	func_apt -i tcpreen tcpreplay tcpslice tcpspy tcpstat tcptrace
	func_apt -i tcptraceroute tcptrack tcputils tcpxtract
	func_apt -i wget wget* curl curl* git git-all gitsome libsctp1 liblscp*
	func_apt -i kmod ethtool ifupdown htop iputils-ping
	func_apt -i pkg-config libudev-dev libudev1 libsdl2-dev vlc vlc-*

	func_apt -i python2 python2-dbg python2-dev python2-doc python2-minimal \
		python2.7 python2.7-dbg python2.7-dev python2.7-doc python2.7-minimal
	func_apt -i python3 python3.8 python3.8-dbg python3.8-dev \
		python3.8-full python3.8-minimal python3.8-venv

	func_apt -i fcitx fcitx-bin fcitx-config-common fcitx-config-gtk \
		fcitx-data fcitx-dbus-status fcitx-ui-classic \
		fcitx-frontend-fbterm fcitx-frontend-qt5 fcitx-frontend-all \
		fcitx-module-dbus fcitx-modules fcitx-table
	func_apt -i fcitx-baidupinyin

	#execute_sudo zhcon --utf8 --drv=vga # 启动 zhcon，root 模式，中文乱码。
	#execute_sudo zhcon --utf8 --drv=fb # 启动 zhcon，root 模式，中文显示正常。
	#execute zhcon --utf8 --drv=auto # 启动 zhcon，user 模式，中文显示正常。
	sys_install -i zhcon                                              # 解决 控制终端 (/dev/tty) 中文乱码
	sys_install -i fbterm                                             # 支持中文显示的控制台 fcitx-frontend-fbterm

	func_apt -i language-pack-zh-hans language-pack-zh-hans-base      # 中文语言包
	func_apt -i language-pack-en language-pack-en-base                # 英文语言包（默认一般都会安装）
	#	func_execute_sudo locale-gen en_US.UTF-8
	#	func_execute_sudo locale-gen zh_CN.UTF-8   # 添加中文支持 zh_CN.UTF-8 UTF-8
	#	func_execute_sudo locale-gen zh_CN.GBK     # 添加中文支持 zh_CN.GBK GBK
	#	func_execute_sudo locale-gen zh_CN.GB18030 # 添加中文支持 zh_CN.GB18030 GB18030
	#	func_execute_sudo locale-gen zh_CN # 添加中文支持 zh_CN GB2312

	func_echo "输出主机的硬件架构: $ uname -m : $(uname -m)" # x86_64

	func_apt -i make cmake qemu-user-static

	func_apt -i libgcc1 \
		libgcc-7-dev \
		libgcc-8-dev libgcc-8-dev-amd64-cross \
		libgcc-9-dev libgcc-9-dev-amd64-cross \
		libgccjit0 \
		libgccjit-7-dev libgccjit-7-doc \
		libgccjit-8-dev libgccjit-8-doc \
		libgccjit-9-dev libgccjit-9-doc \
		libgcc-s1 libgcc-s1-amd64-cross

	func_apt -i gcc \
		gcc-avr gcc-doc \
		gcc-multilib \
		gcc-multilib-x86-64-linux-gnu \
		gcc-multilib-x86-64-linux-gnux32 \
		gcc-offload-nvptx \
		gcc-opt \
		gcc-python3-dbg-plugin \
		gcc-python3-plugin \
		gcc-python-plugin-doc \
		gcc-snapshot \
		gcc-x86-64-linux-gnux32 \
		gcc-xtensa-lx106
	func_apt -i g++ \
		g++-multilib \
		g++-multilib-x86-64-linux-gnu \
		g++-multilib-x86-64-linux-gnux32 \
		g++-x86-64-linux-gnux32

	func_apt -i gcc-7 gcc-7-offload-nvptx gcc-7-test-results gcc-7-base \
		gcc-7-locales gcc-7-plugin-dev gcc-7-doc gcc-7-multilib gcc-7-source
	func_apt -i g++-7 g++-7-multilib

	func_apt -i gcc-8 \
		gcc-8-base gcc-8-cross-base gcc-8-cross-base-ports \
		gcc-8-doc gcc-8-locales \
		gcc-8-multilib \
		gcc-8-multilib-x86-64-linux-gnux32 \
		gcc-8-plugin-dev \
		gcc-8-plugin-dev-x86-64-linux-gnux32 \
		gcc-8-source gcc-8-test-results \
		gcc-8-x86-64-linux-gnux32 gcc-8-x86-64-linux-gnux32-base
	func_apt -i g++-8 \
		g++-8-multilib \
		g++-8-multilib-x86-64-linux-gnux32 \
		g++-8-x86-64-linux-gnux32

	func_apt -i gcc-9 \
		gcc-9-base gcc-9-cross-base gcc-9-cross-base-mipsen gcc-9-cross-base-ports \
		gcc-9-doc gcc-9-locales \
		gcc-9-multilib \
		gcc-9-multilib-x86-64-linux-gnu \
		gcc-9-multilib-x86-64-linux-gnux32 \
		gcc-9-offload-nvptx \
		gcc-9-plugin-dev \
		gcc-9-plugin-dev-x86-64-linux-gnu \
		gcc-9-plugin-dev-x86-64-linux-gnux32 \
		gcc-9-source gcc-9-test-results \
		gcc-9-x86-64-linux-gnu-base gcc-9-x86-64-linux-gnux32 gcc-9-x86-64-linux-gnux32-base
	func_apt -i g++-9 \
		g++-9-multilib \
		g++-9-multilib-x86-64-linux-gnu \
		g++-9-multilib-x86-64-linux-gnux32 \
		g++-9-x86-64-linux-gnu \
		g++-9-x86-64-linux-gnux32

	func_echo "安装多版本 gcc 和 g++，并共存"
	func_apt -i dpkg dpkg*
	func_execute_sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 80
	func_execute_sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 90
	func_execute_sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 100

	func_execute_sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 80
	func_execute_sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 90
	func_execute_sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 100

	func_echo "选择 gcc 和 g++ 版本"
	func_execute_sudo update-alternatives --config gcc
	func_execute_sudo update-alternatives --config g++

	func_apt -a
}

######################### function() ##############################
func_deepin_wine() {
	func_echo "安装 deepin-wine"
	func_execute ../deepin-wine/deepin-wine-install.sh ${Rootpath}
}

func_dep2020() {
	func_echo "安装 deb2020"
	func_execute ../deb2020/deb2020-install.sh ${Rootpath}
}

######################### function() ##############################
func_gnome() {
	func_echo "使用 Tweaks 对 gnome 进行美化 "
	func_apt -i gir1.2-gtop-* gir1.2-gtk-* gir1.2-playerctl-*
	func_apt -i gir1.2-gtkclutter-* gir1.2-clutter-* gir1.2-clutter-gst-*
	func_apt -i gtk2-engines gtk2-engines* gtk3-engines*
	func_apt -i papirus-icon-theme

	func_apt_repository "ppa:daniruiz/flat-remix" "ppa:papirus/papirus"
	func_apt -i gnome-tweaks gnome-tweak-tool

	func_echo "安装 chrome-gnome-shell，火狐和谷歌都能用 gnome 插件"
	func_apt -i chrome-gnome-shell

	func_apt -i gnome-shell gnome-shell-common \
		gnome-shell-extensions \
		gnome-shell-extension-appindicator \
		gnome-shell-extension-autohidetopbar \
		gnome-shell-extension-dash-to-panel \
		gnome-shell-extension-desktop-icons \
		gnome-shell-extension-draw-on-your-screen \
		gnome-shell-extension-kimpanel \
		gnome-shell-extensions \
		gnome-shell-extension-shortcuts \
		gnome-shell-extension-system-monitor \
		gnome-shell-extension-top-icons-plus \
		gnome-shell-extension-weather

	func_apt -i gnome-backgrounds \
		gnome-human-icon-theme \
		gnome-humility-icon-theme \
		gnome-icon-theme* \
		gnome-theme-gilouche \
		gnome-themes-extra gnome-themes-extra-data \
		gnome-themes-standard \
		gnome-themes-ubuntu \
		gnome-weather \
		gnome-wine-icon-theme \
		gnome-wise-icon-theme
}

######################### function() ##############################
func_terminator() {
	func_echo "换 terminator "
	func_apt_repository "ppa:gnome-terminator"
	func_apt -i terminator
	func_cpf ../terminator /home/$USER/.config/
}

func_ohmyzsh() {
	func_echo "打造命令行工具oh-my-zsh"
	func_apt -i bash bash* zsh zsh*
	local ohmyzsh="/home/$USER/.oh-my-zsh"
	func_execute_sudo rm -rf ${ohmyzsh}
	func_apt -i zsh*
	func_execute zsh --version
	func_apt -i curl curl*
	func_echo -c "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	if [ ! -d "${ohmyzsh}" ]; then
		sh ../.oh-my-zsh/tools/install.sh
	fi
	if [ -d "${ohmyzsh}" ]; then
		func_execute_sudo chmod -R 775 ${ohmyzsh}
	fi
	if [ -f "/home/$USER/.zshrc" ]; then
		func_execute_sudo chmod 777 /home/$USER/.zshrc*
	fi
	func_cpf "../zsh-syntax-highlighting" "${ohmyzsh}/custom/plugins/"
	func_cpf "../zsh-autosuggestions" "${ohmyzsh}/custom/plugins/"

	echo " modify ~/.oh-my-zsh : 
	...
ZSH_THEME=\"ys\"
	...
plugins=( 
 rails  
 ruby 
 autojump 
 git 
 golang
 history 
 history-substring-search 
 cake 
 pow
 zsh-autosuggestions 
 zsh-syntax-highlighting  
)
	...
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval \"\$(dircolors -b ~/.dircolors)\" || eval \"\$(dircolors -b)\"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi
# Example aliases
# alias zshconfig=\"mate ~/.zshrc\"
# alias ohmyzsh=\"mate ~/.oh-my-zsh\"
alias ll='ls -alF'
alias la='ls -a'
alias l='ls -CF'
#alias notepad++='notepad-plus-plus'
#alias notepad='notepad-plus-plus'
#alias caj='cd ~/ && ./CAJViewer.AppImage'
"
	func_gedit ~/.oh-my-zsh
}

######################### function() ##############################
func_win_fonts() {
	func_echo "复制 Windows-fonts 字体[*.ttf]到 /usr/share/fonts[系统字体位置] "
	func_execute_sudo chmod -R 777 /usr/share/fonts
	func_cpf ../Windows-fonts /usr/share/fonts/
	echo "生成索引信息"
	func_execute_sudo mkfontscale /usr/share/fonts/Windows-fonts
	func_echo -c "${Sudo} mkfontdir /usr/share/fonts/Windows-fonts &>/dev/null"
	${Sudo} mkfontdir /usr/share/fonts/Windows-fonts &>/dev/null
	echo "更新字体缓存"
	func_execute_sudo fc-cache
}
func_shell_xxshrc() {
	local file_shrc="$1"
	if [ -e "${file_shrc}" ]; then
		${Sudo} chmod -R 777 ${file_shrc}
		func_echo -c "sed -i -E -e '/^alias clash=/d' -e '/^alias h=/d'
		-e '/^alias cpp=/d' -e '/^alias linuxcpp=/d'
		-e '/^alias clion=/d' -e '/^alias clion-root=/d'
		-e '/^alias qt5=/d' ${file_shrc}"
		sed -i -E -e '/^alias clash=/d' -e '/^alias h=/d' -e '/^alias cpp=/d' -e '/^alias linuxcpp=/d' \
			-e '/^alias clion=/d' -e '/^alias clion-root=/d' -e '/^alias qt5=/d' ${file_shrc}
		echo -e "
alias clash='/home/$USER/.config/clash/clash-linux-amd64*'
alias h='history'
alias cpp='bash /home/$USER/clion_launch_cpp.sh'
alias clion='sh /home/$USER/.config/JetBrains/CLion2021.2/bin/clion.sh  &> /dev/null'
alias clion-root='sudo sh /home/$USER/.config/JetBrains/CLion2021.2/bin/clion.sh  &> /dev/null'
alias linuxcpp='bash /home/$USER/linux_cpp.sh'
alias qt5='/opt/Qt5.12.9/Tools/QtCreator/bin/qtcreator.sh' " &>>${file_shrc}
		source ${file_shrc}
	fi
}
func_shell_copy() {
	func_shell_xxshrc "/home/$USER/.zshrc"
	func_shell_xxshrc "/home/$USER/.bashrc"

	func_cpf ../clion_launch_cpp.sh /home/$USER/
	func_cpf ../linux_cpp.sh /home/$USER/

	func_win_fonts

	func_execute_sudo sh ../boost_1_75_0/bootstrap.sh
	func_execute_sudo sh ../boost_1_75_0/b2 install

	local filetmp=/home/$USER/.config/JetBrains
	func_execute_sudo mkdir -m 777 -p -v ${filetmp} # 创建文件夹
	if [ ! -d "${filetmp}/${Clion_file}" ]; then
		#	func_execute_sudo rm -rf ${filetmp}/${Clion_file}
		func_cpf ../${Clion_file} ${filetmp}/
	fi
	clion
}

######################### function() ##############################
func_shell_change() {
	func_execute cat /etc/shells
	echo "shell : $SHELL"
	$?="0"
	func_execute_sudo chsh -s /usr/bin/zsh
	echo -e "
root:x:0:0:root:/root:\033[5;7;35m/usr/bin/zsh/e[0m
...
$USER:x:1000:1000:$USER,,,:/home/$USER:\033[5;7;35m/usr/bin/zsh/e[0m
... "
	func_gedit /etc/passwd
	echo "now : $SHELL"
}

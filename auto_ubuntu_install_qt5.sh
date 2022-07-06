#! /usr/bin/bash

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

source /opt/ARM_tool_function.sh

################################################################

func_echo "ubuntu 安装 qt5 依赖包和库"

################################################################

f_install_qt_common() {
	func_apt -i python python2 python2-dev python3 python3-dev

	func_echo "eglfs 支持"
	func_apt -i libgbm-dev libdrm-dev

	func_echo "pulseaudio 开发库及服务"
	func_apt -i pulseaudio libpulse-dev

	func_echo "tslib 触摸库"
	func_apt -i libts-dev

	func_echo "键盘支持"
	func_apt -i libxkbcommon-dev libxkbcommon-x11-dev

	func_echo "图片"
	func_apt -i libjpeg-dev # libjpeg-tools
	func_apt -i libpng-dev  # libpng-tools
	func_apt -i libgif-dev

	func_echo "ALSA 音频架构
查看声卡 $ cat /proc/asound/cards"
	# ALSA 是 Advanced Linux Sound Architecture，高级 Linux 声音架构的简称,
	# ALSA是一个全然开放源码的音频驱动程序集，除了像OSS那样提供了一组内核驱动程序模块之外，
	# ALSA还专门为简化应用程序的编写提供了对应的函数库，与OSS提供的基于ioctl的原始编程接口相比。
	# ALSA函数库使用起来要更加方便一些。利用该函数库，开发人员能够方便快捷的开发出自己的应用程序，
	# 细节则留给函数库内部处理。当然 ALSA也提供了类似于OSS的系统接口，
	# 只是ALSA的开发人员建议应用程序开发人员使用音频函数库而不是驱动程序的API。
	# alsa-lib 是ALSA 应用库(必需基础库)，alsa-utils 包含一些ALSA小的测试工具.
	# 如 aplay、arecord 、amixer 播放、录音和调节音量小程序，
	func_apt -i libasound2 libasound2-dev
	func_apt -i alsa-base alsa-utils alsa-oss alsa-tools
	func_apt -i alsaplayer-alsa alsaplayer-common

	func_echo "播放器"
	func_apt -i zlib1g-dev # zlib 库
	func_apt -i mplayer    # 播放器
	# func_apt -i smplayer # SMPlayer 是 MPlayer 前端，支持视频、dvd和VCD
}

f_install_qt5_QtWebengine() {
	# https://wiki.qt.io/QtWebEngine/How_to_Try

	func_echo "QtWebengine for Ubuntu"
	func_apt -i bison build-essential gperf flex python2
	func_apt -i libasound2-dev libcups2-dev libdrm-dev libegl1-mesa-dev
	func_apt -i libnss3-dev libpci-dev libpulse-dev libudev-dev nodejs
	func_apt -i libxtst-dev gyp

	func_echo "libninja"
	func_apt -i re2c ninja-build

	func_echo "QtWebengine for Ubuntu 20.04+"
	func_apt -i libssl-dev libxcursor-dev libxcomposite-dev libxdamage-dev
	func_apt -i libxrandr-dev libdbus-1-dev libfontconfig1-dev libxss-dev
	func_apt -i libsrtp2-dev libdbus-c++-dev
	func_apt -i libcap-dev
	func_apt -i libwebp-dev libjsoncpp-dev libopus-dev libminizip-dev
	func_apt -i libavutil-dev libavformat-dev libavcodec-dev
	func_apt -i libevent-dev libvpx-dev libsnappy-dev
	func_apt -i libre2-dev libprotobuf-dev protobuf-compiler libxcb-xinerama0-dev
}

f_install_qt5_other_packages() {
	func_echo_loop "Other packages"

	func_apt -i xorg                      # 显示环境
	func_apt -i libx11-dev libwayland-dev # 显示环境

	func_apt -i libgcrypt20 libgcrypt20-dev
	func_apt -i libgles-dev perl libproxy-dev

	func_echo "Xcb"
	func_apt -i xcb libxcb1 libxcb1-dev
	func_apt -i libxcb-*-dev
	func_apt -i libxcb-*

	func_echo "X11"
	func_apt -i libx11-dev libx11-xcb-dev
	func_apt -i libfontconfig1-dev libfreetype6-dev
	func_apt -i libxext-dev libxfixes-dev libxi-dev libxrender-dev
	func_apt -i libxcb1-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev
	func_apt -i libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev
	func_apt -i libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev
	func_apt -i libxcb-xinerama0-dev
	func_apt -i libxkbcommon-dev libxkbcommon-x11-dev

	func_echo "OpenGL"
	func_apt -i build-essential mesa-common-dev
	func_apt -i libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libegl1-mesa-dev

	if true; then
		# if false; then
		func_echo " QDoc Documentation Generator Tool"
		func_apt -i libclang-dev libclang1 llvm llvm-dev

		func_echo "llvm
		如果 不用 QDoc 则不需要安装。不建议安装，费时费力费空间 "
		func_apt -i clang-format clang-tidy clang-tools clang clangd libc++-dev
		func_apt -i libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1
		func_apt -i libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev
		func_apt -i llvm-runtime llvm python-clang libegl1-mesa-dev
	fi

	func_echo "Qt WebKit"
	func_apt -i flex bison gperf libicu-dev libxslt1-dev ruby

	func_echo " Qt Multimedia"
	func_apt -i gstreamer1.0-qt5 qml-module-qtgstreamer
	func_apt -i libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
	func_apt -i libasound2-dev

	if true; then
		# if false; then
		func_echo "Bluetooth"
		func_apt -i bluez libbluetooth-dev
	fi

	if true; then
		# if false; then
		func_echo "Databases (PostgreSQL, MariaDB/MySQL)"
		func_apt -i libpq-dev libmariadbclient-dev
	fi

	func_echo "Printing support using CUPS"
	func_apt -i libcups2-dev

	func_echo "Wayland"
	func_apt -i libwayland-dev

	func_echo "Accessibility"
	func_apt -i libatspi2.0-dev

	func_echo "SCTP"
	func_apt -i libsctp-dev

	func_echo "harfbuzz"
	func_apt -i libharfbuzz-dev

	func_echo "sqlite"
	func_apt -i sqlite libsqlite3-dev

	func_echo "dbus-runtime"
	func_apt -i libdbus-1-dev

	func_echo "jasper"
	func_apt -i jasper

	func_echo "libinput libudev"
	func_apt -i libinput-dev libudev-dev

	func_echo "assimp"
	func_apt -i libassimp-dev assimp-utils # assimp-testmodels
}

################################################################

sa_qtcom() {
	func_apt -i qt5-default build-essential
	func_apt -i qt5-qmake qt5-qmake-bin
}

sa_qml() {
	local val_qt5_dev=
	val_qt5_dev="
		qml                                      qml-module-qt-labs-location
		qml-module-gsettings1.0                  qml-module-qt-labs-platform
		qml-module-io-thp-pyotherside            qml-module-qt-labs-qmlmodels
		qml-module-ofono                         qml-module-qt-labs-settings
		qml-module-org-kde-activities            qml-module-qt-labs-sharedimage
		qml-module-org-kde-analitza              qml-module-qt-labs-wavefrontmesh
		qml-module-org-kde-bluezqt               qml-module-qtlocation
		qml-module-org-kde-charts                qml-module-qtmultimedia
		qml-module-org-kde-draganddrop           qml-module-qtnfc
		qml-module-org-kde-games-core            qml-module-qtpositioning
		qml-module-org-kde-kaccounts             qml-module-qtqml-models2
		qml-module-org-kde-kcm                   qml-module-qtqml-statemachine
		qml-module-org-kde-kconfig               qml-module-qtquick2
		qml-module-org-kde-kcoreaddons           qml-module-qtquick-controls
		qml-module-org-kde-kholidays             qml-module-qtquick-controls2
		qml-module-org-kde-kio                   qml-module-qtquick-dialogs
		qml-module-org-kde-kirigami2             qml-module-qtquick-extras
		qml-module-org-kde-kitemmodels           qml-module-qtquick-layouts
		qml-module-org-kde-kquickcontrols        qml-module-qtquick-localstorage
		qml-module-org-kde-kquickcontrolsaddons  qml-module-qtquick-particles2
		qml-module-org-kde-kwindowsystem         qml-module-qtquick-privatewidgets
		qml-module-org-kde-newstuff              qml-module-qtquick-scene2d
		qml-module-org-kde-okular                qml-module-qtquick-scene3d
		qml-module-org-kde-people                qml-module-qtquick-shapes
		qml-module-org-kde-prison                qml-module-qtquick-templates2
		qml-module-org-kde-purpose               qml-module-qtquick-virtualkeyboard
		qml-module-org-kde-qqc2desktopstyle      qml-module-qtquick-window2
		qml-module-org-kde-quickcharts           qml-module-qtquick-xmllistmodel
		qml-module-org-kde-runnermodel           qml-module-qtremoteobjects
		qml-module-org-kde-solid                 qml-module-qtscxml
		qml-module-org-kde-telepathy             qml-module-qtsensors
		qml-module-org-nemomobile-mpris          qml-module-qttest
		qml-module-qmltermwidget                 qml-module-qtwayland-compositor
		qml-module-qt3d                          qml-module-qtwebchannel
		qml-module-qtaudioengine                 qml-module-qtwebengine
		qml-module-qtav                          qml-module-qtwebkit
		qml-module-qtbluetooth                   qml-module-qt-websockets
		qml-module-qtcharts                      qml-module-qtwebsockets
		qml-module-qtdatavisualization           qml-module-qtwebview
		qml-module-qtgraphicaleffects            qml-module-snapd
		qml-module-qtgstreamer                   qml-module-ubuntu-onlineaccounts
		qml-module-qt-labs-calendar              qmlscene
		qml-module-qt-labs-folderlistmodel      "

	# for ((i = 0; i < ${#val_qt5_dev[@]}; i++)); do
	# 	func_apt -i "${val_qt5_dev[$i]}"
	# done
	for ftmp in ${val_qt5_dev}; do
		func_apt -i "${ftmp}"
	done
}

sa_libqt() {
	local val_qt5_dev=
	val_qt5_dev="
		libqt53danimation5               libqt5scxml5
		libqt53dcore5                    libqt5scxml5-bin
		libqt53dextras5                  libqt5scxml5-dev
		libqt53dinput5                   libqt5sensors5
		libqt53dlogic5                   libqt5sensors5-dev
		libqt53dquick5                   libqt5serialbus5
		libqt53dquickanimation5          libqt5serialbus5-bin
		libqt53dquickextras5             libqt5serialbus5-dev
		libqt53dquickinput5              libqt5serialbus5-plugins
		libqt53dquickrender5             libqt5serialport5
		libqt53dquickscene2d5            libqt5serialport5-dev
		libqt53drender5                  libqt5sql5
		libqt5bluetooth5                 libqt5sql5-ibase
		libqt5bluetooth5-bin             libqt5sql5-mysql
		libqt5charts5                    libqt5sql5-odbc
		libqt5charts5-dev                libqt5sql5-psql
		libqt5concurrent5                libqt5sql5-sqlite
		libqt5core5a                     libqt5sql5-tds
		libqt5datavisualization5         libqt5svg5
		libqt5datavisualization5-dev     libqt5svg5-dev
		libqt5dbus5                      libqt5test5
		libqt5designer5                  libqt5texttospeech5
		libqt5designercomponents5        libqt5texttospeech5-dev
		libqt5gamepad5                   libqt5-ukui-style1
		libqt5gamepad5-dev               libqt5-ukui-style-dev
		libqt5glib-2.0-0                 libqt5virtualkeyboard5
		libqt5gstreamer-1.0-0            libqt5virtualkeyboard5-dev
		libqt5gstreamer-dev              libqt5waylandclient5
		libqt5gstreamerquick-1.0-0       libqt5waylandclient5-dev
		libqt5gstreamerui-1.0-0          libqt5waylandcompositor5
		libqt5gstreamerutils-1.0-0       libqt5waylandcompositor5-dev
		libqt5gui5                       libqt5webchannel5
		libqt5webchannel5-dev
		libqt5help5                      libqt5webengine5
		libqt5hunspellinputmethod5       libqt5webenginecore5
		libqt5keychain1                  libqt5webengine-data
		libqt5location5                  libqt5webenginewidgets5
		libqt5location5-plugin-mapboxgl  libqt5webkit5
		libqt5location5-plugins          libqt5webkit5-dev
		libqt5multimedia5                libqt5websockets5
		libqt5multimedia5-plugins        libqt5websockets5-dev
		libqt5multimediagsttools5        libqt5webview5
		libqt5multimediaquick5           libqt5webview5-dev
		libqt5multimediawidgets5         libqt5widgets5
		libqt5network5                   libqt5x11extras5
		libqt5networkauth5               libqt5x11extras5-dev
		libqt5networkauth5-dev           libqt5xdg3
		libqt5nfc5                       libqt5xdg-dev
		libqt5opengl5                    libqt5xdgiconloader3
		libqt5opengl5-dev                libqt5xdgiconloader-dev
		libqt5pas1                       libqt5xml5
		libqt5pas-dev                    libqt5xmlpatterns5
		libqt5positioning5               libqt5xmlpatterns5-dev
		libqt5positioning5-plugins       libqtav1
		libqt5positioningquick5          libqtav-dev
		libqt5printsupport5              libqtav-private-dev
		libqt5qevercloud3                libqtavwidgets1
		libqt5qml5                       libqtcurve-utils2
		libqt5quick5                     libqtdbusmock1
		libqtdbusmock1-common
		libqt5quickcontrols2-5           libqtdbusmock1-dev
		libqt5quickparticles5            libqtdbustest1
		libqtdbustest1-dev
		libqt5quickshapes5               libqtermwidget5-0
		libqt5quicktemplates2-5          libqtermwidget5-0-dev
		libqt5quicktest5                 libqtest-ocaml
		libqt5quickwidgets5              libqtest-ocaml-dev
		libqt5remoteobjects5             libqtest-ocaml-doc
		libqt5remoteobjects5-bin         libqtpropertybrowser4
		libqt5remoteobjects5-dev         libqtpropertybrowser-dev
		libqt5scintilla2-designer        libqtspell-qt5-0
		libqt5script5                    libqtspell-qt5-dev
		libqt5scripttools5               libqtspell-qt5-html "

	# for ((i = 0; i < ${#val_qt5_dev[@]}; i++)); do
	# 	func_apt -i "${val_qt5_dev[$i]}"
	# done
	for ftmp in ${val_qt5_dev}; do
		func_apt -i "${ftmp}"
	done

}

sa_qtdev() {
	local val_qt5_dev=
	val_qt5_dev="
		qt3d5-dev                           qtikz
		qt3d5-dev-tools                     qtlocation5-dev
		qt3d5-doc                           qtlocation5-doc
		qt3d5-doc-html                      qtlocation5-doc-dev
		qt3d5-examples                      qtlocation5-doc-html
		qt3d-assimpsceneimport-plugin       qtlocation5-examples
		qt3d-defaultgeometryloader-plugin   qtltools
		qt3d-gltfsceneio-plugin             qtltools-example
		qt3d-scene2d-plugin                 qtmultimedia5-dev
		qt5-assistant                       qtmultimedia5-doc
		qt5ct                               qtmultimedia5-doc-html
		qt5-default                         qtmultimedia5-examples
		qt5-doc                             qtnetworkauth5-doc
		qt5-doc-html                        qtnetworkauth5-doc-html
		qt5dxcb-plugin                      qtnetworkauth5-examples
		qt5-flatpak-platformtheme           qtop
		qt5-gtk2-platformtheme              qtox
		qt5-gtk-platformtheme               qtpass
		qt5-image-formats-plugins           qtpositioning5-dev
		qt5keychain-dev                     qtqr
		qt5qevercloud-dev                   qtquickcontrols2-5-dev
		qt5-qmake                           qtquickcontrols2-5-doc
		qt5-qmake-bin                       qtquickcontrols2-5-doc-html
		qt5-qmltooling-plugins              qtquickcontrols2-5-examples
		qt5-quick-demos                     qtquickcontrols5-doc
		qt5serialport-examples              qtquickcontrols5-doc-html
		qt5-style-kvantum                   qtquickcontrols5-examples
		qt5-style-kvantum-l10n              qtractor
		qt5-style-kvantum-themes            qtremoteobjects5-doc
		qt5-style-platform-gtk2             qtremoteobjects5-doc-html
		qt5-style-plugin-cleanlooks         qtremoteobjects5-examples
		qt5-style-plugin-gtk2               qtscript5-dev
		qt5-style-plugin-motif              qtscript5-doc
		qt5-style-plugin-plastique          qtscript5-doc-html
		qt5-style-plugins                   qtscript5-examples
		qt5-styles-ukui                     qtscrob
		qt5-ukui-platformtheme              qtscxml5-doc
		qt5-xdgdesktopportal-platformtheme  qtscxml5-doc-html
		qtads                               qtscxml5-examples
		qtattributionsscanner-qt5           qtsensors5-doc
		qtav-players                        qtsensors5-doc-html
		qtbase5-dev                         qtsensors5-examples
		qtbase5-dev-tools                   qtserialbus5-doc
		qtbase5-doc                         qtserialbus5-doc-html
		qtbase5-doc-dev                     qtserialbus5-examples
		qtbase5-doc-html                    qtserialport5-doc
		qtbase5-examples                    qtserialport5-doc-html
		qtspeech5-doc
		qtspeech5-doc-html
		qtspeech5-examples
		qtcharts5-doc                       qtspeech5-flite-plugin
		qtcharts5-doc-html                  qtspeech5-speechd-plugin
		qtcharts5-examples                  qtsvg5-doc
		qtchooser                           qtsvg5-doc-html
		qtconnectivity5-dev                 qtsvg5-examples
		qtconnectivity5-doc                 qttools5-dev
		qtconnectivity5-doc-html            qttools5-dev-tools
		qtconnectivity5-examples            qttools5-doc
		qtcreator                           qttools5-doc-html
		qtcreator-data                      qttools5-examples
		qtcreator-doc                       qttools5-private-dev
		qtcurve                             qttranslations5-l10n
		qtcurve-l10n                        qtvirtualkeyboard5-doc
		qtdatavisualization5-doc            qtvirtualkeyboard5-doc-html
		qtdatavisualization5-doc-html       qtvirtualkeyboard5-examples
		qtdatavisualization5-examples       qtvirtualkeyboard-plugin
		qtdbustest-runner                   qtwayland5
		qtdeclarative4-kqtquickcharts-1     qtwayland5-dev-tools
		qtdeclarative5-accounts-plugin      qtwayland5-doc
		qtdeclarative5-dee-plugin           qtwayland5-doc-html
		qtdeclarative5-dev                  qtwayland5-examples
		qtdeclarative5-dev-tools            qtwebchannel5-doc
		qtdeclarative5-doc                  qtwebchannel5-doc-html
		qtdeclarative5-doc-dev              qtwebchannel5-examples
		qtdeclarative5-doc-html             qtwebengine5-dev
		qtdeclarative5-examples             qtwebengine5-dev-tools
		qtdeclarative5-kf5declarative       qtwebengine5-doc
		qtdeclarative5-kf5solid             qtwebengine5-doc-html
		qtdeclarative5-poppler1.0           qtwebengine5-examples
		qtdeclarative5-private-dev          qtwebengine5-private-dev
		qtdeclarative5-qtpowerd0.1          qtwebsockets5-doc
		qtel                                qtwebsockets5-doc-html
		qtel-icons                          qtwebsockets5-examples
		qterm                               qtwebview5-doc
		qterminal                           qtwebview5-doc-html
		qterminal-l10n                      qtwebview5-examples
		qtermwidget5-data                   qtx11extras5-doc
		qtgain                              qtx11extras5-doc-html
		qtgamepad5-examples                 qtxdg-dev-tools
		qtgraphicaleffects5-doc             qtxmlpatterns5-dev-tools
		qtgraphicaleffects5-doc-html        qtxmlpatterns5-doc
		qtgstreamer-doc                     qtxmlpatterns5-doc-html
		qtgstreamer-plugins-qt5             qtxmlpatterns5-examples
		qthid-fcd-controller         "

	# for ((i = 0; i < ${#val_qt5_dev[@]}; i++)); do
	# 	func_apt -i "${val_qt5_dev[$i]}"
	# done
	for ftmp in ${val_qt5_dev}; do
		func_apt -i "${ftmp}"
	done
}

################################################################

f_install_qt5_ubuntu() {
	f_install_qt_common
	f_install_qt5_QtWebengine
	f_install_qt5_other_packages

	sa_qtcom
	sa_qml
	sa_qtdev
	sa_libqt
}

func_apt -d -f -a

f_install_qt5_ubuntu

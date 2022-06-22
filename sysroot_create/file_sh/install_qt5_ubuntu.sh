#! /usr/bin/bash

# ./1_prepare.sh ${DIR_base_rootfs}

#func_echo $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
#func_echo $(basename $Rootpath) # 取出文件: zcq_Create_rootfs

if [ -z "$1" ]; then
	source /opt/ARM_tool_function.sh
fi

################################################################

sa_qtcom() {
	func_apt -i qt5-default build-essential
	func_apt -i qt5-qmake qt5-qmake-bin
}

sa_libqt() {
	# bluetooth nfc
	func_echo "bluetooth"
	func_apt -i libqt5bluetooth5

	func_echo "Web"
	func_apt -i libqt5webengine5 libqt5webenginecore5
	func_apt -i libqt5webenginewidgets5 libqt5webengine-data
	func_apt -i qtwebengine5-dev qtwebengine5-*

	func_apt -i libqt5webkit5 libqt5webkit5-dev
	func_apt -i libqt5webchannel5 libqt5webchannel5-dev
	func_apt -i libqt5websockets5 libqt5websockets5-dev
	func_apt -i libqt5webview5 libqt5webview5-dev

	func_echo "3D"
	func_apt -i libqt53danimation5 libqt53dcore5 libqt53dextras5
	func_apt -i libqt53dinput5 libqt53dlogic5 libqt53dquick5
	func_apt -i libqt53dquickanimation5 libqt53dquickextras5 libqt53dquickinput5
	func_apt -i libqt53dquickrender5 libqt53dquickscene2d5 libqt53drender5

	func_apt -i libqt5charts5 libqt5charts5-dev libqt5concurrent5
	func_apt -i libqt5core5a libqt5datavisualization5 libqt5datavisualization5-dev
	func_apt -i libqt5dbus5 libqt5designer5 libqt5designercomponents5
	func_apt -i libqt5gamepad5 libqt5gamepad5-dev libqt5glib-2.0-0

	func_echo "3D"
	func_apt -i libqt5gstreamer-dev libqt5gstreamer-1.0-0 libqt5gstreamerquick-1.0-0
	func_apt -i libqt5gstreamerui-1.0-0 libqt5gstreamerutils-1.0-0

	func_apt -i libqt5gui5 libqt5gui5-gles libqt5help5 libqt5hunspellinputmethod5
	func_apt -i libqt5keychain1 libqt5location5 libqt5location5-plugin-mapboxgl
	func_apt -i libqt5location5-plugins libqt5multimedia5 libqt5multimedia5-plugins
	func_apt -i libqt5multimediagsttools5 libqt5multimediaquick5 libqt5multimediawidgets5
	func_apt -i libqt5network5 libqt5networkauth5 libqt5networkauth5-dev
	func_apt -i libqt5nfc5 libqt5opengl5 libqt5opengl5-dev
	func_apt -i libqt5pas1 libqt5pas-dev libqt5positioning5

	func_apt -i libqt5positioning5-plugins libqt5positioningquick5 libqt5printsupport5
	func_apt -i libqt5qevercloud3 libqt5qml5 libqt5quick5
	func_apt -i libqt5quick5-gles libqt5quickcontrols2-5 libqt5quickparticles5
	func_apt -i libqt5quickparticles5-gles libqt5quickshapes5 libqt5quicktemplates2-5
	func_apt -i libqt5quicktest5 libqt5quickwidgets5 libqt5remoteobjects5
	func_apt -i libqt5remoteobjects5-bin libqt5remoteobjects5-dev libqt5scintilla2-designer
	func_apt -i libqt5script5 libqt5scripttools5 libqt5scxml5

	func_apt -i libqt5scxml5-bin libqt5scxml5-dev libqt5sensors5
	func_apt -i libqt5sensors5-dev libqt5serialbus5 libqt5serialbus5-bin
	func_apt -i libqt5serialbus5-dev libqt5serialbus5-plugins libqt5serialport5
	func_apt -i libqt5serialport5-dev libqt5sql5 libqt5sql5-ibase
	func_apt -i libqt5sql5-mysql libqt5sql5-odbc libqt5sql5-psql
	func_apt -i libqt5sql5-sqlite libqt5sql5-tds libqt5svg5
	func_apt -i libqt5svg5-dev libqt5test5 libqt5texttospeech5
	func_apt -i libqt5texttospeech5-dev libqt5-ukui-style1 libqt5-ukui-style-dev
	func_apt -i libqt5virtualkeyboard5 libqt5virtualkeyboard5-dev libqt5waylandclient5
	func_apt -i libqt5waylandclient5-dev libqt5waylandcompositor5 libqt5waylandcompositor5-dev
	func_apt -i libqt5widgets5 libqt5x11extras5 libqt5x11extras5-dev
	func_apt -i libqt5xdg3 libqt5xdg-dev libqt5xdgiconloader3
	func_apt -i libqt5xdgiconloader-dev libqt5xml5 libqt5xmlpatterns5
	func_apt -i libqt5xmlpatterns5-dev libqtav1 libqtav-dev
	func_apt -i libqtav-private-dev libqtavwidgets1 libqtcurve-utils2
	func_apt -i libqtdbusmock1 libqtdbusmock1-common libqtdbusmock1-dev
	func_apt -i libqtdbustest1 libqtdbustest1-dev libqtermwidget5-0
	func_apt -i libqtermwidget5-0-dev libqtest-ocaml libqtest-ocaml-dev
	func_apt -i libqtpropertybrowser4 libqtpropertybrowser-dev
	func_apt -i libqtspell-qt5-0 libqtspell-qt5-dev libqtspell-qt5-html
}

sa_qtdev() {
	local val_qt5_dev=
	val_qt5_dev="
		qt3d5-dev
		qt3d5-dev-tools
		qt3d-assimpsceneimport-plugin
		qt3d-defaultgeometryloader-plugin
		qt3d-gltfsceneio-plugin
		qt3d-scene2d-plugin
		qt5-assistant
		qt5ct
		qt5-default
		qt5dxcb-plugin
		qt5-flatpak-platformtheme
		qt5-gtk2-platformtheme
		qt5-gtk-platformtheme
		qt5-image-formats-plugins
		qt5keychain-dev
		qt5qevercloud-dev
		qt5-qmake
		qt5-qmake-bin
		qt5-qmltooling-plugins
		qt5-quick-demos
		qt5-style-kvantum
		qt5-style-kvantum-l10n
		qt5-style-kvantum-themes
		qt5-style-platform-gtk2
		qt5-style-plugin-cleanlooks
		qt5-style-plugin-gtk2
		qt5-style-plugin-motif
		qt5-style-plugin-plastique
		qt5-style-plugins
		qt5-styles-ukui
		qt5-ukui-platformtheme
		qt5-xdgdesktopportal-platformtheme
		qtads
		qtattributionsscanner-qt5
		qtav-players
		qtbase5-dev
		qtbase5-dev-tools
		qtbase5-gles-dev
		qtbase5-private-dev
		qtbase5-private-gles-dev
		qtchooser
		qtconnectivity5-dev
		qtcurve
		qtcurve-l10n
		qtdbustest-runner
		qtdeclarative4-kqtquickcharts-1
		qtdeclarative5-accounts-plugin
		qtdeclarative5-dee-plugin
		qtdeclarative5-dev
		qtdeclarative5-dev-tools
		qtdeclarative5-kf5declarative
		qtdeclarative5-kf5solid
		qtdeclarative5-poppler1.0
		qtdeclarative5-private-dev
		qtdeclarative5-qtpowerd0.1
		qtel
		qtel-icons
		qterm
		qterminal
		qterminal-l10n
		qtermwidget5-data
		qtgain
		qtgstreamer-plugins-qt5
		qthid-fcd-controller
		qtikz
		qtlocation5-dev
		qtltools
		qtmultimedia5-dev
		qtop
		qtox
		qtpass
		qtpositioning5-dev
		qtqr
		qtquickcontrols2-5-dev
		qtractor
		qtscript5-dev
		qtscrob
		qtspeech5-flite-plugin
		qtspeech5-speechd-plugin
		qttools5-dev
		qttools5-dev-tools
		qttools5-private-dev
		qttranslations5-l10n
		qtvirtualkeyboard-plugin
		qtwayland5
		qtwayland5-dev-tools
		qtwebengine5-dev
		qtwebengine5-dev-tools
		qtwebengine5-private-dev
		qtxdg-dev-tools
		qtxmlpatterns5-dev-tools "

	for ((i = 0; i < ${#val_qt5_dev[@]}; i++)); do
		func_apt -i ${val_qt5_dev[$i]}
	done
}

sa_qml() {
	local val_qt5_dev=
	val_qt5_dev="
	qml
	qmlscene
	qml-module-gsettings1.0
	qml-module-io-thp-pyotherside
	qml-module-ofono
	qml-module-org-kde-activities
	qml-module-org-kde-analitza
	qml-module-org-kde-bluezqt
	qml-module-org-kde-charts
	qml-module-org-kde-draganddrop
	qml-module-org-kde-games-core
	qml-module-org-kde-kaccounts
	qml-module-org-kde-kcm
	qml-module-org-kde-kconfig
	qml-module-org-kde-kcoreaddons
	qml-module-org-kde-kholidays
	qml-module-org-kde-kio
	qml-module-org-kde-kirigami2
	qml-module-org-kde-kitemmodels
	qml-module-org-kde-kquickcontrols
	qml-module-org-kde-kquickcontrolsaddons
	qml-module-org-kde-kwindowsystem
	qml-module-org-kde-newstuff
	qml-module-org-kde-okular
	qml-module-org-kde-people
	qml-module-org-kde-prison
	qml-module-org-kde-purpose
	qml-module-org-kde-qqc2desktopstyle
	qml-module-org-kde-quickcharts
	qml-module-org-kde-runnermodel
	qml-module-org-kde-solid
	qml-module-org-kde-telepathy
	qml-module-org-nemomobile-mpris
	qml-module-qmltermwidget
	qml-module-qt3d
	qml-module-qtaudioengine
	qml-module-qtav
	qml-module-qtbluetooth
	qml-module-qtcharts
	qml-module-qtdatavisualization
	qml-module-qtgraphicaleffects
	qml-module-qtgstreamer
	qml-module-qt-labs-calendar
	qml-module-qt-labs-folderlistmodel
	qml-module-qt-labs-location
	qml-module-qt-labs-platform
	qml-module-qt-labs-qmlmodels
	qml-module-qt-labs-settings
	qml-module-qt-labs-sharedimage
	qml-module-qt-labs-wavefrontmesh
	qml-module-qtlocation
	qml-module-qtmultimedia
	qml-module-qtnfc
	qml-module-qtpositioning
	qml-module-qtqml-models2
	qml-module-qtqml-statemachine
	qml-module-qtquick2
	qml-module-qtquick-controls
	qml-module-qtquick-controls2
	qml-module-qtquick-dialogs
	qml-module-qtquick-extras
	qml-module-qtquick-layouts
	qml-module-qtquick-localstorage
	qml-module-qtquick-particles2
	qml-module-qtquick-privatewidgets
	qml-module-qtquick-scene2d
	qml-module-qtquick-scene3d
	qml-module-qtquick-shapes
	qml-module-qtquick-templates2
	qml-module-qtquick-virtualkeyboard
	qml-module-qtquick-window2
	qml-module-qtquick-xmllistmodel
	qml-module-qtremoteobjects
	qml-module-qtscxml
	qml-module-qtsensors
	qml-module-qttest
	qml-module-qtwayland-compositor
	qml-module-qtwebchannel
	qml-module-qtwebengine
	qml-module-qtwebkit
	qml-module-qt-websockets
	qml-module-qtwebsockets
	qml-module-qtwebview
	qml-module-snapd
	qml-module-ubuntu-onlineaccounts "

	for ((i = 0; i < ${#val_qt5_dev[@]}; i++)); do
		func_apt -i ${val_qt5_dev[$i]}
	done
}

f_install_qt5_ubuntu() {
	func_echo_loop "qt 库"
#	sa_qtcom
#	sa_libqt
#	sa_qtdev
	sa_qml
}

################################################################

main_qt5_ubuntu() {
	f_install_qt5_ubuntu
	func_apt -a -f
}

if [ -z "$1" ]; then
	main_qt5_ubuntu
fi

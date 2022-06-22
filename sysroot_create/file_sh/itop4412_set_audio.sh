#!/usr/bin/bash

Output_log="" # 设置执行命令时的信息输出文件；不设置，默认。

################################################################################
echo_to_file() {
	echo -e "$*" &>>"${Output_log}"
}
print_to_stdout() {
	echo -e "\033[36m $* \e[0m"
}
print_cmd_std() {
	print_to_stdout "$*"
	echo_to_file "$*"
}
cmd_to_stdout() {
	echo -e "\033[1;3;5;32m \$ \e[0m\033[1;32;40m $* \e[0m"
	echo_to_file "______________________________________________"
	echo_to_file " \$ $* \n"
}

# execute 执行语句 成功与否打印
execute() {
	cmd_to_stdout "$*"
	$@ &>>"${Output_log}"
}
execute_sudo() {
	execute "${Sudo} $*"
}
execute_err() {
	execute "$@"
	local ret=$?
	if [ $ret -ne 0 ]; then
		echo -e "ret=$ret 执行 $*"
		exit $ret
	fi
}
execute_err_sudo() {
	execute_err "${Sudo} $*"
}
# execute pwd ; ifconfig
# execute mkdir -m 777 -p -v file # 创建文件夹

cd_path() {
	cmd_to_stdout "cd $1 || exit"
	cd $1 || exit
}

################################################################################
Sudo="sudo"
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

Rootpath=$(pwd)
# ${Sudo} chmod -R 777 ${Rootpath}

# $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
# $(basename $Rootpath) # 取出文件: zcq_Create_rootfs
Filename=$(basename $0) # set_audio_output_input.sh

if [ -z "${Output_log}" ]; then
	Output_log=${Rootpath}/log.${Filename%.*} # set_audio_output_input
fi
execute_err_sudo rm -rf ${Output_log}
execute_err_sudo touch ${Output_log}
execute_err_sudo chmod -R 777 ${Output_log}

print_to_stdout "设置执行命令时的信息输出文件: ${Output_log}"
echo_to_file "<< 执行(${Filename})时的信息输出 >>"

################################################################################
Output_asound=${Rootpath}/asound.state_${Filename%.*} # set_audio_output_input
rm -rf ${Output_asound}

################################################################################

# amixer + [Available commands]

# amixer scontrols   	显示 所有 混音器控件
# amixer scontents		显示 所有 混音器控件内容
# amixer sset sID P  	set contents for one mixer simple control / scontrols
# amixer sget sID    	get contents for one mixer simple control / scontrols

# amixer controls    	显示 给定卡 的所有控件
# amixer contents    	显示 给定卡 的所有控件的内容
# amixer cset cID P 	set control contents for one control / controls
# amixer cget cID    	get control contents for one control / controls

# amixer --help //查看 amixer 帮助信息
# 4、 设置声卡
# 知道了设置项和设置值，那么设置声卡就很简单了，直接使用下面命令即可：
# amixer sset 设置项目 设置值
# 或：
# amixer cset 设置项目 设置值
# 5、获取声卡设置值
# 如果要读取当前声卡某项设置值的话使用如下命令：
# amixer sget 设置项目
# 或：
# amixer cget 设置项目

################################################################################

# 耳机 录音 与 播放 测试

# 如果在 MIC 录音实验中将 R23 的寄存器改为了 0X01C4，
# 那么在进行 LINE IN 录音测试之前先改回原来的 0X01C0，
# 因为 ALPHA 开发板的 LINE IN 接了双声道，不需要共用左声道数据。
# 当然了，不修改也是可以直接做测试的！
# 由于 ALPHA 开发板上 LINE IN 是接了左右双声道，因此录制出来的音频是立体声的，
# 不像 MIC 录出来的只有左声道。

################################################################################

# MIC 录音 与 播放 测试 ALPHA 开发板上有一个麦克风
# 只有左声道有声音，右声道没有任何声音，因为 ALPHA 开发板的 MIC 只接了左声道，

################################################################################

audio_output() {
	print_cmd_std "
	audio_output():$1
	Turn on/off 耳机/喇叭（扬声器）; 设置 播放音量，直流/交流；查看原理图	"
	case "$1" in
	on)
		volume=127    # 播放音量
		volume_acdc=5 # 播放音量
		;;
	off)
		volume=0      # 播放音量
		volume_acdc=5 # 播放音量
		;;
	*)
		echo "error args: $1"
		exit 1
		;;
	esac

	# Turn on/off 左/右 声道 输出
	cmd_to_stdout "amixer sset 'Left Output Mixer PCM' $1"
	amixer sset 'Left Output Mixer PCM' $1 &>>"${Output_log}"

	cmd_to_stdout "amixer sset 'Right Output Mixer PCM' $1"
	amixer sset 'Right Output Mixer PCM' $1 &>>"${Output_log}"

	# Turn on/off Headphone
	cmd_to_stdout "amixer sset 'Headphone Playback ZC' $1"
	amixer sset 'Headphone Playback ZC' $1 &>>"${Output_log}"

	execute amixer sset Headphone ${volume},${volume} # 125 [98%] [4.00dB] max=127
	# execute amixer cset name='Headphone Playback Volume' ${volume},${volume}

	# Turn on/off the speaker
	cmd_to_stdout "execute amixer sset 'Speaker Playback ZC' $1"
	amixer sset 'Speaker Playback ZC' $1 &>>"${Output_log}"

	execute amixer sset Speaker ${volume},${volume} # 125 [98%] [4.00dB] max=127

	cmd_to_stdout "amixer sset 'Speaker AC' ${volume_acdc}"    # 0 - 5
	amixer sset 'Speaker AC' ${volume_acdc} &>>"${Output_log}" # 0 - 5

	cmd_to_stdout "amixer sset 'Speaker DC' ${volume_acdc}"    # 0 - 5
	amixer sset 'Speaker DC' ${volume_acdc} &>>"${Output_log}" # 0 - 5
}

audio_input() {
	print_cmd_std "
	audio_input()
	Turn on/off 耳机/咪麦 克风头 音频输入; 设置 音量；查看原理图	"

	# 关闭 左/右 声道 音频输入，只打开 RINPUT1 音频输入
	cmd_to_stdout "amixer sset 'Left Input Mixer Boost' off"
	amixer sset 'Left Input Mixer Boost' off &>>"${Output_log}"

	cmd_to_stdout "amixer sset 'Right Input Mixer Boost' off"
	amixer sset 'Right Input Mixer Boost' off &>>"${Output_log}"

	# LINPUT1 耳机(左声道) Line_in ---- AUD_INT ---- MIC_P
	cmd_to_stdout "amixer sset 'Left Boost Mixer LINPUT1' on"
	amixer sset 'Left Boost Mixer LINPUT1' on &>>"${Output_log}" # 只打开 该声道 音频输入

	cmd_to_stdout "amixer sset 'Left Input Boost Mixer LINPUT1' 3"    # 0 - 3
	amixer sset 'Left Input Boost Mixer LINPUT1' 3 &>>"${Output_log}" # 0 - 3

	# LINPUT2 查看原理图，硬件 接地
	cmd_to_stdout "amixer sset 'Left Boost Mixer LINPUT2' off"
	amixer sset 'Left Boost Mixer LINPUT2' off &>>"${Output_log}"

	cmd_to_stdout "amixer sset 'Left Input Boost Mixer LINPUT2' 0"    # 0 - 7
	amixer sset 'Left Input Boost Mixer LINPUT2' 0 &>>"${Output_log}" # 0 - 7

	# LINPUT3 查看原理图，硬件 接地
	cmd_to_stdout "amixer sset 'Left Boost Mixer LINPUT3' off"
	amixer sset 'Left Boost Mixer LINPUT3' off &>>"${Output_log}"

	cmd_to_stdout "amixer sset 'Left Input Boost Mixer LINPUT3'" 0    # 0 - 7
	amixer sset 'Left Input Boost Mixer LINPUT3' 0 &>>"${Output_log}" # 0 - 7

	# LINPUT1 查看原理图，硬件 接地
	cmd_to_stdout "amixer sset 'Right Boost Mixer RINPUT1' off"
	amixer sset 'Right Boost Mixer RINPUT1' off &>>"${Output_log}"

	cmd_to_stdout "amixer sset 'Right Input Boost Mixer RINPUT1' 0"    # 0 - 3
	amixer sset 'Right Input Boost Mixer RINPUT1' 0 &>>"${Output_log}" # 0 - 3

	# LINPUT2 查看原理图，硬件 接地
	cmd_to_stdout "amixer sset 'Right Boost Mixer RINPUT2' off"
	amixer sset 'Right Boost Mixer RINPUT2' off &>>"${Output_log}"

	cmd_to_stdout "amixer sset 'Right Input Boost Mixer RINPUT2' 7"    # 7 
	amixer sset 'Right Input Boost Mixer RINPUT2' 0 &>>"${Output_log}" # 7 

	# LINPUT3 查看原理图，硬件 接地
	cmd_to_stdout "amixer sset 'Right Boost Mixer RINPUT3' off"
	amixer sset 'Right Boost Mixer RINPUT3' off &>>"${Output_log}" 

	cmd_to_stdout "amixer sset 'Right Input Boost Mixer RINPUT3' 0"    # 7 [100%] [6.00dB]
	amixer sset 'Right Input Boost Mixer RINPUT3' 0 &>>"${Output_log}" # 7 [100%] [6.00dB]
}

################################################################################

cd_path ${Rootpath}
# ${Sudo} chmod -R 777 ${Rootpath}

# 设置捕获的音量
execute amixer sset 'Capture' 63,63 # Capture 63 [100%] [30.00dB]
# amixer cset name='Capture Volume' 63,63 # max=63

# ADC PCM Capture Volume
cmd_to_stdout "amixer sset 'ADC PCM' 255"    # Capture 250 [98%] [27.50dB] max=255
amixer sset 'ADC PCM' 255 &>>"${Output_log}" # Capture 250 [98%] [27.50dB] max=255

# 设置播放的音量
execute amixer sset 'Playback' 255,255 # 255 [100%] [0.00dB]
# amixer cset name='Playback Volume' 255,255 # max=255

# PCM Playback -6dB Switch
cmd_to_stdout "amixer sset 'PCM Playback -6dB' on"
amixer sset 'PCM Playback -6dB' on &>>"${Output_log}"

################################################################################

audio_output on # Turn on 耳机/扬声器

audio_input # Turn on of 音频输入

################################################################################

execute_err_sudo alsactl -f ${Output_asound} store # 保存根文件系统的声卡设置
# ${Sudo} chmod -R 777 ${Rootpath}

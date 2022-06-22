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
	cd $1 || exit
	cmd_to_stdout "cd $1 || exit"
}
################################################################################
Sudo="sudo"
if [ "$(whoami)" = "root" ]; then
	Sudo=""
fi

Rootpath=$(pwd)

# $(dirname $Rootpath)  # 取出目录: /home/.../rootfs.../
# $(basename $Rootpath) # 取出文件: zcq_Create_rootfs
Filename=$(basename $0) # set_audio_output_input.sh

if [ -z "${Output_log}" ]; then
	Output_log=${Rootpath}/log.${Filename%.*} # set_audio_output_input
fi
${Sudo} rm -rf ${Output_log}
${Sudo} touch ${Output_log}
${Sudo} chmod -R 777 ${Output_log}

print_to_stdout "设置执行命令时的信息输出文件: ${Output_log}"
echo_to_file "<< 执行(${Filename})时的信息输出 >>"

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
	print_to_stdout "
	--------------------------------------------------------
	audio_output():$1
	Turn on/off 耳机/喇叭（扬声器）; 设置 播放音量，直流/交流；查看原理图	"
	case "$1" in
	on)
		volume=127    # 播放音量
		volume_acdc=5 # 播放音量
		;;
	off)
		volume=0      # 播放音量
		volume_acdc=0 # 播放音量
		;;
	*)
		echo "error args: $1"
		exit 1
		;;
	esac

	# Turn on/off 左/右 声道 输出
	${Sudo} amixer sset 'Left Output Mixer PCM' $1
	${Sudo} amixer sset 'Right Output Mixer PCM' $1

	# Turn on/off Headphone
	${Sudo} amixer sset 'Headphone Playback ZC' $1
	${Sudo} amixer sset Headphone ${volume},${volume} # 125 [98%] [4.00dB] max=127
	# execute amixer cset name='Headphone Playback Volume' ${volume},${volume}

	# Turn on/off the speaker
	${Sudo} amixer sset 'Speaker Playback ZC' $1
	${Sudo} amixer sset Speaker ${volume},${volume} # 125 [98%] [4.00dB] max=127
	${Sudo} amixer sset 'Speaker AC' ${volume_acdc} # 0 - 5
	${Sudo} amixer sset 'Speaker DC' ${volume_acdc} # 0 - 5
}

audio_input() {
	print_to_stdout "
	--------------------------------------------------------
	audio_input()
	Turn on/off 耳机/咪麦 克风头 音频输入; 设置 音量；查看原理图	"

	# 关闭 左/右 声道 音频输入，只打开 RINPUT2 音频输入
	${Sudo} amixer sset 'Left Input Mixer Boost' off
	${Sudo} amixer sset 'Right Input Mixer Boost' off

	# 咪头 MAIN_MIC2N 查看原理图，硬件 接地
	${Sudo} amixer sset 'Left Boost Mixer LINPUT1' off &>>"${Output_log}" 
	${Sudo} amixer sset 'Left Input Boost Mixer LINPUT1' 0 &>>"${Output_log}" # 0 - 3
	# 咪头 MAIN_MIC2P
	${Sudo} amixer sset 'Left Boost Mixer LINPUT2' off &>>"${Output_log}"
	${Sudo} amixer sset 'Left Input Boost Mixer LINPUT2' 0 &>>"${Output_log}" # 0 - 7
	# 耳机 LINE_INR 查看原理图，未连接硬件
	${Sudo} amixer sset 'Left Boost Mixer LINPUT3' off &>>"${Output_log}"
	${Sudo} amixer sset 'Left Input Boost Mixer LINPUT3' 0 &>>"${Output_log}" # 0 - 7

	# 查看原理图，硬件 接地
	${Sudo} amixer sset 'Right Boost Mixer RINPUT1' off &>>"${Output_log}"
	${Sudo} amixer sset 'Right Input Boost Mixer RINPUT1' 0 &>>"${Output_log}" # 0 - 3
	# 咪头 LINE_INL 
	${Sudo} amixer sset 'Right Boost Mixer RINPUT2' on &>>"${Output_log}" # 只打开 该声道 音频输入
	${Sudo} amixer sset 'Right Input Boost Mixer RINPUT2' 7 &>>"${Output_log}" # 0 - 7 
	# 耳机 AUD_INT 
	${Sudo} amixer sset 'Right Boost Mixer RINPUT3' off &>>"${Output_log}"
	${Sudo} amixer sset 'Right Input Boost Mixer RINPUT3' 0 &>>"${Output_log}" # 7 [100%] [6.00dB]
}

################################################################################

cd_path ${Rootpath}
# ${Sudo} chmod -R 777 ${Rootpath}

# 设置捕获的音量
execute amixer sset 'Capture' 63,63 # Capture 63 [100%] [30.00dB]
# amixer cset name='Capture Volume' 63,63 # max=63

# ADC PCM Capture Volume
${Sudo} amixer sset 'ADC PCM' 255 &>>"${Output_log}" # Capture 250 [98%] [27.50dB] max=255

# 设置播放的音量
execute amixer sset 'Playback' 255,255 # 255 [100%] [0.00dB]
# amixer cset name='Playback Volume' 255,255 # max=255

# PCM Playback -6dB Switch
${Sudo} amixer sset 'PCM Playback -6dB' on 

################################################################################

audio_output off #录音 前 应该 Turn off 耳机/扬声器 防止干扰 防止干扰

audio_input # 音频输入

################################################################################

record_line=record_mic.wav
echo -e "
# 使用 arecord 来录制一段 10 秒中的音频，arecord 也是 alsa-utils 编译出来的
# \“-f cd\” 设置录音质量为 cd 级别(wav 音频)。
# -d 是指定录音时间，单位是 s；
# 音频名字为 record.wav。
# 录制的时候，对着开发板上的 MIC 说话，直到录制完成。 "
execute_sudo rm -rf ${record_line}
execute_sudo arecord  -f cd  -d 5  ${record_line} # 录制 音频
execute_sudo chmod -R 777 ${record_line}

################################################################################

audio_output on #录音 结束 再打开耳机和扬声器 应该 Turn on 耳机/扬声器

################################################################################

echo -e "
# 录制完成以后使用 aplay 播放刚刚录制的 ${record_line} 音频，
# 只有左声道有声音，右声道没有任何声音，因为 ALPHA 开发板的 MIC 只接了左声道 "
execute aplay ${record_line} # 播放 音频

################################################################################

# 以下是一些用alsa-utils测试样例
# 播放wave文件
#  aplay test.wav
# 变频播放,(以是以 44 KHz来播放音频)
# aplay -D rate_44k /mnt/nfs/test.wav
# 录音,以20秒的间隔(-d 20),立体声(-c 2),频率是 8000Hz来录制Wave格式音频
# arecord -d 20 -c 2 -t wav -r 8000 -f “Signed 16 bit Little Endian” /mnt/nfs/test.wav
# 测试混音播放(先是播放test1.wav,然后再同时播放test2.wav)
# aplay -D plug:dmix_44k /mnt/nfs/test1.wav & 
# aplay -D plug:dmix_44k /mnt/nfs/test2.wav
# 设置放音增益（0 to 3）
# amixer set Master 1
# 设置录音音量(0-31)
#  amixer set Line 10

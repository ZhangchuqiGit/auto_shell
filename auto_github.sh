#!/usr/bin/bash

source /opt/ARM_tool_function.sh

###########################################################

URL_git=xxx

###########################################################

# 设置 git 用户名／邮箱
UserName=xxx
Email="xxx@163.com"

URL=https://github.com/${UserName}/${URL_git}.git

###########################################################

# 生成SSH Key
if false; then
    func_echo "
    输入命令后，敲下回车键，会提让你输入 生成的秘钥对保存的路径，如果使用默认的保存路径，直接敲回车；
    然后，需要让你输入口令保护，为空则没有口令保护，直接敲回车；
    然后是口令保护确认，如果上一步为空，这一步也直接敲回车；
    然后rsa秘钥对就生成了并显示生成路径。
    SSH keys: /home/ubuntu/.ssh/id_rsa.pub    "
    ssh-keygen -t rsa -C "${Email}"
fi
###########################################################

echo "请勿开代理"

Filename=$(basename ${URL})
Filename=${Filename%\.git}
echo "\${Filename}=${Filename}"

if [ ! -d ${Filename} ]; then
    func_execute git clone ${URL}
    echo "可以修改文件，再 [Enter] 同步 github"
    echo "enter: continue : [y/n]"
    read _enter
    if [ "${_enter}" != "y" ]; then
        echo "退出"
        exit 0
    fi
fi

cd ${Filename} || (
    echo "------- cd ${Filename}"
    exit 33
)

# 设置 git 用户名／邮箱
git config --global user.name "${UserName}"
git config --global user.email "${Email}"

func_execute git init
func_execute git add .
git commit -m "update"
func_execute git push

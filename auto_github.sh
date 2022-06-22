#!/usr/bin/bash

URL=https://github.com/xxx/xxx.git

NAME=xxx
Email="xxx@163.com"

echo "请勿开代理"

Filename=$(basename ${URL})
Filename=${Filename%\.git}
echo "\${Filename}=${Filename}"

if [ ! -d ${Filename} ]; then
    git clone ${URL}
	echo "可以修改文件，再 [Enter] 同步 github"
    echo "enter: continue"
    read _enter
fi

cd ${Filename} || (echo "------- cd ${Filename}"; exit 33)

git init 

git add .

git config --global user.email ${Email}
git config --global user.name "${URL}"
git commit -m "update"
git push 

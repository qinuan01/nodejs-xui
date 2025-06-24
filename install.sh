#!/bin/bash

# 设置下载链接
DOWNLOAD_URL="https://github.com/qinuan01/nodejs-xui/releases/download/qinuan-nodejs-xui/nodejs-xui-main.zip"
ZIP_FILE="nodejs-xui-main.zip"
EXTRACT_DIR="nodejs-xui-main"

# 检测操作系统
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

# 根据不同的操作系统安装相应的软件包
if [[ "$OS" == *"Alpine"* ]]; then
    echo "检测到 Alpine Linux，安装必要的工具..."
    apk add --no-cache curl unzip nodejs
elif [[ "$OS" == *"Debian"* || "$OS" == *"Ubuntu"* ]]; then
    echo "检测到 Debian/Ubuntu，安装必要的工具..."
    apt update
    apt install -y curl unzip nodejs
else
    echo "无法识别的操作系统。仅支持 Alpine 或 Debian/Ubuntu 系统。"
    exit 1
fi

# 使用 curl 下载 Release 文件
echo "使用 curl 下载 GitHub Release 文件..."
curl -L $DOWNLOAD_URL -o $ZIP_FILE

# 解压文件
echo "解压文件 $ZIP_FILE..."
unzip -o $ZIP_FILE -d .  # -o 表示覆盖同名文件

# 进入解压目录
cd $EXTRACT_DIR

# 提示用户运行项目
echo "解压完成！你可以使用以下命令启动项目："
echo "node index.js"  # 假设入口脚本是 index.js

#!/bin/bash

# 设置下载链接
DOWNLOAD_URL="https://github.com/qinuan01/nodejs-xui/releases/download/qinuan-nodejs-xui/nodejs-xui-main.zip"
ZIP_FILE="nodejs-xui-main.zip"
EXTRACT_DIR="nodejs-xui-main"

# 安装所需工具（如果没有安装）
echo "检查并安装必要工具："
apk add --no-cache curl unzip nodejs

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


#!/bin/bash

# ========== 颜色定义 ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[1;34m'
RESET='\033[0m'

# ========== 变量 ==========
DOWNLOAD_URL="https://github.com/qinuan01/nodejs-xui/releases/download/qinuan-nodejs-xui/nodejs-xui-main.zip"
ZIP_FILE="nodejs-xui-main.zip"
EXTRACT_DIR="nodejs-xui-main"

NODE_MODULES_URL="https://raw.githubusercontent.com/qinuan01/nodejs-xui/refs/heads/main/node_modules.zip"
NODE_MODULES_ZIP="node_modules.zip"

# ========== 检测操作系统 ==========
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

echo -e "${BLUE}检测操作系统中...${RESET}"
sleep 0.5

# ========== 安装依赖 ==========
if [[ "$OS" == *Alpine* ]]; then
    echo -e "${CYAN}检测到 Alpine Linux，开始安装依赖...${RESET}"
    apk update
    apk add --no-cache curl unzip nodejs git build-base libpcap-dev linux-headers screen
    echo -e "${GREEN}已安装必要工具，准备构建 masscan...${RESET}"
    git clone https://github.com/robertdavidgraham/masscan.git
    cd masscan || exit 1
    make
    cp bin/masscan /usr/local/bin/
    cd .. || exit 1
elif [[ "$OS" == *Debian* || "$OS" == *Ubuntu* ]]; then
    echo -e "${CYAN}检测到 Debian/Ubuntu，开始安装依赖...${RESET}"
    apt update
    apt install -y curl unzip libpcap-dev masscan nodejs screen
else
    echo -e "${RED}无法识别的操作系统！仅支持 Alpine 或 Debian/Ubuntu。${RESET}"
    exit 1
fi

# ========== 下载 Release ==========
echo -e "${CYAN}下载 GitHub Release 文件中...${RESET}"
curl -L "$DOWNLOAD_URL" -o "$ZIP_FILE"

# ========== 解压文件 ==========
echo -e "${CYAN}解压文件 $ZIP_FILE...${RESET}"
unzip -o "$ZIP_FILE" -d .

# ========== 进入目录 ==========
cd "$EXTRACT_DIR" || { echo -e "${RED}进入目录失败！${RESET}"; exit 1; }

# ========== 下载并解压 node_modules.zip ==========
echo -e "${CYAN}下载 node_modules.zip 文件中...${RESET}"
curl -L "$NODE_MODULES_URL" -o "$NODE_MODULES_ZIP"

echo -e "${CYAN}解压 node_modules.zip 到当前目录（$EXTRACT_DIR）...${RESET}"
unzip -o "$NODE_MODULES_ZIP" -d .

echo -e "${CYAN}删除 node_modules.zip 临时文件...${RESET}"
rm -f "$NODE_MODULES_ZIP"

# ========== 返回上级目录，清理 Release zip ==========
cd .. || exit 1
echo -e "${CYAN}清理临时文件：删除 $ZIP_FILE...${RESET}"
rm -f "$ZIP_FILE"

# ========== 完成提示 ==========
echo
echo -e "${GREEN}✅ 安装与解压完成！你可以使用以下命令启动项目：${RESET}"
echo -e "${BLUE}cd $EXTRACT_DIR${RESET}"
echo -e "${YELLOW}node masscan.js${RESET}"
echo

#!/bin/bash

# 定义安装目录和文件名
INSTALL_DIR="/root/multipleforlinux"
TAR_FILE="multipleforlinux.tar"
DOWNLOAD_URL="https://cdn.app.multiple.cc/client/linux/x64/$TAR_FILE"

# 下载压缩包
echo "正在下载文件..."
wget -q $DOWNLOAD_URL -O $TAR_FILE
if [[ $? -ne 0 ]]; then
    echo "下载失败，请检查URL: $DOWNLOAD_URL"
    exit 1
fi

# 解压文件
echo "解压文件..."
tar -xvf $TAR_FILE
if [[ $? -ne 0 ]]; then
    echo "解压失败，请检查文件: $TAR_FILE"
    exit 1
fi

# 修改文件权限
echo "修改文件权限..."
chmod +x ./multiple-cli
chmod +x ./multiple-node

# 移动到安装目录
echo "进入安装目录..."
cd $INSTALL_DIR || { echo "目录不存在：$INSTALL_DIR"; exit 1; }

# 添加路径到环境变量
echo "配置环境变量..."
PROFILE_FILE="/etc/profile"
if ! grep -q "$INSTALL_DIR" $PROFILE_FILE; then
    echo "PATH=\$PATH:$INSTALL_DIR" >> $PROFILE_FILE
    source $PROFILE_FILE
fi

# 返回上级目录，修改权限
cd ..
chmod -R 777 $INSTALL_DIR

# 返回安装目录并启动节点程序
cd $INSTALL_DIR
echo "启动节点程序..."
nohup ./multiple-node > output.log 2>&1 &

# 执行绑定操作
echo "绑定配置中..."
./multiple-cli bind --bandwidth-download 100 --identifier 399MGL34 --pin --storage 10 --bandwidth-upload 10

# 提示完成
echo "安装和配置完成。"

#!/bin/bash

echo "脚本由大赌哥社区flynn编写，免费开源，请勿相信收费"

# 定义安装目录和文件名
INSTALL_DIR="multipleforlinux"
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
chmod +x "$INSTALL_DIR/multiple-cli"
chmod +x "$INSTALL_DIR/multiple-node"

# 添加路径到环境变量
echo "配置环境变量..."
PROFILE_FILE="/etc/profile"
if ! grep -q "$INSTALL_DIR" $PROFILE_FILE; then
    echo "PATH=\$PATH:/root/$INSTALL_DIR" >> $PROFILE_FILE
    source $PROFILE_FILE
fi

# 启动节点程序
echo "启动节点程序..."
nohup "./$INSTALL_DIR/multiple-node" > output.log 2>&1 &

# 用户自定义参数
read -p "请输入下载带宽（单位：Mbps，例如100）： " BANDWIDTH_DOWNLOAD
read -p "请输入上传带宽（单位：Mbps，例如100）： " BANDWIDTH_UPLOAD
read -p "请输入存储空间（单位：GB，例如100）： " STORAGE
read -p "请输入唯一标识符（例如TEQKE8TT）： " IDENTIFIER
read -p "请输入PIN码（可以为空，按回车跳过）： " PIN

# 如果PIN为空，则设置为默认空字符串
if [[ -z $PIN ]]; then
    PIN=""
fi

# 构造绑定命令
BIND_COMMAND="./$INSTALL_DIR/multiple-cli bind --bandwidth-download $BANDWIDTH_DOWNLOAD --bandwidth-upload $BANDWIDTH_UPLOAD --storage $STORAGE --identifier $IDENTIFIER --pin \"$PIN\""

# 执行绑定操作
echo "绑定配置中..."
eval "$BIND_COMMAND"

# 提示完成
echo "安装和配置完成。"

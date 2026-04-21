#!/bin/bash
set -e

# --- 配置区 ---
# 请根据实际情况修改或通过环境变量传入
NODE_TYPE=${1:-"master"} # 默认为 master, 可选 worker
DB_STR=${K3S_DATASTORE_ENDPOINT:-"postgres://user:password@hostname:5432/k3s"}
K3S_TOKEN=${K3S_TOKEN:-"Default-Super-Secret-Token-2026"}

echo "--- 安装 K3s SELinux 策略包 (RHEL 9 必需) ---"
cat <<REPO > /etc/yum.repos.d/rancher-k3s-common.repo
[rancher-k3s-common-stable]
name=Rancher K3s Common (Stable)
baseurl=https://rpm.rancher.io/k3s/stable/common/centos/9/noarch
enabled=1
gpgcheck=1
gpgkey=https://rpm.rancher.io/public.key
REPO

yum install -y k3s-selinux

if [ "$NODE_TYPE" == "master" ]; then
    echo "🚀 正在部署 K3s Master 节点 (使用外部数据库)..."
    curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN sh -s - server \
        --datastore-endpoint="$DB_STR" \
        --node-taint CriticalAddonsOnly=true:NoSchedule \
        --tls-san $(hostname -I | awk '{print $1}')
else
    echo "🚀 正在部署 K3s Worker 节点..."
    # 假设 MASTER_IP 已知，实际操作中建议通过环境变量传入
    curl -sfL https://get.k3s.io | K3S_URL=https://${MASTER_IP}:6443 K3S_TOKEN=$K3S_TOKEN sh -
fi

echo "✅ K3s $NODE_TYPE 安装程序启动完成"

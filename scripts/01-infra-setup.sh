#!/bin/bash
set -e

echo "--- 正在加载 K3s 所需内核模块 ---"
# overlay: 用于容器镜像分层存储
# br_netfilter: 用于网桥流量通过 iptables/nftables 过滤
cat <<K3S_MODULES > /etc/modules-load.d/k3s.conf
overlay
br_netfilter
K3S_MODULES

modprobe overlay
modprobe br_netfilter

echo "--- 配置网络内核参数 (Sysctl) ---"
cat <<K3S_SYSCTL > /etc/sysctl.d/k3s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
K3S_SYSCTL

sysctl --system

echo "--- 配置防火墙规则 (保持 Firewalld 开启) ---"
# 1. 开启伪装 (Masquerade) 允许容器访问外部网络
firewall-cmd --permanent --add-masquerade

# 2. K3s API Server (6443)
firewall-cmd --permanent --add-port=6443/tcp

# 3. Kubelet 指标 (10250)
firewall-cmd --permanent --add-port=10250/tcp

# 4. Flannel VXLAN (8472/UDP) - 节点间 Pod 通信必选
firewall-cmd --permanent --add-port=8472/udp

# 5. 允许集群内网段流量 (假设默认 Pod 网段 10.42.0.0/16 和 Service 网段 10.43.0.0/16)
# 在 RHEL 9 中，通过 trusted zone 或直接放行网段实现
firewall-cmd --permanent --zone=public --add-source=10.42.0.0/16
firewall-cmd --permanent --zone=public --add-source=10.43.0.0/16

echo "--- 重新加载防火墙配置 ---"
firewall-cmd --reload

echo "✅ 基础设施预检完成"

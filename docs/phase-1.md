# Phase 1: Infrastructure & Firewall
## 配置项
- **Kernel Modules**: `overlay`, `br_netfilter` (容器网络基础)
- **Sysctl**: 开启 IP 转发与网桥过滤
- **Firewalld**: 
    - Port 6443: API Server
    - Port 8472: Flannel VXLAN
    - Masquerade: Enabled
- **SELinux**: 保持 Enforcing 状态，后续将配合 `k3s-selinux` 策略包。

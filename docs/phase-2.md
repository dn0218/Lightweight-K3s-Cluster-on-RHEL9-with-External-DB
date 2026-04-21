# Phase 2: K3s Deployment
## 核心配置
- **External DB**: 支持通过 `K3S_DATASTORE_ENDPOINT` 连接 PostgreSQL/MySQL。
- **SELinux**: 集成了 `k3s-selinux` 官方策略包，无需关闭安全检查。
- **Node Taints**: Master 节点默认添加 `NoSchedule` 污点，确保工作负载仅在边缘 Worker 运行。

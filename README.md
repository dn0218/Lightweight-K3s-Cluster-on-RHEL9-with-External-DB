# Lightweight K3s Cluster on RHEL9 with External DB

A professional-grade implementation of a hybrid Kubernetes (K3s) cluster using RHEL 9 (Master) and Rocky Linux 10 (Worker), featuring a fully decoupled Zabbix monitoring stack and an external PostgreSQL database.

## 🚀 Overview
This project demonstrates the deployment of a highly secure and decoupled infrastructure. Unlike standard one-click installs, this setup maintains **SELinux (Enforcing)** and **Firewalld (Active)** throughout the process, ensuring a production-ready security posture.

## 🏗️ Architecture
- **Master Node**: RHEL 9.7 (Internal IP: 192.168.112.139)
- **Worker Node**: Rocky Linux 10 (Internal IP: 192.168.112.136)
- **External Database**: PostgreSQL (Running on Rocky 10 host)
- **Orchestration**: K3s v1.34+ (Lightweight Kubernetes)
- **Monitoring Stack**: Zabbix 7.0 (Server, Web, WebService) deployed via Helm.

## 🌟 Key Features
- **Hybrid OS Integration**: Seamless communication between RHEL 9 and Rocky 10.
- **External Database Decoupling**: K3s control plane and Zabbix data reside on an external PostgreSQL instance for better persistence.
- **Production-Hardened Security**: Full compliance with RHEL 9 security policies without disabling SELinux or Firewalld.
- **Advanced Load Balancing**: Utilized Klipper ServiceLB to map container ports to physical node IPs, bypassing L2 promiscuous mode restrictions in virtualized environments.

## 🛠️ Tech Stack
- **OS**: RedHat Enterprise Linux 9, Rocky Linux 10
- **Containerization**: K3s, Helm, Podman/CRI
- **Networking**: Flannel, Klipper ServiceLB, Firewalld
- **Database**: PostgreSQL 16
- **Monitoring**: Zabbix

## 🚀 Getting Started
1. **Prepare Nodes**: Ensure RHEL 9 and Rocky 10 have static IPs and hostnames configured.
2. **Database Setup**: Configure PostgreSQL on the Rocky host and allow connections from the Pod CIDR (`10.42.0.0/16`).
3. **K3s Installation**: Install K3s with `--datastore-endpoint` pointing to the external DB.
4. **Helm Deployment**:
   ```bash
   helm install zabbix zabbix-community/zabbix -f helm/zabbix-values.yaml --namespace zabbix --create-namespace
   ```
   Access Zabbix: Open http://<Node_IP>:10000 (Default: Admin/zabbix_pass).
   

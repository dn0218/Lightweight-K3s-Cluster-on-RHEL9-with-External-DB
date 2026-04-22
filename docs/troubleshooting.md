Issue: Worker node fails to join, logs show connection attempt to 127.0.0.1:6444.
<img width="976" height="763" alt="image" src="https://github.com/user-attachments/assets/b578ad0e-f3b9-4b79-b7c6-0f047ac7ba44" />

Cause: K3s-agent environment variables not persisting in systemd unit during first run on Rocky 10.
Solution: Explicitly define K3S_URL and K3S_TOKEN in /etc/systemd/system/k3s-agent.service.env.

<img width="980" height="468" alt="image" src="https://github.com/user-attachments/assets/eb202028-fc74-4599-9cd7-6001b1d28595" />

<img width="1158" height="162" alt="image" src="https://github.com/user-attachments/assets/676860b7-6c63-44d3-b34c-ebcbdd0e4ab4" />

## MetalLB L2 Mode Failure
- **Issue**: LoadBalancer IPs were unreachable despite being assigned.
  
- **Root Cause**: Virtualized network adapters (VMware/Cloud) restricted Promiscuous Mode/MAC changes, preventing MetalLB's ARP responses from being recognized.
  
- **Resolution**: Switched from MetalLB to **Klipper ServiceLB**, which uses iptables/forwarding on physical ports, eliminating the need for L2 ARP spoofing.

## Pod Stuck in Pending (Master Taint)
- **Issue**: `zabbix-server` pod remained in `Pending` state for hours.
  
- **Root Cause**: RHEL Master node had a default taint (`node-role.kubernetes.io/control-plane:NoSchedule`) and the pod had strict `nodeSelector` requirements.
- **Resolution**: Removed the Master taint and relaxed the `nodeSelector` in `values.yaml` to allow scheduling on the Master node while ensuring high availability.
  ```bash
  kubectl taint nodes rhel node-role.kubernetes.io/control-plane:NoSchedule-
  ```

## PostgreSQL Connection Refused (HBA Issue)
- **Issue**: zabbix-web and zabbix-server pods could not connect to the database on the Rocky host.

- **Root Cause**: PostgreSQL's pg_hba.conf only allowed local connections. It rejected requests from the Pod network bridge.

- **Resolution**: Updated pg_hba.conf to allow the Pod CIDR and physical node subnet:

## Port Conflict on 80/8080
- **Issue**: ServiceLB EXTERNAL-IP stayed in <pending>.

- **Root Cause**: Physical ports 80 and 8080 were already occupied by system processes (pasta, conmon, nginx).

- **Resolution**: Re-mapped the LoadBalancer service to port 10000 in values.yaml, avoiding conflicts with system-level services.


## Browser Restricted Port (Firefox)
- **Issue**: Accessing http://<IP>:10080 resulted in a "This address is restricted" error in Firefox.

- **Root Cause**: Firefox blocks certain ports (like 10080) for security reasons (cross-protocol attacks).

- **Resolution**: Changed the service port to 10000, a port recognized as safe for web browsing by major browsers.

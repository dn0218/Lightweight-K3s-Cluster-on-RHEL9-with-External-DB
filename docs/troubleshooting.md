Issue: Worker node fails to join, logs show connection attempt to 127.0.0.1:6444.
<img width="976" height="763" alt="image" src="https://github.com/user-attachments/assets/b578ad0e-f3b9-4b79-b7c6-0f047ac7ba44" />

Cause: K3s-agent environment variables not persisting in systemd unit during first run on Rocky 10.
Solution: Explicitly define K3S_URL and K3S_TOKEN in /etc/systemd/system/k3s-agent.service.env.

<img width="980" height="468" alt="image" src="https://github.com/user-attachments/assets/eb202028-fc74-4599-9cd7-6001b1d28595" />

<img width="1158" height="162" alt="image" src="https://github.com/user-attachments/assets/676860b7-6c63-44d3-b34c-ebcbdd0e4ab4" />

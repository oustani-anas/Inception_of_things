
#!/bin/bash
set -e

echo "[Server] Installing K3s server..."

# Install K3s server
curl -sfL https://get.k3s.io | sh -s - --cluster-init

# Copy the node-token into the shared folder so the worker can use it
cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token

echo "[Server] K3s server installed. Token copied to /vagrant/node-token"

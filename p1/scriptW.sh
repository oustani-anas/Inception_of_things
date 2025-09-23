#!/bin/bash
set -e

echo "[Worker] Installing K3s worker..."

# Wait until the server has written the node-token into /vagrant
while [ ! -f /vagrant/node-token ]; do
  echo "[Worker] Waiting for node-token..."
  sleep 5
done

# Read the token
K3S_TOKEN=$(cat /vagrant/node-token)

# Server IP (same as defined in Vagrantfile)
K3S_SERVER_IP="192.168.56.110"

# Install K3s agent
curl -sfL https://get.k3s.io | \
  K3S_URL="https://${K3S_SERVER_IP}:6443" \
  K3S_TOKEN="${K3S_TOKEN}" \
  sh -s - --node-ip "192.168.56.111"

echo "[Worker] K3s worker installed and joined cluster."

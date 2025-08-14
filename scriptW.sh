#!/bin/bash

set -e

echo "Installing k3s worker..."
MASTER_IP=$1

if [ -z "$MASTER_IP" ]; then
  echo "ERROR: MASTER_IP not provided"
  exit 1
fi

TOKEN=$(cat /vagrant/node-token)
curl -sfL https://get.k3s.io | K3S_URL="https://${MASTER_IP}:6443" K3S_TOKEN="$TOKEN" sh -

echo "Worker setup done."

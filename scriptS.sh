
# 1) Turn off swap (Kubernetes requirement)
sudo swapoff -a
echo '# disabled for k8s' | sudo tee -a /etc/fstab
sudo sed -ri '/\sswap\s/s/^/#/' /etc/fstab

# 2) Install k3s server
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644 --disable traefik" sh -

# 3) Configure kubectl for vagrant
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
# Point kubeconfig to the server’s IP (NOT 127.0.0.1)
sed -i 's/127\.0\.0\.1/192.168.56.110/' ~/.kube/config

# 4) Get the join token
sudo cat /var/lib/rancher/k3s/server/node-token

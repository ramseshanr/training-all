# changing the user
sudo -i

# Configure persistent loading of modules.
tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

#  Load at runtime.
modprobe overlay
modprobe br_netfilter

#  Update Iptables Settings.

tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Applying Kernel changes without a reboot
sysctl --system

# Adding Docker Repository GPG Key to Trusted Keys, so it allows the system to verify the integrity of the downloaded Docker packages.
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adding Docker Repository to Ubuntu Package Sources to enable the system to download and install Docker packages from the specified repository.
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install containerd.
apt-get update && apt-get install -y containerd.io

# Configure containerd for Systemd Cgroup Management
mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml

# Reloading Daemon
systemctl daemon-reload
systemctl restart containerd
systemctl enable containerd 
#systemctl status containerd

# Installing Kubernetes Transport cert
apt-get update && apt-get install -y apt-transport-https ca-certificates curl

# Download GPG keys
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Adding Kubernetes Repos
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubelet, kubeadm, kubectl packages.
apt-get update && apt-get install -y kubelet kubeadm kubectl

# Hold 
apt-mark hold kubelet kubeadm kubectl

# Start the kubelet service
systemctl enable kubelet

# Adding worker to cluster
sudo kubeadm join 172.31.34.85:6443 --token paqb15.av8wmgilojhkt9y1 \
        --discovery-token-ca-cert-hash sha256:e4d0a45bf8f37e47f058e8e72ef7faf2a3e1aaa0d3bb078fb54c13f0eefe7a0a 
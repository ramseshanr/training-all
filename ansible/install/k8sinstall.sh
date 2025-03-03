#!bin/bash
# sudo apt-get update
# sudo apt install net-tools
#ssh ubuntu@172.31.33.33 'bash -s' < k8sinstall.sh
#sudo -i
sudo apt-get update -y
# Loading Modules
tee /etc/modules-load.d/containerd.conf <<EOF
     overlay
     br_netfilter
EOF
# Load at Runtime.
modprobe overlay
modprobe br_netfilter
# IPtable Settings.
tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
# Applying Kernel Settings Without Reboot.
sysctl --system
# Adding Docker Repository GPG Key to Trusted Keys, so it allows the system to verify the integrity of the downloaded Docker packages
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Adding Docker Repository to Ubuntu Package Sources to enable the system to download and install Docker packages from the specified repository.
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Container d.
apt-get update && apt-get install -y containerd.io
# Configure containerd for Systemd Cgroup Management to enable the use of systemd for managing cgroups in containerd.
mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml
#Reloading Daemon, Restarting, Enabling, and Checking containerd Service Status
systemctl daemon-reload
systemctl restart containerd
systemctl enable containerd
systemctl status containerd --no-pager
# Update the apt package index and install packages needed to use the Kubernetes https certificate configuration.
apt-get update && apt-get install -y apt-transport-https ca-certificates curl
# Download the GPG key, as it is used to verify Kubernetes packages from the Kubernetes package repository &
# store it in the kubernetes-apt-keyring.gpg file in the /etc/apt/keyrings/ directory
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# Add the Kubernetes Repository to System’s Package Sources.
# This command adds the Kubernetes repository to the system’s list of package sources by appending the repository information to the file.
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Install kubelet, kubeadm, kubectl packages
apt-get update && apt-get install -y kubelet kubeadm kubectl
# hold the installed packages at their installed versions
apt-mark hold kubelet kubeadm kubectl
# Start the kubelet service is required on all the nodes.
systemctl enable kubelet

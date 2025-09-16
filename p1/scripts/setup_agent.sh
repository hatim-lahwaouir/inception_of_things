
sudo ufw disable
token=$(cat /home/vagrant/conf/token)

curl -sfL https://get.k3s.io | K3S_URL="https://$1:6443" INSTALL_K3S_EXEC="--node-ip=$2" K3S_TOKEN=$token sh - 


# installing master node 
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=$1" sh -

while [ ! -f /var/lib/rancher/k3s/server/node-token ]
do
	echo "file doesn't exists"
	sleep 1 
done


cat /var/lib/rancher/k3s/server/node-token > /home/vagrant/conf/token


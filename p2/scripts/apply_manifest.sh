cd /vagrant/conf 

until kubectl get nodes 2>/dev/null
do
    sleep 2 
done

sudo kubectl  wait --for condition=established --timeout=60s crd/traefikservices.traefik.io

kubectl apply -f app1_deployment.yaml
kubectl apply -f app2_deployment.yaml
kubectl apply -f app3_deployment.yaml



while [ ! -f /var/lib/rancher/k3s/server/manifests/traefik.yaml ]
do
  sleep 2 # or less like 0.2
done


echo "waiting for traefik  running "
until kubectl get pods -n kube-system | grep -E -i '^(traefik)' 1>/dev/null 2>/dev/null
do
    sleep 1 
done

kubectl apply -f ingress.yaml

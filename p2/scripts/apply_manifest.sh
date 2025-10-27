cd /vagrant/conf 

until kubectl get nodes 2>/dev/null
do
    sleep 2 
done


kubectl apply -f app1_deployment.yaml
kubectl apply -f app2_deployment.yaml
kubectl apply -f app3_deployment.yaml



echo "waiting for traefik  creation"
sudo kubectl wait pod  --for=create -n kube-system -l app.kubernetes.io/name=traefik  --timeout=180s

echo "waiting for traefik  running"
sudo kubectl wait pod --for=condition=Ready -n kube-system -l app.kubernetes.io/name=traefik --for=jsonpath='{.status.phase}'=Running --timeout=180s

kubectl apply -f ingress.yaml

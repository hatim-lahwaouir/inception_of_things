#!/bin/sh



apk update 
apk upgrade
apk add docker


rc-update add docker boot
service docker start

apk add bash

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


k3d cluster delete p3 1>/dev/null
k3d cluster create p3 --api-port 6550 -p "8081:80@loadbalancer"



kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml



while kubectl get pods -n argocd | grep "0/1"; do
  echo "Waiting for pods to be ready..."
  sleep 5
done
echo "All pods in argocd namespace are ready."



kubectl apply -f  ../conf/argocd.yaml
kubectl -n argocd get secret argocd-initial-admin-secret \
          -o jsonpath="{.data.password}" | base64 | cat > $HOME/argocd_secret.txt




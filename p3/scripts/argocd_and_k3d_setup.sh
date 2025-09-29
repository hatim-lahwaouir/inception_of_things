#!/bin/sh
k3d cluster delete p3 1>/dev/null
k3d cluster create p3 --api-port 6550 -p "0.0.0.0:8081:80@loadbalancer"

# Create namespace first
kubectl create namespace argocd


# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
while kubectl get pods -n argocd | grep "0/1"; do
  echo "Waiting for pods to be ready..."
  sleep 5
done
echo "All pods in argocd namespace are ready."

# Apply the ingress route
kubectl apply -f ../conf/ingress.yml
kubectl apply -f ../conf/argocd-cmd-params-cm.yml
kubectl -n argocd rollout restart deployment argocd-server
while kubectl get pods -n argocd | grep "0/1"; do
  echo "Waiting for pods to be ready..."
  sleep 5
done
echo "All pods in argocd namespace are ready."
kubectl apply -f ../conf/argocd.yml

# Get password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d | cat > $HOME/argocd_secret.txt

echo "Setup complete! ArgoCD should be accessible at http://10.12.100.143:8081"
echo "Username: admin"
echo "Password saved in: $HOME/argocd_secret.txt"

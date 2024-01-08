#!/bin/bash

## Ssl cert-manager, nginx controller, wordpress issuer, ingress installation ##

# Get AKS cluster credentials
az aks get-credentials --resource-group PERSO_DRITON --name dritonclusterprod

# Create a new Kubernetes namespace called 'dev-env'
kubectl create ns prod-env
# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.4/cert-manager.yaml
# Sleep for 20 seconds (allow time for cert-manager to be ready)
sleep 20
# Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
# Sleep for 30 seconds (allow time for the NGINX Ingress Controller to be ready)
sleep 30
# Apply issuer.yaml for SSL certificates
kubectl apply -f issuer.yaml
# Sleep for 10 seconds (allow time for issuer to be created)
sleep 10
# Apply ingress.yaml for SSL certificates
kubectl apply -f ingress.yaml
# Sleep for 5 seconds
sleep 5
# Print a message indicating successful installation
echo "Cert-manager, NGINX Ingress Controller, WordPress issuer, and ingress have been installed"
sleep 5

# Wordpress Deployment
# Apply WordPress configuration
kubectl apply -f wordpress-configmap.yaml
# Apply WordPress deployment
kubectl apply -f wordpress_dep.yaml
# Sleep for 5 seconds
sleep 5
# Print a message indicating successful WordPress deployment
echo "WordPress has been deployed"

# Helm, Grafana, Prometheus, Loki Installation
# Add Grafana Helm repository
helm repo add grafana https://grafana.github.io/helm-charts
# Update Helm repositories
helm repo update
# Install Loki with Grafana enabled
helm upgrade --install loki grafana/loki-stack --namespace monitoring --set grafana.enabled=true --create-namespace 
# Add Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts --namespace monitoring
# Update Helm repositories
helm repo update
# Install Prometheus
helm install my-prometheus --namespace monitoring prometheus-community/prometheus --version 24.4.0
# Sleep for 10 seconds
sleep 10
# Print the admin password for Grafana
echo "Secret connect key for GRAFANA: $(kubectl get secret --namespace monitoring loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)"
# Print the external IP address of the NGINX Ingress Controller
echo "External IP Address of Ingress NGINX Controller: $(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
# Print a message indicating successful installation of Helm, Grafana, Prometheus, and Loki
echo "Helm, Grafana, Prometheus, and Loki have been installed"



















### Dashboar ID's for Grafana.

# node exporter: 1860
# Loki dash: 13639
# Prometheuse dashboard namespace: 15758
# Linux stats: 14731

#####


# querry for grafana rule CPU_USAGE: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
# querry for grafana rule RAM_USAGE: 100 - ((node_memory_MemAvailable_bytes{node="aks-defalut-11720612-vmss000000"} * 100) / node_memory_MemTotal_bytes{node="aks-defalut-11720612-vmss000000"})

# Test load using wrk: 
# wrk -t10 -c100 -d120s http://wordpresstonysite.sandbox.aws.teamwork.net/
# Running 2m test @ http://wordpresstonysite.sandbox.aws.teamwork.net/
# wrk -t50 -c200 -d5m http://wordpresstonysite.sandbox.aws.teamwork.net/
# Running 5m test @ http://wordpresstonysite.sandbox.aws.teamwork.net/

#########
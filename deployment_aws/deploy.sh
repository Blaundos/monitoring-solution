#!/bin/bash

# Check if prerequisites are installed
echo "Checking prerequisites..."
command -v eksctl >/dev/null 2>&1 || { echo >&2 "eksctl is required but not installed. Aborting."; exit 1; }
command -v aws >/dev/null 2>&1 || { echo >&2 "AWS CLI is required but not installed. Aborting."; exit 1; }
command -v helm >/dev/null 2>&1 || { echo >&2 "Helm is required but not installed. Aborting."; exit 1; }

# Set variables
CLUSTER_NAME="my-cluster"
REGION="us-west-2"
NODES=2
NODES_MIN=1
NODES_MAX=3
NODEGROUP_NAME="linux-nodes"

# Create EKS Cluster
echo "Creating EKS cluster..."
eksctl create cluster --name $CLUSTER_NAME --region $REGION --nodegroup-name $NODEGROUP_NAME --nodes $NODES --nodes-min $NODES_MIN --nodes-max $NODES_MAX --managed

if [ $? -ne 0 ]; then
  echo "Failed to create EKS cluster. Aborting."
  exit 1
fi

# Add Helm Repositories
echo "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create namespaces
echo "Creating namespaces..."
kubectl create namespace prometheus
kubectl create namespace grafana

# Install Prometheus
echo "Installing Prometheus..."
helm install prometheus prometheus-community/prometheus --namespace prometheus

if [ $? -ne 0 ]; then
  echo "Failed to install Prometheus. Aborting."
  exit 1
fi

# Install Grafana
echo "Installing Grafana..."
helm install grafana grafana/grafana --namespace grafana

if [ $? -ne 0 ]; then
  echo "Failed to install Grafana. Aborting."
  exit 1
fi

# Install Simple Monitored App
echo "Installing simple monitored app..."
helm install simple-monitored-app ./simple-monitored-app

if [ $? -ne 0 ]; then
  echo "Failed to install simple monitored app. Aborting."
  exit 1
fi

# Provide Access Information
echo "Deployment completed successfully."
echo "To access Grafana, run: kubectl get service -n grafana"
echo "To access Prometheus, run: kubectl get service -n prometheus"

#!/bin/bash
eksctl create cluster --name my-cluster --region us-west-2 --nodegroup-name linux-nodes --nodes 2 --nodes-min 1 --nodes-max 3 --managed
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
helm install grafana grafana/grafana
helm install simple-monitored-app ./simple-monitored-app

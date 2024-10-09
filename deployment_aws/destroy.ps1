# destroy.ps1

# Uninstall Simple Monitored App
helm uninstall simple-monitored-app

# Uninstall Grafana
helm uninstall grafana

# Uninstall Prometheus
helm uninstall prometheus

# Delete the EKS Cluster
eksctl delete cluster --name my-cluster --region us-west-2

# deploy.ps1

# Create the EKS Cluster
eksctl create cluster --name my-cluster --region us-west-2 --nodegroup-name linux-nodes --nodes 2 --nodes-min 1 --nodes-max 3 --managed

# Add Helm Repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/prometheus

# Install Grafana
helm install grafana grafana/grafana

# Install Simple Monitored App
helm install simple-monitored-app ./simple-monitored-app

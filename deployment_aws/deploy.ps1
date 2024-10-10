# deploy.ps1

# Check if prerequisites are installed
Write-Output "Checking prerequisites..."
if (-not (Get-Command eksctl -ErrorAction SilentlyContinue)) {
    Write-Error "eksctl is required but not installed. Aborting."
    exit 1
}
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Error "AWS CLI is required but not installed. Aborting."
    exit 1
}
if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    Write-Error "Helm is required but not installed. Aborting."
    exit 1
}

# Set variables
$ClusterName = "my-cluster"
$Region = "us-west-1"
$Nodes = 2
$NodesMin = 1
$NodesMax = 3
$NodeGroupName = "linux-nodes"

# Check if EKS Cluster already exists
Write-Output "Checking if EKS cluster already exists..."
try {
    eksctl get cluster --name $ClusterName --region $Region -o json | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "EKS cluster '$ClusterName' already exists."
        $response = Read-Host "Do you want to delete the existing cluster and recreate it? (yes/no)"
        if ($response -eq "yes") {
            Write-Output "Deleting existing EKS cluster..."
            eksctl delete cluster --name $ClusterName --region $Region
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to delete existing EKS cluster. Aborting."
                exit 1
            }
        } else {
            Write-Output "Skipping cluster creation. Proceeding with the existing cluster."
        }
    }
} catch {
    Write-Output "Cluster does not exist. Proceeding with cluster creation."
}

# Create EKS Cluster
if (-not $existingCluster) {
    Write-Output "Creating EKS cluster..."
    eksctl create cluster --name $ClusterName --region $Region --nodegroup-name $NodeGroupName --nodes $Nodes --nodes-min $NodesMin --nodes-max $NodesMax --managed

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create EKS cluster. Aborting. Please ensure your AWS credentials are correctly configured and you have network connectivity."
        exit 1
    }
}

# Add Helm Repositories
Write-Output "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create namespaces
Write-Output "Creating namespaces..."
kubectl create namespace prometheus -ErrorAction SilentlyContinue
kubectl create namespace grafana -ErrorAction SilentlyContinue

# Install Prometheus
Write-Output "Installing Prometheus..."
helm install prometheus prometheus-community/prometheus --namespace prometheus

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install Prometheus. Aborting."
    exit 1
}

# Install Grafana
Write-Output "Installing Grafana..."
helm install grafana grafana/grafana --namespace grafana

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install Grafana. Aborting."
    exit 1
}

# Install Simple Monitored App
Write-Output "Installing simple monitored app..."
helm install simple-monitored-app ./simple-monitored-app

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to install simple monitored app. Aborting."
    exit 1
}

# Provide Access Information
Write-Output "Deployment completed successfully."
Write-Output "To access Grafana, run: kubectl get service -n grafana"
Write-Output "To access Prometheus, run: kubectl get service -n prometheus"

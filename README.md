# Monitoring Solution for Microservices Architecture

## Overview

This repository contains the setup for a comprehensive monitoring solution for a distributed microservices architecture. The solution integrates **Prometheus**, **Grafana**, **Jaeger**, and **Fluentd** to provide logging, metrics, and tracing capabilities. The deployment can be performed using Kubernetes manifests or automated scripts for AWS environments.

## Folder Structure

```
monitoring-solution/
├── app/
│   └── app.py                       # Sample microservice application
├── prometheus/
│   ├── prometheus.yml               # Prometheus configuration file
│   └── deployment.yml               # Kubernetes deployment for Prometheus
├── grafana/
│   ├── grafana-datasources.yml      # Grafana data source configuration
│   └── deployment.yml               # Kubernetes deployment for Grafana
├── jaeger/
│   ├── deployment.yml               # Kubernetes deployment for Jaeger
├── fluentd/
│   ├── fluentd-configmap.yml        # Fluentd configuration for logging
│   └── deployment.yml               # Kubernetes deployment for Fluentd
├── kubernetes/
│   ├── horizontal-pod-autoscaler.yml # Kubernetes HPA manifest
│   └── microservice.yml              # Example microservice deployment
└── deployment_aws/
    ├── Dockerfile                   # Docker image for AWS deployment
    ├── deploy.ps1                   # PowerShell script for automated deployment
    ├── deploy.sh                    # Shell script for automated deployment
    ├── deployment.yml               # AWS deployment configuration
    ├── destroy.ps1                  # PowerShell script for tearing down resources
    ├── destroy.sh                   # Shell script for tearing down resources
    └── eks-cluster.tf               # Terraform configuration for AWS EKS cluster
```

## Prerequisites

- **Kubernetes cluster** (e.g., Minikube, EKS, GKE, or AKS)
- **kubectl** installed and configured
- **Docker** for building container images
- **AWS CLI** and **Terraform** (for AWS automated deployment)

## Deployment Instructions

### Manual Deployment using Kubernetes Manifests

1. **Prometheus**:

   - Apply the Prometheus ConfigMap and Deployment:
     ```sh
     kubectl apply -f prometheus/prometheus.yml
     kubectl apply -f prometheus/deployment.yml
     ```

2. **Grafana**:

   - Apply the Grafana ConfigMap and Deployment:
     ```sh
     kubectl apply -f grafana/grafana-datasources.yml
     kubectl apply -f grafana/deployment.yml
     ```

3. **Jaeger**:

   - Apply the Jaeger Deployment:
     ```sh
     kubectl apply -f jaeger/deployment.yml
     ```

4. **Fluentd**:

   - Apply the Fluentd ConfigMap and Deployment:
     ```sh
     kubectl apply -f fluentd/fluentd-configmap.yml
     kubectl apply -f fluentd/deployment.yml
     ```

5. **Microservice and Autoscaling**:

   - Deploy the sample microservice and set up autoscaling:
     ```sh
     kubectl apply -f kubernetes/microservice.yml
     kubectl apply -f kubernetes/horizontal-pod-autoscaler.yml
     ```

6. **Verify Deployments**:

   - Check the status of the pods and services:
     ```sh
     kubectl get pods
     kubectl get services
     ```

7. **Accessing the Monitoring Tools**:

   - **Grafana**:
     - To access Grafana, run:
       ```sh
       kubectl get service grafana
       ```
     - Note the external IP or NodePort, and open it in your browser to view the Grafana dashboards.

   - **Prometheus**:
     - Access Prometheus similarly:
       ```sh
       kubectl get service prometheus
       ```
     - Use the address to open Prometheus and explore the collected metrics.

   - **Jaeger**:
     - To access Jaeger, run:
       ```sh
       kubectl get service jaeger
       ```
     - Use the provided address to open Jaeger's UI and trace requests between services.

### Automated Deployment on AWS

The automated deployment is handled using **Terraform**, **PowerShell**, and **Shell** scripts to set up an EKS cluster and deploy the monitoring stack.

#### Deploy using PowerShell

1. **Setup AWS CLI**: Ensure your AWS CLI is configured with appropriate credentials.
2. **Run Deployment Script**:
   - Use the PowerShell script to deploy the entire stack to AWS:
     ```powershell
     ./deployment_aws/deploy.ps1
     ```
3. **Verify Resources**:
   - After deployment, verify the EKS cluster and services using AWS Console or CLI.

#### Deploy using Shell Script

1. **Setup AWS CLI**: Ensure your AWS CLI is configured with appropriate credentials.
2. **Run Deployment Script**:
   - Use the shell script to deploy the entire stack to AWS:
     ```sh
     bash deployment_aws/deploy.sh
     ```
3. **Verify Resources**:
   - Verify the status of resources using Kubernetes commands or the AWS Console.

#### Tearing Down the Deployment

- To destroy the resources created in AWS, you can use the provided scripts:
  - **PowerShell**:
    ```powershell
    ./deployment_aws/destroy.ps1
    ```
  - **Shell**:
    ```sh
    bash deployment_aws/destroy.sh
    ```

## Common Problems and Solutions

- **Services Not Found**: Ensure all services are running by using `kubectl get pods`.
- **Access Issues**: If you can't access Grafana, Prometheus, or Jaeger, ensure the NodePort services are open and accessible from your machine.
- **Metrics Missing**: If Grafana dashboards are empty, verify that Prometheus is scraping metrics correctly.
- **Deployment Failures**: Check the logs using `kubectl logs <pod-name>` to identify issues.

## Notes

- Customize the Prometheus, Grafana, and Fluentd configurations as per your environment.
- Modify the Dockerfile to use custom application images if required.
- Ensure appropriate IAM permissions are granted for EKS and related AWS resources when using the automated deployment scripts.
- For troubleshooting, use `kubectl logs <pod-name>` to check application logs, and verify networking and IAM configurations in AWS if using the automated deployment.

#!/bin/bash
helm uninstall simple-monitored-app
helm uninstall grafana
helm uninstall prometheus
eksctl delete cluster --name my-cluster --region us-west-2

provider "aws" {
  region = "us-west-1"
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "<EKS-Cluster-Role-ARN>"

  vpc_config {
    subnet_ids = ["<subnet-id-1>", "<subnet-id-2>"]
  }
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "linux-nodes"
  node_role_arn   = "<Node-Instance-Role-ARN>"
  subnet_ids      = ["<subnet-id-1>", "<subnet-id-2>"]
  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}

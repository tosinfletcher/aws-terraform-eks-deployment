resource "aws_iam_role" "tfletcher_eks_role" {
  name = "tfletcher_eks_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "tfletcher_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tfletcher_eks_role.name
}


resource "aws_eks_cluster" "tfletcher_eks_cluster" {
  name     = "tfletcher_eks_cluster"
  role_arn = aws_iam_role.tfletcher_eks_role.arn


  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false

    subnet_ids = [
      aws_subnet.tfletcher_public_1.id,
      aws_subnet.tfletcher_public_2.id,
      aws_subnet.tfletcher_public_3.id,
      aws_subnet.tfletcher_private_1.id,
      aws_subnet.tfletcher_private_2.id,
    aws_subnet.tfletcher_private_3.id]
  }
  depends_on = [aws_iam_role_policy_attachment.tfletcher_AmazonEKSClusterPolicy]
}



resource "aws_iam_role" "tfletcher_eks_node_group_role" {
  name = "tfletcher_eks_node_group_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "tfletcher_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tfletcher_eks_node_group_role.name
}


resource "aws_iam_role_policy_attachment" "tfletcher_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.tfletcher_eks_node_group_role.name
}


resource "aws_iam_role_policy_attachment" "tfletcher_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tfletcher_eks_node_group_role.name
}


resource "aws_eks_node_group" "tfletcher_eks_node_group" {
  cluster_name    = aws_eks_cluster.tfletcher_eks_cluster.name
  node_group_name = "tfletcher_eks_node_group"
  node_role_arn   = aws_iam_role.tfletcher_eks_node_group_role.arn
  subnet_ids      = [aws_subnet.tfletcher_private_1.id, aws_subnet.tfletcher_private_2.id, aws_subnet.tfletcher_private_3.id]
  instance_types  = ["t2.micro"]
  disk_size       = 8

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.tfletcher_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.tfletcher_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.tfletcher_AmazonEC2ContainerRegistryReadOnly,
  ]
}

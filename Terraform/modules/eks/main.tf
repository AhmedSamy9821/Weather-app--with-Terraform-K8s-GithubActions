##############
#eks_cluster module creates eks cluster and node group
##############

#Create IAM Role for EKS Cluster
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks-cluster-role" {
  name               = "eks-cluster-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


#Attach Policies to Eks role
resource "aws_iam_role_policy_attachment" "eks-cluster-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}


#Create Eks cluster
resource "aws_eks_cluster" "weather-cluster" {
  name     = "weather-cluster-${var.env}"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-role-AmazonEKSVPCResourceController,
  ]

  tags = {
    env = var.env
  }
}


#create eks node group

#IAM Role for EKS Node Group and attach required policeis to it

resource "aws_iam_role" "eks-nodegroup-role" {
  name = "eks-nodegroup-role-${var.env}"

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

resource "aws_iam_role_policy_attachment" "eks-nodegroup-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-nodegroup-role.name
}

resource "aws_iam_role_policy_attachment" "eks-nodegroup-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-nodegroup-role.name
}

resource "aws_iam_role_policy_attachment" "eks-nodegroup-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-nodegroup-role.name
}


#create node group
resource "aws_eks_node_group" "weather-nodegroup" {
  cluster_name    = aws_eks_cluster.weather-cluster.name
  node_group_name = "weather-nodegroup-${var.env}"
  node_role_arn   = aws_iam_role.eks-nodegroup-role.arn
  subnet_ids      = var.subnet_ids
  instance_types = var.nodes_instance_types
  ami_type = "AL2023_x86_64_STANDARD"

  scaling_config {
    desired_size = var.auto_scaling_config["desired_size"]
    max_size     = var.auto_scaling_config["max_size"]
    min_size     = var.auto_scaling_config["min_size"]
  }
  
  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-nodegroup-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-nodegroup-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-nodegroup-role-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    env = var.env
  }
}


#Attach EBS IAM role to OIDC to be able to manage EBS


locals {
  OIDC = replace(aws_eks_cluster.weather-cluster.identity[0].oidc[0].issuer, "https://", "")
}

resource "aws_iam_role" "EBS-role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Federated": "arn:aws:iam::637423498743:${local.OIDC}"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
            "StringEquals": {
              "${local.OIDC}:aud": "sts.amazonaws.com",
              "${local.OIDC}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            }
          }
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "EBS-role-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.EBS-role.name
}


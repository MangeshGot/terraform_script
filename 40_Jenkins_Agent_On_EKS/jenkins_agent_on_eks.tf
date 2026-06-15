#=========================================================================
#PHASE 1 : IAM ROLES FOR EKS
#=========================================================================

# 1. EKS Cluster Role (The Brain)
resource "aws_iam_role" "eks-control-plane-role" {
    name = "EKS-Control-Plane-Role"

    assume_role_policy =jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "eks.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks-control-plane-role.name
}
# 2. Worker Node Role (The Muscle)
resource "aws_iam_role" "eks-worker-node-role" {
    name = "EKS-Worker-Node-Role"
    assume_role_policy =jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks-worker-node-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.eks-worker-node-role.name
}

resource "aws_iam_role_policy_attachment" "eks-ec2-container-registry-readonly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.eks-worker-node-role.name
}

#=========================================================================
#PHASE 2 : EKS CONTROL PLANE
#=========================================================================

resource "aws_eks_cluster" "jenkins-eks-cluster" {
  name     = "jenkins-eks-cluster"
  role_arn = aws_iam_role.eks-control-plane-role.arn

  vpc_config {
    subnet_ids = [
        aws_subnet.eks_public_subnet_1.id, 
        aws_subnet.eks_public_subnet_2.id,
        aws_subnet.eks_private_subnet_1.id,
        aws_subnet.eks_private_subnet_2.id
        ]
        endpoint_private_access = true
        endpoint_public_access  = true
  }
  # Ensure IAM policies are attached before creating the EKS cluster
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy
  ]
}

#=========================================================================
#PHASE 3 : EKS WORKER NODES
#=========================================================================

resource "aws_eks_node_group" "jenkins-eks-node-group" {
  cluster_name    = aws_eks_cluster.jenkins-eks-cluster.name
  node_group_name = "jenkins-eks-node-group"
  node_role_arn   = aws_iam_role.eks-worker-node-role.arn
  #CRITICAL: We only put the worker nodes in the private subnets, not the public subnets. This is a best practice for security.
  subnet_ids      = [
        aws_subnet.eks_private_subnet_1.id,
        aws_subnet.eks_private_subnet_2.id
        ]
    capacity_type = "ON_DEMAND"
    instance_types = ["c7i-flex.large"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure IAM policies are attached before creating the EKS node group
  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-cni-policy,
    aws_iam_role_policy_attachment.eks-ec2-container-registry-readonly
  ]
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.jenkins-eks-cluster.endpoint
}

output "eks_cluster_name" {
    value = aws_eks_cluster.jenkins-eks-cluster.name
}
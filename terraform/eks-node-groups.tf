# Create IAM role for EKS Node Group
resource "aws_iam_role" "nodes_general" {
  # The name of the role
  name = "eks-node-group-general"

  # The policy that grants an entity permission to assume the role.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  policy_arn = var.policy_arn_ec2_1

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = var.policy_arn_ec2_2

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = var.policy_arn_ec2_3

  role = aws_iam_role.nodes_general.name
}

resource "aws_eks_node_group" "nodes_general" {
  # Name of the EKS Cluster.
  cluster_name = aws_eks_cluster.eks.name

  # Name of the EKS Node Group.
  node_group_name = var.node_group_name

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  node_role_arn = aws_iam_role.nodes_general.arn

  # Identifiers of EC2 Subnets to associate with the EKS Node Group. 
  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME 
  # (where CLUSTER_NAME is replaced with the name of the EKS Cluster).
  subnet_ids = [
    aws_subnet.private_subnet1.id,
    aws_subnet.private_subnet2.id
  ]

  # Configuration block with scaling settings
  scaling_config {
    desired_size = 2
    max_size = 2
    min_size = 1
  }

  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = var.ami_type

  # Type of capacity associated with the EKS Node Group. 
  # Valid values: ON_DEMAND, SPOT
  capacity_type = var.capacity_type

  # Disk size in GiB for worker nodes
  disk_size = 10

  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  force_update_version = false

  # List of instance types associated with the EKS Node Group
  instance_types = ["t2.small"]

  labels = {
    role = var.node_group_name
  }

  # Kubernetes version
  version = var.version_number

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}
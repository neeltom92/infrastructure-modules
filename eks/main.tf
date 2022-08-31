provider "aws" {
  region = var.aws_region
}

terraform {
  # Intentionally empty. Will be filled by Terragrunt.
  backend "s3" {}
}


data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "cluster_additional_security_group" {
  name_prefix = "cluster_additional_security_group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_iam_policy" "secret_manager_read_only" {
  name = "SecretsManagerReadOnly"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds",
                "secretsmanager:ListSecrets"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF

  tags = {
    Name = "SecretsManagerReadOnly"
}
}


resource "aws_kms_key" "kms_key" {
  description = "EKS cluster encryption"
}

module "eks" {
  source                                = "terraform-aws-modules/eks/aws"
  version                               = "18.29.0"
  cluster_name                          = var.cluster_name
  cluster_version                       = var.cluster_version
  subnet_ids                            = var.private_subnets
  cluster_additional_security_group_ids = [aws_security_group.cluster_additional_security_group.id]
  vpc_id                                = var.vpc_id
  cluster_enabled_log_types             = ["audit"]
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = false
  cluster_addons                        = {}
  iam_role_name                         = var.cluster_name
  iam_role_use_name_prefix              = false
  cluster_encryption_config = [{
  provider_key_arn = aws_kms_key.kms_key.arn
  resources        = ["secrets"]
}]

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = var.disksize
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
    bootstrap_extra_args   = "--container-runtime containerd --kubelet-extra-args '--max-pods=20'"
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
      "arn:aws:iam::${var.aws_account_id}:policy/SecretsManagerReadOnly"
    ]
    remote_access = {
      ec2_ssh_key               = var.sshkeys
      source_security_group_ids = [aws_security_group.all_worker_mgmt.id]
    }
  }

  eks_managed_node_groups = {
    default = {
      min_size               = 1
      max_size               = var.max_size
      desired_size           = var.desired_size
      create_launch_template = false
      launch_template_name   = "default"
      instance_types         = [var.spot_instance_types]
      capacity_type          = "SPOT"
      labels = {
        env  = var.environment
        kind = "default"
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }
      tags = {
        Name    = "${module.eks.cluster_id}-default"
        environment = var.environment
      }
    }
    shared = {
      min_size               = 1
      max_size               = var.max_size
      desired_size           = var.desired_size
      create_launch_template = false
      launch_template_name   = "shared"
      instance_types         = [var.ondemand_shared_instance_type]
      capacity_type          = "ON_DEMAND"
      labels = {
        env  = var.environment
        kind = "shared"
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      tags = {
        Name    = "${module.eks.cluster_id}-shared"
        environment = var.environment
      }
    }
    memory-intensive = {
      min_size               = 1
      max_size               = var.max_size
      desired_size           = var.desired_size
      create_launch_template = false
      launch_template_name   = "memory-intensive"
      instance_types         = [var.ondemand_memory_instance_type]
      capacity_type          = "ON_DEMAND"
      labels = {
        env  = var.environment
        kind = "memory-intensive"
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      tags = {
        Name    = "${module.eks.cluster_id}-memory-intensive"
        environment = var.environment
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

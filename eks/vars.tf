variable "aws_region" {
  description = "EKS cluster creation region"
  type        = string
}


variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes Cluster Version"
  type        = string
}

variable "vpc_id" {
  description = "AWS VPC ID to launch the control plane and worker nodes"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID number"
  type        = string
}


variable "sshkeys" {
  description = "SSH keys to access the worker nodes"
  type        = string
}

variable "private_subnets" {
  description = "The list of subnet group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "environment" {
  description = "the Deployment environment"
  type        = string
}

variable "disksize" {
  description = "the disk size of the node group nodes "
  type        = string
}

variable "spot_instance_types" {
  description = "List of instance types for SPOT instance selection"
  type        = list(string)
  default     = null
}

variable "ondemand_shared_instance_type" {
  description = "List of instance types for shared instance selection"
  type        = list(string)
  default     = null
}

variable "ondemand_memory_instance_type" {

  description = "Node group with high memeory utilisation"
  type        = list(string)
  default     = null
}

variable "max_size" {
  default = 2
  description = "How many instance can be created max"
}
variable "desired_size" {
  default = 1
  description = "How many instance should be running at all times"
}

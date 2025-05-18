variable "node_count" {
  type        = map(number)
  default     = {}
  description = "nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}
variable "name" {
  type    = string
  default = "false"
}


# group attributes
variable "image" {
  description = "The name of the image family for elasticsearch"
  default     = "elasticsearch7-packer-image"
}
variable "singlenode_mode" {
  type    = string
  default = "false"
}

variable "startup_script" {
  type    = string
  default = "false"
}
variable "heap_size" {
  type    = string
}

variable "instance_type" {
  type    = string
}
variable "extra_disk_exists" {
  type    = string
}

variable "extra_disk_size" {
  type    = string
  default = "100" # gb
}

variable "extra_disk_type" {
  description = "disk type"
  default = "gp3"
}
variable "extra_disk_iops" {
  description = "data disk IOPS"
  default = "3000"
}
variable "extra_disk_throughput" {
  description = "data disk throughput"
  default = "125"
}

variable "extra_disk_encryption" {
  default = true
}

variable "security_group_ids" {
  type = set(string)
}

# cluster attributes

variable "environment" {
  default = "default"
}

variable "es_cluster" {
  description = "Name of the elasticsearch cluster, used in node discovery"
}

variable "key_name" {
  description = "Key name to be used with the launched EC2 instances."
  default     = "elasticsearch"
}
variable "ebs_optimized" {
  description = "Whether data instances are EBS optimized or not"
  default     = "true"
}

variable "instance_profile_arn" {
  type = string
}
variable "user_data_common" {
  type = map(string)
}
variable "target_group_arns" {
  type = list(string)
}
variable "asg_subnet_ids" {
  description = "Subnets for the auto scaling groups. Defaults to all VPC subnets."
  default     = []
}
variable "is_voting_only" {
  default     = "false"
}

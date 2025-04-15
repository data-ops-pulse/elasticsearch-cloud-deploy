### MANDATORY ###
variable "es_cluster" {
  description = "Name of the elasticsearch cluster, used in node discovery"
}

variable "aws_region" {
  type = string
}

variable "environment" {
  default = "default"
}

# networking 
variable "vpc_id" {
  description = "VPC ID to create the Elasticsearch cluster in"
  type        = string
}

variable "clients_subnet_ids" {
  description = "Subnets to run client nodes in, defined as avalabilityZone -> subnets mapping. Will autofill to all available subnets in AZ when left empty."
  type        = map(list(string))
  default     = {}
}

variable "lb_subnet_ids" {
  description = "Subnets for the load balancer. Defaults to all VPC subnets."
  default     = []
}

variable "asg_subnet_ids" {
  description = "Subnets for the auto scaling groups. Defaults to all VPC subnets."
  default     = []
}

variable "ec2_vpc_endpoint_id" {
  description = "Use to skip creation of ec2 VPC endpoint and reference your own"
  default     = ""
}

variable "s3_vpc_endpoint_id" {
  description = "Use to skip creation of s3 VPC endpoint and reference your own"
  default     = ""
}

variable "autoscaling_vpc_endpoint_id" {
  description = "Use to skip creation of autoscaling VPC endpoint and reference your own"
  default     = ""
}

variable "singlenode_az" {
  description = "This variable is required when running in singlenode mode. Singlenode mode is enabled when masters_count, datas_count and clients_count are all empty,"
  default     = ""
}

variable "singlenode_subnet_id" {
  description = "This variable is required when running in singlenode mode. Singlenode mode is enabled when masters_count, datas_count and clients_count are all empty,"
  default     = ""
}

variable "bootstrap_node_subnet_id" {
  description = "Use to override which subnet the bootstrap node is created in."
  default     = ""
}

# security
variable "key_name" {
  description = "Key name to be used with the launched EC2 instances."
  default     = "elasticsearch"
}

variable "security_enabled" {
  description = "Whether or not to enable x-pack security on the cluster"
  default     = false
}

variable "client_user" {
  description = "The username to use when setting up basic auth on Grafana and Cerebro."
  default     = "elastic"
}

variable "public_facing" {
  description = "Whether or not the created cluster should be accessible from the public internet"
  type        = bool
  default     = true
}

variable "alb_security_groups" {
  description = "security groups with ALB access"
  default = []
}

# the ability to add additional existing security groups. In our case
# we have consul running as agents on the box
variable "additional_security_groups" {
  type    = list(string)
  default = []
}

# vms - general
variable "volume_encryption" {
  default = true
}

variable "elasticsearch_data_dir" {
  default = "/opt/elasticsearch/data"
}

variable "elasticsearch_logs_dir" {
  default = "/var/log/elasticsearch"
}

variable "ebs_optimized" {
  description = "Whether data instances are EBS optimized or not"
  default     = "true"
}

variable "elasticsearch_packer_image" {
  description = "The name of the image family for elasticsearch"
  default     = "elasticsearch7-packer-image"
}

variable "elasticsearch_blue_packer_image" {
  description = "The name of the image family for elasticsearch"
  default     = "elasticsearch7-graviton-packer-image"
}

variable "kibana_packer_image" {
  description = "The name of the image family for kibana"
  default     = "kibana7-packer-image"
}

variable "log_size" {
  description = "Retained log4j log size in MB"
  default     = "128"
}

variable "log_level" {
  description = "log4j log level"
  default     = "INFO"
}

variable "use_g1gc" {
  description = "Whether or not to enable G1GC in jvm.options ES config. Left in for backwards compatibility, deployments with Elasticsearch 7.7 and above should not use this."
  default     = false
}

# node counts
variable "masters_count" {
  type        = map(number)
  default     = {}
  description = "Master nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

variable "datas_count" {
  type        = map(number)
  default     = {}
  description = "Data nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

variable "data_voters_count" {
  type        = map(number)
  default     = {}
  description = "Data voter nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

variable "datas_blue_count" {
  type        = map(number)
  default     = {}
  description = "Data nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

variable "data_voters_blue_count" {
  type        = map(number)
  default     = {}
  description = "Data voter nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

variable "clients_count" {
  type        = map(number)
  default     = {}
  description = "Client nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

variable "masters_blue_count" {
  type        = map(number)
  default     = {}
  description = "Data voter nodes count per avalabilityZone. If all node counts are empty, will run in singlenode mode."
}

# S3
variable "s3_backup_bucket" {
  description = "S3 bucket for backups"
  default     = ""
}

variable "DEV_MODE_scripts_s3_bucket" {
  description = "S3 bucket to override init scripts from. Should not be used on production."
  default     = ""
}


# bootstrapping
variable "requires_bootstrapping" {
  description = "Overrides cluster bootstrap state"
  default     = true
}

variable "auto_shut_down_bootstrap_node" {
  description = "disable to prevent bootstrap node from shutting down"
  default = true
}

# client

variable "client_heap_size" {
  type    = string
  default = "1g"
}

# master properties
variable "master_instance_type" {
  type    = string
  default = "c5.large"
}

variable "master_heap_size" {
  type    = string
  default = "2g"
}

# data (old)
# default elasticsearch heap size
variable "data_heap_size" {
  type    = string
  default = "8g"
}

variable "elasticsearch_blue_volume_size" {
  type    = string
  default = "100" # gb
}

variable "data_instance_type" {
  type    = string
  default = "c5.2xlarge"
}

variable "disk_type" {
  description = "disk type"
  default = "gp3"
}

variable "data_disk_iops" {
  description = "data disk IOPS"
  default = "3000"
}
variable "data_disk_throughput" {
  description = "data disk throughput"
  default = "125"
}

variable "elasticsearch_volume_size" {
  type    = string
  default = "100" # gb
}

# blue
variable "blue_disk_type" {
  description = "disk type"
  default = "gp3"
}

# data blue

variable "data_blue_disk_iops" {
  description = "data disk IOPS"
  default = "3000"
}
variable "data_blue_disk_throughput" {
  description = "data disk throughput"
  default = "125"
}

variable "data_blue_instance_type" {
  type    = string
  default = "c5g.2xlarge"
}

variable "data_blue_heap_size" {
  type    = string
  default = "8g"
}

# master blue


variable "master_blue_instance_type" {
  type    = string
  default = "c6g.large"
}

variable "master_blue_heap_size" {
  type    = string
  default = "2g"
}

# monitoring 
variable "monitoring_secret_arn" {
  type        = string
}
variable "monitoring_host" {
  type        = string
}
variable "monitoring_port" {
  type        = string
}
variable "monitoring_user" {
  type        = string
}
variable "monitoring_tls_verify" {
  type        = string
  description = "On\\Off"
}
variable "monitoring_enabled" {
  description = "Whether or not to enable x-pack monitoring on the cluster"
  default     = false
}

variable "xpack_monitoring_host" {
  description = "ES host to send monitoring data"
  default     = "http://localhost:9200"
}

variable "filebeat_monitoring_host" {
  description = "ES host to send filebeat data"
  default     = false
}

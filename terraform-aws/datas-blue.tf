
module "data-blue" {
  source             = "./modules/nodegroup"
  name = "data-blue"
  count    = length(keys(var.datas_blue_count)) > 0  ? 1 : 0
  
  # nodes
  node_count = var.datas_blue_count
  singlenode_mode = false
  image = data.aws_ami.elasticsearch-blue.id
  instance_type = var.data_blue_instance_type
  heap_size = var.data_blue_heap_size
  startup_script = "data.sh"
  user_data_common = local.user_data_common
  is_voting_only = "false"
  
  # disk
  extra_disk_exists = true
  extra_disk_type = var.blue_disk_type
  extra_disk_size = var.elasticsearch_blue_volume_size
  extra_disk_iops = var.data_blue_disk_iops
  extra_disk_throughput = var.data_blue_disk_throughput
  extra_disk_encryption = var.volume_encryption
  ebs_optimized = var.ebs_optimized
  
  # auth
  instance_profile_arn = aws_iam_instance_profile.elasticsearch.arn
  security_group_ids = concat(
    [aws_security_group.elasticsearch_security_group.id],
    var.additional_security_groups,
  )
  
  # cluster
  environment = var.environment
  es_cluster = var.es_cluster
  key_name = var.key_name
  asg_subnet_ids = var.asg_subnet_ids
  depends_on = [
    aws_autoscaling_group.master_nodes
  ]
  target_group_arns = [
    aws_lb_target_group.esearch-p9200-tg.arn,
  ]
}

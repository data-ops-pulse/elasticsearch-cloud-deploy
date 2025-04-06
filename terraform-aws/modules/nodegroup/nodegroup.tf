resource "aws_launch_template" "node-group" {
  count = var.singlenode_mode ? 0 : 1
  name_prefix   = "elasticsearch-${var.es_cluster}-${var.name}-nodes"
  image_id      = var.image
  instance_type = var.instance_type
  user_data     = base64encode(templatefile("${path.module}/../../../templates/aws_user_data.sh",merge(var.user_data_common, {
    startup_script = "${var.startup_script}",
    heap_size = var.heap_size
  })))


  key_name      = var.key_name

  ebs_optimized = var.ebs_optimized

  iam_instance_profile {
    arn = var.instance_profile_arn
  }
  metadata_options {
    http_tokens = "optional"
  }
  network_interfaces {
    delete_on_termination       = true
    associate_public_ip_address = false
    security_groups = var.security_group_ids
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nodegroup-nodes" {
  count = length(keys(var.node_count))

  name               = "elasticsearch-${var.es_cluster}-${var.name}-nodes-${keys(var.node_count)[count.index]}"
  max_size           = var.node_count[keys(var.node_count)[count.index]]
  min_size           = var.node_count[keys(var.node_count)[count.index]]
  desired_capacity   = var.node_count[keys(var.node_count)[count.index]]
  default_cooldown   = 30
  force_delete       = true

  vpc_zone_identifier = var.asg_subnet_ids

  depends_on = [
    aws_ebs_volume.nodegroup-disks
  ]

  target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.node-group[0].id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = format("%s-${var.name}-node", var.es_cluster)
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = "${var.environment}-${var.es_cluster}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = var.name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

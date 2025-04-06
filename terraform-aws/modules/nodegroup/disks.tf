locals {
  nodegroup_az_flattened = var.extra_disk_exists ? toset(flatten([
    for az, count in var.node_count : [
      for i in range(0, count) : jsonencode({ "az" = az, "index" = i, "name" = "${az}-${i}" })
    ]
  ])) : toset()
}

resource "aws_ebs_volume" "nodegroup-disks" {
  for_each = local.nodegroup_az_flattened

  availability_zone = jsondecode(each.value)["az"]
  size              = var.extra_disk_size
  type              = var.extra_disk_type
  encrypted         = var.extra_disk_encryption
  iops              = var.extra_disk_iops
  throughput        = var.extra_disk_throughput

  tags = {
    Name            = "elasticsearch-${var.es_cluster}-${var.name}-${jsondecode(each.value)["name"]}"
    ClusterName     = var.es_cluster
    VolumeIndex     = jsondecode(each.value)["index"]
    AutoAttachGroup = "${var.name}"
  }
}

resource "aws_iam_role" "elasticsearch" {
  name               = "${var.es_cluster}-elasticsearch-discovery-role"
  assume_role_policy = file("${path.module}/../assets/ec2-role-trust-policy.json")
}

resource "aws_iam_role_policy" "elasticsearch" {
  name = "${var.es_cluster}-elasticsearch-node-init-policy"
  policy = templatefile(
    "${path.module}/../assets/node-init.json",{
      monitoring_secret_arn = var.monitoring_secret_arn
    }
  )
  role = aws_iam_role.elasticsearch.id
}

resource "aws_iam_role_policy" "s3_backup" {
  count  = var.s3_backup_bucket != "" ? 1 : 0
  name   = "${var.es_cluster}-elasticsearch-backup-policy"
  policy     = templatefile("${path.module}/../assets/s3-backup.json",{
    s3_backup_bucket = var.s3_backup_bucket
  })


  role   = aws_iam_role.elasticsearch.id
}

resource "aws_iam_instance_profile" "elasticsearch" {
  name = "${var.es_cluster}-elasticsearch-discovery-profile"
  path = "/"
  role = aws_iam_role.elasticsearch.name
}

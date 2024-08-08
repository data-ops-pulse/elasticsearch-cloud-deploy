data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "all-subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_route_tables" "vpc_route_tables" {
  vpc_id = var.vpc_id
}

data "aws_subnets" "subnets-per-az" {
  count  = length(local.all_availability_zones)

  filter {
    name   = "availability-zone"
    values = [local.all_availability_zones[count.index]]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

}

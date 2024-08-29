output "clients_dns" {
  value = aws_lb.elasticsearch-alb.dns_name
}

output "vm_password" {
  value = random_string.vm-login-password.result
}

output "node_security_group" {
  value = aws_security_group.elasticsearch_security_group.id
}

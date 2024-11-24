output "subnet_ids" {
  value = [for subnet in aws_subnet.dev_subnet : subnet.id ]
}
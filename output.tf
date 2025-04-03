output "ec2_public_ips" {
  description = "List of public IP addresses of the EC2 instances"
  value       = [for instance in aws_instance.my_instance : instance.public_ip]
}
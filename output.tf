output "ec2_public_ips" {
  description = "List of public IP addresses and names of the EC2 instances"
  value = [for instance in aws_instance.my_instance : {
    name      = instance.tags.Name
    public_ip = instance.public_ip
  }]
}
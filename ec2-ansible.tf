#Key Pair For Creating Instance

resource "aws_key_pair" "my_key" {
    key_name = "terra-ansible-key-ec2"
    public_key = file ("terra-ansible-key.pub")
  }

  #Create VPC (Virtual Private Cloud)

  resource "aws_default_vpc" "default" {
    
  }

  #Create a Security Group

  resource "aws_security_group" "my_security_group" {
    name = "automate-security-group"
    description = "This Will Teraform generated Security Group"
    vpc_id = aws_default_vpc.default.id

 # Add Inbound rules
 ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
 }
 #Open 80 Port
 ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
 }
 

 #OutBound Rules
 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "All Access open Outbound"
 }


 tags = {
    name ="automate-sg"
 }
}


# Create EC2 Instance
resource "aws_instance"  "my_instance" {
  for_each = tomap({
   // master-anisble="ami-0df368112825f8d8f"  #Ubuntu
    worker-1-anisble="ami-01ff9fc7721895c6b" #Amzon-Linux
    worker-2-anisble="ami-09de149defa704528" #Red-Hat
    //TWS-anisble-worker-3="ami-0df368112825f8d8f" #Ubuntu

  }#Meta Arguments

  )
  depends_on =[aws_security_group.my_security_group, aws_key_pair.my_key] 

  key_name          = aws_key_pair.my_key.key_name
  security_groups  = [aws_security_group.my_security_group.name]
  instance_type     = "t2.micro"
  ami               = each.value

  # Volume Configuration
  root_block_device { 
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}

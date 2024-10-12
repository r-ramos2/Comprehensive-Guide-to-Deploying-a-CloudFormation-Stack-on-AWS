provider "aws" {
  region = "us-east-1" # Adjust to your region
}

resource "aws_instance" "lamp" {
  ami           = "ami-12345678" # Replace with the latest Amazon Linux AMI ID
  instance_type = "t3.micro"

  tags = {
    Name = "My-LAMP-Instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd mariadb-server php php-mysqlnd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start mariadb",
      "sudo systemctl enable mariadb",
    ]
  }

  # Security group to allow HTTP traffic
  vpc_security_group_ids = [aws_security_group.lamp_sg.id]
}

resource "aws_security_group" "lamp_sg" {
  name        = "lamp_sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this for better security
  }
}

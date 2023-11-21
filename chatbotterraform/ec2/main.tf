

resource "aws_instance" "chatbot_instance" {
  ami           = "ami-0619177a5b68d29e3"  # Change to the desired AMI ID
  instance_type = "t2.micro"  # Change to the desired instance type
  key_name      = "your-key-pair"  # Change to your key pair name

  tags = {
    Name = "ChatbotInstance"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y python3
    echo -e '#!/bin/bash\npython3 ./chatbot_backend.py' | sudo tee /etc/rc.local
    sudo chmod +x /etc/rc.local
    sudo /etc/rc.local
  EOF

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/your-key-pair.pem")  # Change to your private key path
    host        = aws_instance.chatbot_instance.public_ip
  }
}



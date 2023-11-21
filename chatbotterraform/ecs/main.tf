

resource "aws_ecs_cluster" "chatbot_cluster" {
  name = "ChatbotCluster"
}

resource "aws_ecs_task_definition" "chatbot_task" {
  family                   = "ChatbotTask"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "chatbot-container",
    image = "htbBot",  # Replace with your Docker image
    portMappings = [{
      containerPort = 443,  # Adjust based on your application's port
      hostPort      = 443,
    }],
  }])
}

resource "aws_ecs_service" "chatbot_service" {
  name            = "ChatbotService"
  cluster         = aws_ecs_cluster.chatbot_cluster.id
  task_definition = aws_ecs_task_definition.chatbot_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets = ["your-subnet-1", "your-subnet-2"]  # Replace with your subnet IDs
    security_groups = ["your-security-group"]  # Replace with your security group ID
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com",
      },
    }],
  })
}


#networking

# ecs/main.tf

resource "aws_vpc" "chatbot_vpc" {
  cidr_block = "10.0.0.0/20"  # Adjust the CIDR block size as needed
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ChatbotVPC"
  }
}

resource "aws_subnet" "chatbot_subnet_a" {
  vpc_id                  = aws_vpc.chatbot_vpc.id
  cidr_block              = "10.0.0.0/22"  # Adjust the CIDR block size as needed
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ChatbotSubnetA"
  }
}

resource "aws_subnet" "chatbot_subnet_b" {
  vpc_id                  = aws_vpc.chatbot_vpc.id
  cidr_block              = "10.0.4.0/22"  # Adjust the CIDR block size as needed
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ChatbotSubnetB"
  }
}

resource "aws_subnet" "chatbot_subnet_c" {
  vpc_id                  = aws_vpc.chatbot_vpc.id
  cidr_block              = "10.0.8.0/22"  # Adjust the CIDR block size as needed
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "ChatbotSubnetC"
  }
}

resource "aws_internet_gateway" "chatbot_igw" {
  vpc_id = aws_vpc.chatbot_vpc.id

  tags = {
    Name = "ChatbotIGW"
  }
}

resource "aws_route_table" "chatbot_route_table" {
  vpc_id = aws_vpc.chatbot_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.chatbot_igw.id
  }

  tags = {
    Name = "ChatbotRouteTable"
  }
}

resource "aws_route_table_association" "chatbot_route_association_a" {
  subnet_id      = aws_subnet.chatbot_subnet_a.id
  route_table_id = aws_route_table.chatbot_route_table.id
}

resource "aws_route_table_association" "chatbot_route_association_b" {
  subnet_id      = aws_subnet.chatbot_subnet_b.id
  route_table_id = aws_route_table.chatbot_route_table.id
}

resource "aws_route_table_association" "chatbot_route_association_c" {
  subnet_id      = aws_subnet.chatbot_subnet_c.id
  route_table_id = aws_route_table.chatbot_route_table.id
}

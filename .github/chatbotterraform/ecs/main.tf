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
    image = "your-docker-image",  # Replace with your Docker image
    portMappings = [{
      containerPort = 80,  # Adjust based on your application's port
      hostPort      = 80,
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

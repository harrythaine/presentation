resource "aws_lex_bot" "chatbot" {
  name         = "MyChatbot"
  role_arn     = aws_iam_role.lex_bot_role.arn
  child_directed = false  # Set this to the appropriate value

  intent {
    name = "HelloIntent"

    fulfillment_activity {
      type = "CodeHook"
      code_hook {
        uri              = module.lambda.lambda_arn
        message_version = "1.0"
        alias           = "latest"
      }
    }

    sample_utterances = ["Hello", "Hi", "Greetings", "How can I help you?"]

    clarification_prompt {
      messages {
        content_type = "PlainText"
        content      = "I'm sorry, I didn't understand. Can you please rephrase?"
      }
    }

    conclusion_statement {
      messages {
        content_type = "PlainText"
        content      = "Hello Max, Sarah & Piotr! I hope you're doing well today, you can ask me about Harry's professional background, his education and certification, or his technical specialties?"
      }
    }

    confirmation_prompt {
      max_attempts = 2
      messages {
        content_type = "PlainText"
        content      = "Did you find the information you were looking for?"
      }
    }

    rejection_statement {
      messages {
        content_type = "PlainText"
        content      = "No worries! If you have any questions, feel free to ask."
      }
    }
  }
}

resource "aws_iam_role" "lex_bot_role" {
  name = "LexBotRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lex.amazonaws.com",
      },
    }],
  })
}



resource "aws_lex_intent" "hello_intent" {
  bot_name = aws_lex_bot.chatbot.name
  name     = "HelloIntent"

  fulfillment_activity {
    type = "CodeHook"
    code_hook {
    #  uri              = module.lambda.lambda_arn
      message_version = "1.0"
      alias           = "latest"
    }
  }

  sample_utterances = [
    "Hello", "Hi", "Greetings", "How can I help you?",
    "professional background", "background", "professional",
    "eduation and certication", "certication", "eduation",
    "techincal specialities", "specialities", "techincal",
  ]

  conclusion_statement {
    messages = [
      {
        content_type = "PlainText",
        content      = "Hello Max, Sarah & Piotr! I hope you're doing well today, you can ask me about Harry's professional background, his education and certification or his technical specialties?",
      },
      {
        content_type = "PlainText",
        content      = "Harry's worked in the IT Industry for almost 5 years! He started his career as an IT Operations graduate at BGL Group, was later promoted to a DevOps Engineer and finally moved on to become a level 3 AWS Engineer at Telefonica Tech! Anything else I can help you with?",
      },
      {
        content_type = "PlainText",
        content      = "Of course! Harry has a Forensic Computing Degree from De Montfort University, in which he achieved a 2:1! Later on, he went on to get certified in AWS with both the solution architect Associate and professional certifications! Anything else I can help you with?",
      },
      {
        content_type = "PlainText",
        content      = "No problem! If you change your mind or have any other questions, feel free to ask.",
      },
      {
        content_type = "PlainText",
        content      = "Harry has specialized himself in the Cloud and all the fun that comes with it! with experience in both Azure/AWS, Console/CLI and programming with products such as Terraform, YML for CI/CD and scripting in PowerShell or Python (Python was used in this project!).",
      },
    ]
  }

  confirmation_prompt {
    max_attempts = 2
    messages = [
      {
        content_type = "PlainText",
        content      = "Did you find the information you were looking for?",
      },
    ]
  }

  rejection_statement {
    messages = [
      {
        content_type = "PlainText",
        content      = "No worries! If you have any questions, feel free to ask.",
      },
    ]
  }
}

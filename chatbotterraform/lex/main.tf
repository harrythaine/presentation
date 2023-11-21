

module "lambda" {
  source              = "../lambda"
  lambda_environment  = {
    # Add other environment variables as needed
  }
}

resource "aws_lex_bot" "chatbot" {
  name           = "MyChatbot"
  child_directed = false

  abort_statement {
    message {
      content_type = "PlainText"
      content      = "Sorry, I couldn't understand. Can you please rephrase?"
    }
  }

  clarification_prompt {
    max_attempts = 3  # Adjust this value as needed

    message {
      content_type = "PlainText"
      content      = "I'm sorry, I didn't understand. Can you please rephrase?"
    }
  }

  idle_session_ttl_in_seconds = 300

  voice_id = "Brian"

  locale = "en-GB"

  nlu_intent_confidence_threshold = 0.4

  process_behavior = "BUILD"

  intent {
    intent_name    = "HelloIntent"
    intent_version = aws_lex_intent.hello_intent.version
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
  name = "HelloIntent"

  fulfillment_activity {
    type = "CodeHook"
    code_hook {
      uri              = module.lambda.lambda_arn
      message_version = "1.0"
    }
  }

  sample_utterances = [
    "Hello", "Hi", "Greetings", "How can I help you?",
    "professional background", "background", "professional",
    "education and certification", "certification", "education",
    "technical specialties", "specialties", "technical",
  ]

  conclusion_statement {
    message {
      content_type = "PlainText"
      content      = "Hello Max, Sarah & Piotr! I hope you're doing well today. You can ask me about Harry's professional background, his education and certification, or his technical specialties?"
    }
  }

  confirmation_prompt {
    max_attempts = 2
    message {
      content_type = "PlainText"
      content      = "Did you find the information you were looking for?"
    }
  }

  rejection_statement {
    message {
      content_type = "PlainText"
      content      = "No worries! If you have any questions, feel free to ask."
    }
  }
}

# Outputs can be added if needed

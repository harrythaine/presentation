def lambda_handler(event, context):
    intent_name = event['currentIntent']['name']

    if intent_name == 'HelloIntent':
        return handle_hello_intent()
    elif intent_name == 'ProfessionalBackgroundIntent':
        return handle_professional_background_intent()
    elif intent_name == 'EducationCertificationIntent':
        return handle_education_certification_intent()
    elif intent_name == 'TechnicalSpecialtiesIntent':
        return handle_technical_specialties_intent()
    else:
        return handle_default_intent()

def handle_hello_intent():
    response_text = "Hello Max, Sarah & Piotr! I hope you're doing well today. You can ask me about Harry's professional background, his education and certification, or his technical specialties."
    return build_fulfillment_response(response_text)

def handle_professional_background_intent():
    response_text = "Harry's worked in the IT Industry for almost 5 years! He started his career as an IT Operations graduate at BGL Group, was later promoted to a DevOps Engineer and finally moved on to become a level 3 AWS Engineer at Telefonica Tech! Anything else I can help you with?"
    return build_fulfillment_response(response_text)

def handle_education_certification_intent():
    response_text = "Of course! Harry has a Forensic Computing Degree from De Montfort University, in which he achieved a 2:1! Later on, he went on to get certified in AWS with both the Solution Architect Associate and Professional certifications! Anything else I can help you with?"
    return build_fulfillment_response(response_text)

def handle_technical_specialties_intent():
    response_text = "Harry has specialized himself in the Cloud and all the fun that comes with it! With experience in both Azure/AWS, Console/CLI, and programming with products such as Terraform, YML for CI/CD, and scripting in PowerShell or Python (Python was used in this project!)."
    return build_fulfillment_response(response_text)

def handle_default_intent():
    response_text = "I'm sorry, I didn't understand that. Please feel free to ask another question."
    return build_fulfillment_response(response_text)

def build_fulfillment_response(message):
    return {
        'sessionAttributes': {},
        'dialogAction': {
            'type': 'Close',
            'fulfillmentState': 'Fulfilled',
            'message': {
                'contentType': 'PlainText',
                'content': message,
            },
        },
    }

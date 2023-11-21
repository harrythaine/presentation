# Example Python script (save as chatbot_backend.py)
def handle_intent(intent):
    # Your chatbot logic here
    return f"Received intent: {intent}"

if __name__ == "__main__":
    intent = input("Enter an intent: ")
    result = handle_intent(intent)
    print(result)

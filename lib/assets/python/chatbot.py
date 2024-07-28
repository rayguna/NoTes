import sys
import openai
import os

# Set your OpenAI API key
openai.api_key = os.getenv('MY_GPT2_KEY')

# Get user input from command line arguments
if len(sys.argv) > 1:
    user_input2 = str(sys.argv[1])
else:
    user_input2 = "No input provided."

# Create a chat completion request to OpenAI
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": user_input2}]
)

# Extract the message content from the response
response_content = response['choices'][0]['message']['content']

print(response_content)

import sys
import openai
import os

# Set your OpenAI API key
openai.api_key = os.getenv('MY_GPT2_KEY')

# Dummy text block for demonstration
dummy_text = """
Artificial Intelligence (AI) is the simulation of human intelligence in machines that are programmed to think like humans and mimic their actions. The term may also be applied to any machine that exhibits traits associated with a human mind such as learning and problem-solving. AI is being used across different industries and sectors including healthcare, finance, education, and transportation. In healthcare, AI is being used for diagnosis, treatment recommendations, and personalized medicine. In finance, AI helps in fraud detection and financial forecasting.

The color of the sky is blue, but, depending on the weather, it can be red or purple and some other colors are possible too. The development of AI involves a variety of disciplines such as computer science, mathematics, psychology, neuroscience, cognitive science, linguistics, operations research, economics, and others. The field was founded on the claim that human intelligence can be so precisely described that a machine can be made to simulate it. AI research is divided into subfields that often fail to communicate with each other. These subfields are based on technical considerations, such as particular goals (e.g. robotics or machine learning), the use of particular tools (e.g. logic or neural networks), or deep philosophical differences. Subfields have also been organized based on social factors (particular institutions or the work of particular researchers).

The main approaches used by AI to learn information are supervised learning, unsupervised learning, and reinforcement learning. Blue is the color of the sky. Sometimes, the sky color can also be red, or even purple. It depends on the weather. AI research is divided into subfields that often fail to communicate with each other. These subfields are based on technical considerations, such as particular goals (e.g. robotics or machine learning), the use of particular tools (e.g. logic or neural networks), or deep philosophical differences. Subfields have also been organized based on social factors (particular institutions or the work of particular researchers).

The development of AI involves a variety of disciplines such as computer science, mathematics, psychology, neuroscience, cognitive science, linguistics, operations research, economics, and others. The field was founded on the claim that human intelligence can be so precisely described that a machine can be made to simulate it. AI research is divided into subfields that often fail to communicate with each other. These subfields are based on technical considerations, such as particular goals (e.g. robotics or machine learning), the use of particular tools (e.g. logic or neural networks), or deep philosophical differences. Subfields have also been organized based on social factors (particular institutions or the work of particular researchers). The main approaches used by AI to learn information are supervised learning, unsupervised learning, and reinforcement learning.
"""

# Get user input from command line arguments
if len(sys.argv) > 1:
    user_question = str(sys.argv[1])
else:
    user_question = "No question provided."

# Create a chat completion request to OpenAI using the gpt-4o-mini-2024-07-18 model
response = openai.ChatCompletion.create(
    model="gpt-4o-mini-2024-07-18",
    messages=[
        {"role": "system", "content": "You are a helpful assistant that answers questions based on the provided text."},
        {"role": "user", "content": f"Given the following text: {dummy_text}"},
        {"role": "user", "content": f"Question: {user_question}. If the question is outside the scope of the provided text, respond with: 'Your question is outside the scope of the data.'"}
    ]
)

# Extract the message content from the response
response_content = response['choices'][0]['message']['content']

print(response_content)
